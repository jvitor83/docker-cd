FROM nexusdocker.tjmt.jus.br/dsa/node:10 as base


FROM base as ci
WORKDIR /app
COPY package.json package-lock.json .npmrc ./
RUN npm ci
COPY . ./
EXPOSE 4200
ENTRYPOINT ["/entrypoint/entrypoint.sh"]


FROM ci as build
#Angular não precisa fazer nada


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
COPY . ./source
#Runtime
COPY --from=publish /app/dist/ ./www
#Packages
COPY --from=publish /app/package ./packages/npm



FROM nginx:1.17 as final
COPY --from=publish /app/dist/ /usr/share/nginx/html/
EXPOSE 80 443
ENTRYPOINT ["nginx", "-g", "daemon off;"]