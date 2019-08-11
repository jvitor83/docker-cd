echo "Crio a imagem que irá possuir os artefatos compilados e irá rodar os testes"
docker-compose -f "docker-compose.build.yml" build
echo "Rodo os testes"
docker-compose -f "docker-compose.build.yml" up
echo "Crio a imagem final"
docker-compose -f "docker-compose.final.yml" build
echo "Publico a imagem final"
docker-compose -f "docker-compose.release.yml" build
