# RELEASE Branch

docker system prune -f

## BUILD
export DOCKER_REGISTRY=nexusdocker.tjmt.jus.br/dsa/teste/
export VERSION=20190819.5
export BRANCH=release-4567

echo "-------------------------------------------"
echo "Restauro pacotes e Rodo os testes"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" push

echo ""
echo "-------------------------------------------"
echo "Compilo o projeto e crio o pacote"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" build
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" push

echo ""
echo "-------------------------------------------"
echo "Crio a imagem final"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" build
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" push

# testar cache_from
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" -f "docker-compose.cd-publish.yml" -f "docker-compose.cd-final.yml" down --rmi all --volumes --remove-orphans
docker system prune -f


## RELEASE
echo "-------------------------------------------"
echo "Deve ter cache a partir daqui"

export DOCKER_REGISTRY=nexusdocker.tjmt.jus.br/dsa/teste/
export VERSION=20190819.5
export BRANCH=release-4567
export ENVIRONMENT=dev

# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" build
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" push
echo "Publico a imagem final em dev"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit


export BRANCH=release-4567
export ENVIRONMENT=qa

# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" build
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" push
echo "Publico a imagem final em qa"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit


export BRANCH=release-4567
export ENVIRONMENT=stage

# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" build
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" push
echo "Publico a imagem final em qa"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit


export BRANCH=release-4567
export ENVIRONMENT=prod

# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" build
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" push
echo "Publico a imagem final em qa"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit

