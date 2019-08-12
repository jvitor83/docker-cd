FROM node:10 as base
WORKDIR /app/

RUN wget --no-check-certificate -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
ENV NODE_TLS_REJECT_UNAUTHORIZED=0


FROM base as ci
COPY package.json package-lock.json .npmrc ./
RUN npm ci
COPY . ./
ENTRYPOINT ["./entrypoint.sh"]


FROM ci as build
RUN npm run build


FROM nginx:1.17 as final
COPY --from=build /app/dist/ /usr/share/nginx/html/
ENTRYPOINT ["nginx", "-g", "daemon off;"]


FROM bitnami/kubectl:1.15 as publish
RUN echo 'publish'
