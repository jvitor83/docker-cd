
##-------------- RELEASE

export DOCKER_REGISTRY=nexusdocker.tjmt.jus.br/dsa/teste/
export VERSION=20190910-1
export BRANCH=1234
export DEPLOY_NPM="false"
export DEPLOY_KUBERNETES="false"
export DESTROY_KUBERNETES_ENVIRONMENT="true"


echo
echo "---------Destruo o ambiente de dev no kubernetes"
export ENVIRONMENT=dev
docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down