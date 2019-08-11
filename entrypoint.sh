#!/bin/bash
npm test -- --watch=false --browsers=ChromeHeadless --code-coverage
#[ $SONARQUBE != "" ] && sonar-scanner -Dsonar.projectKey=${SONARQUBE_PROJECT} -Dsonar.projectName=${SONARQUBE_PROJECT} -Dsonar.host.url=${SONARQUBE}
