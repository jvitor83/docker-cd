#!/bin/bash

echo "Iniciando entrypoint"

if [[ ${RUN_TEST} = "true" ]]; then
    echo "-------------------------------------------------------"
    echo "npm test"
    npm test -- --watch=false --browsers=ChromeHeadlessNoSandbox --code-coverage || true;
    echo "-------------------------------------------------------"

    echo "-------------------------------------------------------"
    echo "npm run e2e"
    npm run e2e || true;
    echo "-------------------------------------------------------"

    if [[ ${RUN_SONARQUBE} = "true" ]]; then
        echo "-------------------------------------------------------"
        echo "Sonar properties"
        echo "SONARQUBE_PROJECT $SONARQUBE_PROJECT"
        echo "SONARQUBE_PROJECT_VERSION $SONARQUBE_PROJECT_VERSION"
        echo "SONARQUBE_URL $SONARQUBE_URL"
        echo "SONARQUBE_LOGIN $SONARQUBE_LOGIN"
        echo "SONARQUBE_PASSWORD $SONARQUBE_PASSWORD"
        echo "-------------------------------------------------------"

        sonar-scanner -Dsonar.projectKey="$SONARQUBE_PROJECT" -Dsonar.projectVersion="$SONARQUBE_PROJECT_VERSION" -Dsonar.projectName="$SONARQUBE_PROJECT" -Dsonar.host.url="$SONARQUBE_URL" -Dsonar.login=$SONARQUBE_LOGIN -Dsonar.password=$SONARQUBE_PASSWORD || true;
    fi
fi

[ $RUN_PROJECT = "true" ] && npm run start
