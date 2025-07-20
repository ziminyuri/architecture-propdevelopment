#!/bin/bash

# Создание пользователя client-view-only
echo "Creating 'client-view-only' certificate..."
openssl genrsa -out client-view-only.key 2048
openssl req -new -key cclient-view-only.key -out client-view-only.csr -subj "/CN=client-view-only/O=view-only"
openssl x509 -req -in client-view-only.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out client-view-only.crt -days 365

# Добавляем пользователя в kubeconfig
echo "Adding client-view-only to kubeconfig..."
kubectl config set-credentials client-view-only --client-certificate=$(pwd)/client-view-only.crt --client-key=$(pwd)/client-view-only.key
kubectl config set-context client-view-only-context --cluster=minikube --namespace=client --user=client-view-only

# Создание пользователя secret-reader-user
echo "Creating 'secret-reader-user' certificate..."
openssl genrsa -out secret-reader-user.key 2048
openssl req -new -key secret-reader-user.key -out secret-reader-user.csr -subj "/CN=secret-reader-user/O=secret-reader"
openssl x509 -req -in secret-reader-user.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out secret-reader-user.crt -days 365

# Добавляем пользователя в kubeconfig
echo "Adding secret-reader-user to kubeconfig..."
kubectl config set-credentials secret-reader-user --client-certificate=$(pwd)/secret-reader-user.crt --client-key=$(pwd)/secret-reader-user.key
kubectl config set-context secret-reader-context --cluster=minikube --namespace=production --user=secret-reader-user

# Выводим список пользователей в kubeconfig
echo "Users created:"
kubectl config get-contexts