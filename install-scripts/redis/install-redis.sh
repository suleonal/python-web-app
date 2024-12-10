#!/bin/bash

helm upgrade --install redis bitnami/redis -f default-values.yaml
