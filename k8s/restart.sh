
echo "delete deployment"
kubectl delete -f deployment.yaml
kubectl delete -f gateway.yaml
kubectl delete -f istio-auth.yaml

echo "start deploy"

kubectl create -f deployment.yaml
kubectl create -f gateway.yaml
kubectl create -f istio-auth.yaml

kubectl port-forward -n istio-system svc/istio-ingressgateway 8082:80
