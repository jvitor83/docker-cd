FROM node:10 as base

RUN wget --no-check-certificate -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
ENV NODE_TLS_REJECT_UNAUTHORIZED=0
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

ENV SONAR_SCANNER_NPM_VERSION="2.5.0"
ENV SONAR_SCANNER_CLI_VERSION="4.0.0.1744"
ENV SONAR_SCANNER_FILE_NAME="sonar-scanner-cli-${SONAR_SCANNER_CLI_VERSION}-linux.zip"
ENV URL_SONAR_SCANNER="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/${SONAR_SCANNER_FILE_NAME}"
ENV PATH_NATIVE_SONAR_SCANNER="/root/.sonar/native-sonar-scanner"
RUN npm config set strict-ssl false && \
    npm install -g sonarqube-scanner@${SONAR_SCANNER_NPM_VERSION}
WORKDIR ${PATH_NATIVE_SONAR_SCANNER}
RUN curl -sOSL -k --no-buffer ${URL_SONAR_SCANNER} && \
unzip ${PATH_NATIVE_SONAR_SCANNER}/${SONAR_SCANNER_FILE_NAME} && \
rm ${PATH_NATIVE_SONAR_SCANNER}/${SONAR_SCANNER_FILE_NAME}

FROM base as build
WORKDIR /app
COPY package.json package-lock.json .npmrc ./
RUN npm ci
COPY . ./
EXPOSE 4200
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

FROM build as publish
WORKDIR /app
RUN npm run build -- --aot=true --build-optimizer=true --optimization=true --prod
RUN npm pack
RUN mkdir -p /app/package && mv *.tgz /app/package

FROM nexusdocker.tjmt.jus.br/dsa/publisher:latest as release
#Source
COPY . /var/run/kubernetes/

#Runtime
COPY --from=publish /app/dist/ /var/run/www

#Packages
COPY --from=publish /app/package /var/run/packages/npm

FROM nginx:1.17 as final
COPY --from=publish /app/dist/ /usr/share/nginx/html/
EXPOSE 80 443
ENTRYPOINT ["nginx", "-g", "daemon off;"]