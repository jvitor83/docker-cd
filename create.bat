docker-compose -f "docker-compose.build.yml" up -d --build
docker-compose -f "docker-compose.ci.yml" up -d --build
docker-compose -f "docker-compose.release.yml" up -d --build