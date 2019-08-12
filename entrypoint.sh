#!/bin/bash
# npm test -- --watch=false --browsers=ChromeHeadless --code-coverage
npm run e2e
#[ $SONARQUBE != "" ] && sonar-scanner -Dsonar.projectKey=${SONARQUBE_PROJECT} -Dsonar.projectName=${SONARQUBE_PROJECT} -Dsonar.host.url=${SONARQUBE}
