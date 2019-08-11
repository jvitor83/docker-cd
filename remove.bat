docker-compose -f "docker-compose.build.yml" down -v --remove-orphans --rmi all
docker-compose -f "docker-compose.ci.yml" down -v --remove-orphans --rmi all
docker-compose -f "docker-compose.release.yml" down -v --remove-orphans --rmi all