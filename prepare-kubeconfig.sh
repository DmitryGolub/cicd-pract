#!/bin/bash
# Кодируем сертификаты в base64
CA_CERT=$(cat ~/.minikube/ca.crt | base64 -w0)
CLIENT_CERT=$(cat ~/.minikube/profiles/minikube/client.crt | base64 -w0)
CLIENT_KEY=$(cat ~/.minikube/profiles/minikube/client.key | base64 -w0)

# Создаем kubeconfig с inline сертификатами
cat > kubeconfig.yaml << CONFIG
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $CA_CERT
    server: https://192.168.49.2:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    user: minikube
    namespace: default
  name: minikube
current-context: minikube
kind: Config
users:
- name: minikube
  user:
    client-certificate-data: $CLIENT_CERT
    client-key-data: $CLIENT_KEY
CONFIG

echo "✅ kubeconfig.yaml создан!"
