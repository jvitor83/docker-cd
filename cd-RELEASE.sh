
##-------------- RELEASE

export DOCKER_REGISTRY=nexusdocker.tjmt.jus.br/dsa/teste/
export VERSION=20190904-1
export BRANCH=us666

export DEPLOY_NPM="false"
export DEPLOY_KUBERNETES="true"
export ENVIRONMENT=dev
export NPM_LIFE_CICLE_VERSION=dev

echo "---------Publico a imagem final em dev"
docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down

# echo "---------Publico a imagem final em qa"
# export ENVIRONMENT=qa
# export NPM_LIFE_CICLE_VERSION=qa
# docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
# docker-compose -f "docker-compose.cd-release.yml" down

# echo "---------Publico a imagem final em stage"
# export ENVIRONMENT=stage
# export NPM_LIFE_CICLE_VERSION=stage
# docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
# docker-compose -f "docker-compose.cd-release.yml" down

# echo "---------Publico a imagem final em prod"
# export ENVIRONMENT=prod
# export NPM_LIFE_CICLE_VERSION=""
# docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
# docker-compose -f "docker-compose.cd-release.yml" down