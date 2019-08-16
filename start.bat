echo "Restauro pacotes e Rodo os testes"
SET BRANCH=-release-123&& docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" up --build --abort-on-container-exit
echo "Compilo o projeto e crio o pacote"
SET BRANCH=-release-123&& docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" build
echo "Crio a imagem final"
SET BRANCH=-release-123&& docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" build
echo "Publico a imagem final em dev"
SET ENVIRONMENT=dev&& SET BRANCH=-release-123&& echo "BRANCH %BRANCH%" && docker-compose -f "docker-compose.yml" -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
REM echo "Publico a imagem final em qa"
REM SET ENVIRONMENT=qa&& SET BRANCH=-release-123&& docker-compose -f "docker-compose.yml" -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
REM echo "Publico a imagem final em prod"
REM SET ENVIRONMENT=prod&& docker-compose -f "docker-compose.yml" -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
