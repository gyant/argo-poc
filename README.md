# argo-poc


## Initial Setup

1. Authenticate with AWS by setting the `AWS_PROFILE` env variable to the correct profile credentials in `~/.aws/credentials`.

    ```
    export AWS_PROFILE=sandbox
    ```

1. Run terraform:

    ```
    cd terraform/environments/poc
    terraform apply -var-file=poc.tfvars
    ```

1. Authenticate with EKS cluster:

    After the terraform runs there will be a file in the repo terraform directory containing the kubeconfig file.

    ```
    export KUBECONFIG=$(pwd)/kubeconfig_argocd-poc-cluster
    ```

1. Install core dependencies:

    ```
    cd .. # Back to the project root
    kubectl apply -k ./k8s/core
    ```

## Argo Setup

This covers the general process for prepping a new Argo environment.

1. 

### GitHub Secrets

The file `repo-secrets.yml` is an encrypted file from the demo environment. To reset this, we have to re-encrypt new secrets with the GitHub Personal Access Token specified at the beginning of this document.

Template:

```
apiVersion: v1
kind: Secret
metadata:
  name: github-secrets
type: Opaque
data:
  username: <arbitrary base64 encoded username>
  password: <base64 encoded token here>

```

The username can literally be anything if we use a token but it has to be something. Cannot leave it empty. The user `hi` was used for the demo.

Once this template is filled out, run the following:

```
cd k8s/services/argocd
kubectl create namespace argocd
kubeseal -n argocd --format=yaml < ./unencrypted-template.yml > repo-secrets.yml
```

### Applications

In `k8s/services/argocd/applications.yml` the information for all the application deployments that show up on the main page of the UI are defined. References to the git repositories will need to be updated as well as URLs for the k8s clusters.

A value of `https://kubernetes.default.svc` refers to the cluster Argo is installed on.

Otherwise, the actual connection URL of any secondary clusters added to Argo must be referenced as in the second example.

### Adding Clusters

[Declarative Clusters](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#clusters)

Clusters are another encrypted file in this resource `k8s/services/argocd/clusters/*.yml`.

Cluster resources cannot be combined into a file. Each file must have a single cluster definition.

Here is a template for adding a secondary EKS cluster:

```
---
apiVersion: v1
kind: Secret
metadata:
  name: <cluster name here>
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name: <cluster name here>
  server: <kubeconfig server url here>
  config: |
    {
      "tlsClientConfig": {
        "insecure": false,
        "caData": "<kubeconfig ca data here>"
      },
      "awsAuthConfig": {
        "clusterName": "<cluster name here>",
        "roleARN": "arn:aws:iam::<ACCOUNT ID>:role/<argo-role-name>"
      }
    }
```


## Port-Forward

This does not by default expose anything to the outside world. Execute the following to see the UI:

```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Navigate to `https://localhost:8080`

This will be using a self-signed certificate so simply accept the certificate in the browser and you'll see the Argo login page.
