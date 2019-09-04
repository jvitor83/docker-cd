FROM nexusdocker.tjmt.jus.br/dsa/node:10 as base


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




FROM nexusdocker.tjmt.jus.br/dsa/publicador:latest as release
ARG VERSION=latest
ARG BRANCH
ENV VERSION=${VERSION}
ENV BRANCH=${BRANCH}

#Source/Kubernetes
COPY . /var/release/source/
#Runtime
COPY --from=publish /app/dist/ /var/release/www
#Packages
COPY --from=publish /app/package /var/release/packages/npm



FROM nginx:1.17 as final
COPY --from=publish /app/dist/ /usr/share/nginx/html/
EXPOSE 80 443
ENTRYPOINT ["nginx", "-g", "daemon off;"]