
##-------------- RELEASE

export DOCKER_REGISTRY=nexusdocker.tjmt.jus.br/dsa/teste/
export VERSION=20190822.1
export BRANCH=release-1

export DEPLOY_NPM="true"
export DEPLOY_KUBERNETES="true"
export ENVIRONMENT=dev
export NPM_LIFE_CICLE_VERSION=dev

echo "---------Publico a imagem final em dev"
docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down -v
rm -rf *.yaml

echo "---------Publico a imagem final em qa"
export ENVIRONMENT=qa
export NPM_LIFE_CICLE_VERSION=qa
docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down -v
rm -rf *.yaml

echo "---------Publico a imagem final em stage"
export ENVIRONMENT=stage
export NPM_LIFE_CICLE_VERSION=stage
docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down -v
rm -rf *.yaml

echo "---------Publico a imagem final em prod"
export ENVIRONMENT=prod
export NPM_LIFE_CICLE_VERSION=""
docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down -v
rm -rf *.yaml