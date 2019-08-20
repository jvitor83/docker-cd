#!/bin/bash

echo "BRANCH: '${BRANCH}'"
echo "ENVIRONMENT: '${ENVIRONMENT}'"
[[ -f docker-compose${ENVIRONMENT}.yml ]] && echo "Publicando usando o arquivo 'docker-compose${ENVIRONMENT}.yml'" && ./kompose convert -f docker-compose${ENVIRONMENT}.yml
rm -rf *.yml .*.json *.json
# echo 'kubectl'
# cat /bitnami/kubeconfig
# kubectl --kubeconfig /bitnami/kubeconfig apply -f ./*.yaml

# fname="$(ls . | grep **-namespace.yaml)"
# kubectl --kubeconfig /bitnami/kubeconfig apply -f $fname

for file in *-namespace.yaml;
do
  cat $file
  kubectl --kubeconfig /bitnami/kubeconfig apply -f $file
done;

kubectl --kubeconfig /bitnami/kubeconfig apply -f ./


# for file in *.yaml;
# do
#   kubectl --kubeconfig /bitnami/kubeconfig apply -f $file
# done;

