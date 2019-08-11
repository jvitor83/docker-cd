# FROM newtmitch/sonar-scanner AS sonar
# # RUN sonar-scanner
# ARG SONARQUBE=http://localhost:9000
# ENV SONARQUBE=${SONARQUBE}
# RUN sonar-scanner -Dsonar.host.url=${SONARQUBE}

FROM node:10 as build
WORKDIR /app/
# Sonarqube
# RUN apt-get update && apt-get install -y openjdk-8-jdk
# RUN curl --insecure -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.0.0.1744-linux.zip && \
# 	unzip sonarscanner.zip && \
# 	rm sonarscanner.zip && \
# 	mv sonar-scanner-4.0.0.1744-linux /usr/lib/sonar-scanner && \
# 	ln -s /usr/lib/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner
# # RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /usr/local/bin/sonar-scanner

# Chrome
# RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install
# ENV CHROME_BIN=/usr/bin/google-chrome PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# If running Docker >= 1.13.0 use docker run's --init arg to reap zombie processes, otherwise
# uncomment the following lines to have `dumb-init` as PID 1
# ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
# RUN chmod +x /usr/local/bin/dumb-init
# ENTRYPOINT ["dumb-init", "--"]

# Uncomment to skip the chromium download when installing puppeteer. If you do,
# you'll need to launch puppeteer with:
#     browser.launch({executablePath: 'google-chrome-unstable'})
# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true



# Build
RUN npm install -g sonarqube-scanner
COPY package.json package-lock.json ./
RUN npm ci
COPY . ./



ARG SONARQUBE=http://localhost:9000
ARG SONARQUBE_PROJECT
ENV SONARQUBE=${SONARQUBE} SONARQUBE_PROJECT=${SONARQUBE_PROJECT}
# RUN [ $SONARQUBE != "" ] && sonar-scanner -Dsonar.projectKey=${SONARQUBE_PROJECT} -Dsonar.projectName=${SONARQUBE_PROJECT} -Dsonar.host.url=${SONARQUBE}

RUN npm run build

# FROM build as ci
# ENTRYPOINT ["npm", "test", "--", "--watch=false", "--browsers=ChromeHeadless", "--code-coverage"]
ENTRYPOINT ["./entrypoint.sh"]

FROM nginx:1.17 as final
RUN echo 'final'
COPY --from=build /app/dist/ /usr/share/nginx/html/
ENTRYPOINT ["nginx", "-g", "daemon off;"]

FROM bitnami/kubectl:1.15 as release
RUN echo 'release'
