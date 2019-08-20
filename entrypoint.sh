#!/bin/bash
# npm test -- --watch=false --browsers=ChromeHeadless --code-coverage
[ $RUN_TEST = "true" ] && npm run e2e || true
[[ $RUN_TEST = "true" && $RUN_SONARQUBE = "true" ]] && sonar-scanner -Dsonar.projectKey="${SONARQUBE_PROJECT}" -Dsonar.projectName="${SONARQUBE_PROJECT}" -Dsonar.host.url="${SONARQUBE_URL}" -Dsonar.projectVersion="${SONARQUBE_PROJECT_VERSION}" -Dsonar.login="${SONARQUBE_LOGIN}" -Dsonar.password="${SONARQUBE_PASSWORD}" || true
[ $RUN_PROJECT = "true" ] && npm run start
