#!/bin/bash
npm test -- --watch=false --browsers=ChromeHeadless --code-coverage
npm run e2e -- --no-webdriver-update
[ $SONARQUBE_URL != "" ] && sonar-scanner -Dsonar.projectKey=${SONARQUBE_PROJECT} -Dsonar.projectName=${SONARQUBE_PROJECT} -Dsonar.host.url=${SONARQUBE_URL}
