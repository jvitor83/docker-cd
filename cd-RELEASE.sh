
##-------------- RELEASE
export DOCKER_REGISTRY=nexusdocker.tjmt.jus.br/dsa/teste/
export VERSION=20190822.1
export BRANCH=release-1

export NPM_USER=admin
export NPM_PASS=pwd
export NPM_EMAIL=email@email.com
export NPM_REGISTRY="http://npm.tjmt.jus.br/repository/npm-hosted"
export PACKAGES_FOLDER="./docker-extract/app/package/npm"
export KUBERNETES_FOLDER="."


export ENVIRONMENT=dev
export NPM_SUFFIX=dev
echo "---------Publico a imagem final em dev"
docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down -v
rm -rf *.yaml

echo "---------Publico a imagem final em qa"
export ENVIRONMENT=qa
export NPM_SUFFIX=qa
docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down -v
rm -rf *.yaml

echo "---------Publico a imagem final em stage"
export ENVIRONMENT=stage
export NPM_SUFFIX=stage
docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down -v
rm -rf *.yaml

echo "---------Publico a imagem final em prod"
export ENVIRONMENT=prod
export NPM_SUFFIX=""
docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down -v
rm -rf *.yaml