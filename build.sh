#!/bin/bash
# istioctl install --set profile=demo --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY
kubectl delete -f k8s/deployment.yaml
kubectl delete -f k8s/gateway-tls.yaml
kubectl delete -f k8s/destination-rule.yaml
if [[ $1 == -c ]]; then
    kubectl delete -f k8s/virtual-service-canary.yaml
else
    kubectl delete -f k8s/virtual-service-ab-testing.yaml
fi


kubectl delete -f k8s/istio-auth.yaml

docker rmi --force $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'springboot-k8s-example')

mvn clean install -DskipTests
docker build -t springboot-k8s-example:1.0 .

kubectl create -f k8s/deployment.yaml
kubectl create -f k8s/gateway-tls.yaml
kubectl create -f k8s/destination-rule.yaml

if [[ $1 == -c ]]; then
    echo "============ canary testing ============"
    kubectl create -f k8s/virtual-service-canary.yaml
else
    echo "============ A/B testing ============"
    kubectl create -f k8s/virtual-service-ab-testing.yaml
fi

kubectl create -f k8s/istio-auth.yaml

# https://localhost/app/swagger-ui.html

