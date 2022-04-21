# istioctl install --set profile=demo --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY
kubectl delete -f k8s/deployment.yaml
kubectl delete -f k8s/gateway-tls.yaml
kubectl delete -f k8s/istio-auth.yaml

docker rmi --force $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'springboot-k8s-example')

mvn clean install -DskipTests
docker build -t springboot-k8s-example:1.0 .

kubectl create -f k8s/deployment.yaml
kubectl create -f k8s/gateway-tls.yaml
kubectl create -f k8s/istio-auth.yaml


