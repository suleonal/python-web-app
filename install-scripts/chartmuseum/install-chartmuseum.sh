#!/bin/bash

helm repo add chartmuseum https://chartmuseum.github.io/charts
helm repo update
helm install helm-repo chartmuseum/chartmuseum -f values.yaml
