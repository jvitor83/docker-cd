# RELEASE Branch
clear
rm -rf ./docker-extract/
mkdir -p ./docker-extract/app
# docker system prune -f

## BUILD
export DOCKER_REGISTRY=nexusdocker.tjmt.jus.br/dsa/teste/
export VERSION=20190819.7
export BRANCH=release-123

echo "-------------------------------------------"
echo "Restauro pacotes e Rodo os testes"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" push

echo "Extraindo os resultados dos testes"
export CONTAINER_NAME=Container-TestResults
export VOLUME_NAME=sistema-test-results
docker create --name $CONTAINER_NAME -v $VOLUME_NAME:/TestResults busybox
docker cp $CONTAINER_NAME:/TestResults ./docker-extract
docker rm $CONTAINER_NAME

echo "Down no compose de build para remover os volumes"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" down -v
echo "-------------------------------------------"


echo ""
echo "-------------------------------------------"
echo "Compilo o projeto e crio o pacote"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" up --build --abort-on-container-exit

echo "Extraindo o artefato app/dist e /app/package"
export CONTAINER_NAME=Container-App
export VOLUME_NAME=sistema-extract-app
docker create --name $CONTAINER_NAME -v $VOLUME_NAME:/app busybox
docker cp $CONTAINER_NAME:/app/dist ./docker-extract/app
docker cp $CONTAINER_NAME:/app/package ./docker-extract/app
docker rm $CONTAINER_NAME

echo "Down no compose de publish para remover os volumes"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" down -v
echo "-------------------------------------------"


echo ""
echo "-------------------------------------------"
echo "Crio a imagem final"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" build
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" push
echo "-------------------------------------------"


##-------------- RELEASE
export NPM_USER=admin
export NPM_PASS=pwd
export NPM_EMAIL=email@email.com
export NPM_REGISTRY=""
#http://npm.tjmt.jus.br/repository/npm-hosted

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