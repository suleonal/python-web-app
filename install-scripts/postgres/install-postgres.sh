#!/bin/bash

helm upgrade --install postgres bitnami/postgresql -f default-values.yaml
