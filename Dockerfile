FROM node:10 as build
WORKDIR /app/

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./
RUN npm ci
COPY . ./
RUN npm run build
ENTRYPOINT ["./entrypoint.sh"]


FROM nginx:1.17 as final
COPY --from=build /app/dist/ /usr/share/nginx/html/
ENTRYPOINT ["nginx", "-g", "daemon off;"]


FROM bitnami/kubectl:1.15 as release
RUN echo 'release'
