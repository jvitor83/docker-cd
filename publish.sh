#!/bin/bash
# echo 'kompose'
[[ -f ${COMPOSE_FILENAME} ]] && ./kompose convert -f docker-compose.yml -f ${COMPOSE_FILENAME}
# echo 'rm'
rm -rf *.yml
rm -rf .*.json *.json
# echo 'kubectl'
# cat /bitnami/kubeconfig
# kubectl --kubeconfig /bitnami/kubeconfig apply -f ./*.yaml

# fname="$(ls . | grep **-namespace.yaml)"
# kubectl --kubeconfig /bitnami/kubeconfig apply -f $fname

for file in *-namespace.yaml;
do
  kubectl --kubeconfig /bitnami/kubeconfig apply -f $file
done;

kubectl --kubeconfig /bitnami/kubeconfig apply -f ./


# for file in *.yaml;
# do
#   kubectl --kubeconfig /bitnami/kubeconfig apply -f $file
# done;

