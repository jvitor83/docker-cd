#!/bin/bash

echo "Iniciando entrypoint"

if [[ ${RUN_TEST} = "true" ]]; then
    echo "--- Iniciando npm test"
    npm test -- --watch=false --browsers=ChromeHeadlessNoSandbox --code-coverage || true;
    
    echo "--- Iniciando e2e"
    npm run e2e || true;

    if [[ ${RUN_SONARQUBE} != "" ]]; then
        sonar-scanner -Dsonar.projectKey="${SONARQUBE_PROJECT}" -Dsonar.projectName="${SONARQUBE_PROJECT}" -Dsonar.host.url="${SONARQUBE_URL}" -Dsonar.projectVersion="${SONARQUBE_PROJECT_VERSION}" -Dsonar.login="${SONARQUBE_LOGIN}" -Dsonar.password="${SONARQUBE_PASSWORD}" || true;
    fi
fi

[ $RUN_PROJECT = "true" ] && npm run start
