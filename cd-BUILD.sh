clear
rm -rf ./docker-extract/
mkdir ./docker-extract/

#Essas variaveis precisam estar na release também
export DOCKER_REGISTRY=nexusdocker.tjmt.jus.br/dsa/teste/
export VERSION=20190910-1
export BRANCH=1234

export SONARQUBE_URL="http://sonarqube.tjmt.jus.br"
export SONARQUBE_LOGIN="c29b8801c173a4d9605a5eba61a069272b80dc7c"
export ARTIFACT_STAGING_DIRECTORY="./docker-extract"
export RUN_TEST="false"
export RUN_PROJECT="false"
export RUN_SONARQUBE="false"

echo "-------------------------------------------"
echo "Restauro pacotes e Rodo os testes"
export DOCKERCOMPOSE_BUILD_VOLUME_NAME="uikit-seed-extract-testresults"
export DOCKERCOMPOSE_BUILD_CONTAINER_NAME="container-testResults"
export DOCKERCOMPOSE_BUILD_TEST_RESULT_PATH="/TestResults"

docker-compose -f "docker-compose.yml" -f "docker-compose.cd-ci.yml" up --build --abort-on-container-exit
#docker-compose -f "docker-compose.yml" -f "docker-compose.cd-ci.yml" push

if [[ ${RUN_TEST} == "true" ]]; then
    echo "Extraindo os resultados dos testes"
    docker create --name $DOCKERCOMPOSE_BUILD_CONTAINER_NAME -v $DOCKERCOMPOSE_BUILD_VOLUME_NAME:$DOCKERCOMPOSE_BUILD_TEST_RESULT_PATH busybox
    docker cp $DOCKERCOMPOSE_BUILD_CONTAINER_NAME:$DOCKERCOMPOSE_BUILD_TEST_RESULT_PATH $ARTIFACT_STAGING_DIRECTORY/TestResults
    docker rm $DOCKERCOMPOSE_BUILD_CONTAINER_NAME
    echo "-------------------------------------------"
fi


echo ""
echo "-------------------------------------------"
echo "Compilo o projeto e crio o pacote"
export DOCKERCOMPOSE_PUBLISH_VOLUME_NAME="uikit-seed-extract-publish"
export DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME="container-publish"
export DOCKERCOMPOSE_PUBLISH_APP_PATH="/var/release/"

docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" up --build --abort-on-container-exit
#docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" push

echo "Extraindo o artefatos"
docker create --name $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME -v $DOCKERCOMPOSE_PUBLISH_VOLUME_NAME:$DOCKERCOMPOSE_PUBLISH_APP_PATH busybox
docker cp $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME:$DOCKERCOMPOSE_PUBLISH_APP_PATH $ARTIFACT_STAGING_DIRECTORY/artefatos
docker rm $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME


echo ""
echo "-------------------------------------------"
echo "Crio a imagem final"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" build
#docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" push
echo "-------------------------------------------"


# echo ""
# echo "-------------------------------------------"
# echo "docker-compose down build"
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-ci.yml" down -v --rmi all --remove-orphans
# echo "docker-compose down publish"
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" down -v --rmi all --remove-orphans
# echo "docker-compose down final"
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" down -v --rmi all --remove-orphans
# echo "-------------------------------------------"

