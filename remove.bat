docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" down -v --remove-orphans --rmi all
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" down -v --remove-orphans --rmi all
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" down -v --remove-orphans --rmi all
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-release.yml" down -v --remove-orphans --rmi all
