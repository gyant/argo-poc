# core directory

This directory is intended to house any services an argocd implementation depends on. This includes namespace creation to avoid situations where deleting a kustomize environment deletes a namespace with unrelated resources running.

Add each new service as a new base entry in `k8s/core/kustomization.yaml`