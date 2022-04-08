# Istio sur le cluser k8s

> istioctl install --set profile=demo -y
>
> kubectl create ns nsemployee
>
> kubectl label namespace nsemployee istio-injection=enabled


# Start keycloak with doccker compose

> docker-compose up

# Config keycloak

## Client

### 1 - Login : admin/admin

![login](images/login.png)

### 2 - Create client

![create_client](images/client.png)

### 3 - Create client mapper

![client-mappers](images/client-mappers.png)

### 4 - Create client role

![client-mappers](images/client-roles.png)

## User

### 1 - Create user

![user_create](images/user-create.png)

### 2 - User password : test

![user_psd](images/user-password.png)

### 3 - User role mapper

![user_role_mappers](images/user-role-mappers.png)

### 3 - Login with user test

![login_test](images/login-test-user.png)

## add role istio role to admin user

![admin_role_istio](images/user-admin-roleIstio.png)

# Start app

> cd k8s

> kubectl create -f deployment.yaml

> kubectl create -f gateway.yaml

> kubectl create -f istio-auth.yaml

> kubectl port-forward -n istio-system svc/istio-ingressgateway 8082:80

> Note - you can access the swagger GUI at http://localhost:8082/app/swagger-ui.html

# Get access token pour user test pouvant effecuer un POST

> export TKN=$(curl -d 'username=test' -d 'password=test' -d 'grant_type=password' -d 'client_id=istio' http://localhost:8180/auth/realms/master/protocol/openid-connect/token | jq -r '.access_token')

# Get access token pour user admin ne pouvant pas effecuer un POST

> export TKN=$(curl -d 'username=admin' -d 'password=admin' -d 'grant_type=password' -d 'client_id=istio' http://localhost:8180/auth/realms/master/protocol/openid-connect/token | jq -r '.access_token')
