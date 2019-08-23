# RELEASE Branch
clear
rm -rf ./docker-extract/
mkdir -p ./docker-extract/app
# docker system prune -f

## BUILD
export DOCKER_REGISTRY=nexusdocker.tjmt.jus.br/dsa/teste/
export VERSION=20190822.1
export BRANCH=release-1
export SONARQUBE_URL="http://sonarqube.tjmt.jus.br"
export SONARQUBE_LOGIN="c29b8801c173a4d9605a5eba61a069272b80dc7c"

export ARTIFACT_STAGING_DIRECTORY="./docker-extract"

echo "-------------------------------------------"
echo "Restauro pacotes e Rodo os testes"
export DOCKERCOMPOSE_BUILD_VOLUME_NAME="sistema-extract-testresults"
export DOCKERCOMPOSE_BUILD_CONTAINER_NAME="container-testResults"
export DOCKERCOMPOSE_BUILD_TEST_RESULT_PATH="/TestResults"

docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" push

echo "Extraindo os resultados dos testes"
docker create --name $DOCKERCOMPOSE_BUILD_CONTAINER_NAME -v $DOCKERCOMPOSE_BUILD_VOLUME_NAME:$DOCKERCOMPOSE_BUILD_TEST_RESULT_PATH busybox
docker cp $DOCKERCOMPOSE_BUILD_CONTAINER_NAME:$DOCKERCOMPOSE_BUILD_TEST_RESULT_PATH $ARTIFACT_STAGING_DIRECTORY
docker rm $DOCKERCOMPOSE_BUILD_CONTAINER_NAME

echo "Down no compose de build para remover os volumes"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" down -v
echo "-------------------------------------------"


echo ""
echo "-------------------------------------------"
echo "Compilo o projeto e crio o pacote"
export DOCKERCOMPOSE_PUBLISH_VOLUME_NAME="sistema-extract-publish"
export DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME="container-publish"
export DOCKERCOMPOSE_PUBLISH_APP_PATH="/app"


docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" up --build --abort-on-container-exit

echo "Extraindo o artefato app/dist e /app/package"
docker create --name $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME -v $DOCKERCOMPOSE_PUBLISH_VOLUME_NAME:$DOCKERCOMPOSE_PUBLISH_APP_PATH busybox
docker cp $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME:$DOCKERCOMPOSE_PUBLISH_APP_PATH/dist $ARTIFACT_STAGING_DIRECTORY/app/dist
docker cp $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME:$DOCKERCOMPOSE_PUBLISH_APP_PATH/package $ARTIFACT_STAGING_DIRECTORY/app/package
docker rm $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME

echo "Down no compose de publish para remover os volumes"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" down -v
echo "-------------------------------------------"


# echo ""
# echo "-------------------------------------------"
# echo "Crio a imagem final"
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" build
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" push
# echo "-------------------------------------------"


# ##-------------- RELEASE
# export NPM_USER=admin
# export NPM_PASS=pwd
# export NPM_EMAIL=email@email.com
# export NPM_REGISTRY="http://npm.tjmt.jus.br/repository/npm-hosted"
# export PACKAGES_FOLDER="./docker-extract/app/package"
# export KUBERNETES_FOLDER="."


# export ENVIRONMENT=dev
# export NPM_SUFFIX=dev
# echo "---------Publico a imagem final em dev"
# docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
# docker-compose -f "docker-compose.cd-release.yml" down -v
# rm -rf *.yaml

# echo "---------Publico a imagem final em qa"
# export ENVIRONMENT=qa
# export NPM_SUFFIX=qa
# docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
# docker-compose -f "docker-compose.cd-release.yml" down -v
# rm -rf *.yaml

# echo "---------Publico a imagem final em stage"
# export ENVIRONMENT=stage
# export NPM_SUFFIX=stage
# docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
# docker-compose -f "docker-compose.cd-release.yml" down -v
# rm -rf *.yaml

# echo "---------Publico a imagem final em prod"
# export ENVIRONMENT=prod
# export NPM_SUFFIX=""
# docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
# docker-compose -f "docker-compose.cd-release.yml" down -v
# rm -rf *.yaml