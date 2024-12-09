#!/bin/bash

helm repo add jenkinsci https://charts.jenkins.io
helm install jenkins jenkinsci/jenkins -n jenkins --create-namespace
