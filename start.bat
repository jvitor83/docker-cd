REM echo "Crio a imagem que irá possuir as ferramentas para compilação e execução dos testes"
REM docker-compose -f "docker-compose.yml" -f "docker-compose.cd-install.yml" build
REM echo "Compilo o projeto"
REM docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" build
REM echo "Rodo os testes"
REM docker-compose -f "docker-compose.yml" -f "docker-compose.cd-ci.yml" up
REM echo "Crio a imagem final"
REM docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" build
REM echo "Publico a imagem final"
REM docker-compose -f "docker-compose.yml" -f "docker-compose.cd-release.yml" build


echo "Crio a imagem que irá possuir as ferramentas para compilação e execução dos testes"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" build
echo "Rodo os testes"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" up
echo "Crio a imagem final"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" build
echo "Publico a imagem final"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-release.yml" build
