#!/bin/bash

helm upgrade --install postgres bitnami/postgresql -f default-values.yaml
helm install my-minio minio/minio --set mode=standalone -f minio-default-values.yaml -n databases
