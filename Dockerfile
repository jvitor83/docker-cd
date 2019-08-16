FROM node:10 as build

RUN wget --no-check-certificate -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
ENV NODE_TLS_REJECT_UNAUTHORIZED=0

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


# kubectl
RUN wget --no-check-certificate -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubectl-1.15.2-0-linux-amd64-debian-9.tar.gz && \
    echo "ec0dc6756050222d6cd894bb6f616a7f0f2dfd07a853a734ebec1b43b6455bef  /tmp/bitnami/pkg/cache/kubectl-1.15.2-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubectl-1.15.2-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubectl-1.15.2-0-linux-amd64-debian-9.tar.gz
RUN chmod +x /opt/bitnami/kubectl/bin/kubectl
ENV PATH="/opt/bitnami/kubectl/bin:$PATH"


WORKDIR /app/
COPY package.json package-lock.json .npmrc ./
RUN npm ci
COPY . ./
EXPOSE 4200
ENTRYPOINT ["./entrypoint.sh"]


FROM build as publish
RUN npm run build -- --aot=true --build-optimizer=true --optimization=true --prod


FROM nginx:1.17 as final
COPY --from=publish /app/dist/ /usr/share/nginx/html/
EXPOSE 80 443
ENTRYPOINT ["nginx", "-g", "daemon off;"]


FROM build as release
ENTRYPOINT ["./release.sh"]
# ARG ENVIRONMENT=dev
# ARG COMPOSE_FILENAME=docker-compose.${ENVIRONMENT}.yml
# RUN [[ -f ${COMPOSE_FILENAME} ]] && ./kompose convert -f docker-compose.yml -f ${COMPOSE_FILENAME} \
# rm -rf *.yml .*.json *.json \
# for file in *-namespace.yaml; \
# do \
#   kubectl --kubeconfig /bitnami/kubeconfig apply -f $file \
# done; \
# kubectl --kubeconfig /bitnami/kubeconfig apply -f ./
