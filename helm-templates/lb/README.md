# Platform OIDC Helm Chart
this helm chart deploys several components to kubernetes:

* Administrative console as a single pod.
* N+1 engines based on the replica set in the deployment
* A Deployment for each of the above components
* A Config map for each of the above components
* A Service Account for each of the above components
* Three services. One for each components as well as a cluster service which acts as a headless service. This is used during the clustering communication of the engine podss.
* A single HPA for the engines for horizontal scaling if enabled.

## Chart Version
The chart version.

## App version
From the documentation "This is the version number of the application being deployed. This version number should be incremented each time you make changes to the application. Versions are not expected to  follow Semantic Versioning. They should reflect the version the application is using."

For the purposes of the chart in this repository it refers to the image tag being referenced from the base image. The reason for this is to ensure clarity and consistency.

## Folder Structure
The folder structure follows the typical helm v3 folder structure with a chart.yaml and values.yaml files in the root. A templates folder which contains all the templates as well as the _helpers.tpl and Notes.TXT. 

The templates folder is made up of sub folders denoting each type of kuberentes component being deployed. i.e. deployments, services, etc. Within each sub folder resides the respective component being configured using the naming convention of the main component it refers to.

For example this chart deploys two PingID components. An administrator 'console' and an 'engine'. So in each subfolder you will find a console.yaml and an yaml which corresponds to the component the kuberenetes object is being deployed for.

## Values
The Values file follows the helm syntax and contains all the relevant information which is passed into the templates during the deployment of the chart. For ARM Template folks this is the parameters.json file.

This values file is structured with the global parameters at the top and then a section for each component labeled 'console' and 'engine'. Each of the component sections contains the values corresponding to that component.

## Installing to AKS
To install the chart you use the hlem cli. specifically the 'helm install' command. There are several variations of this command which can be found in the documentation [here](https://helm.sh/docs/helm/helm_install/)

The following command installs the chart specifying a name of '{{ .TemplateBuilder.Name }}', the location of the chart, the location of the values file, and the namespace to install to.


```sh
 helm install {{ .TemplateBuilder.Name }} helm/{{ .TemplateBuilder.Name }} --values helm/{{ .TemplateBuilder.Name }}/values.yaml --namespace=pingfed
```

If a name is specified it will be used as a prefix to all resources being deployed with exeption to the services and deployments as seen below.

![alt text](../../artifacts/helm-deployed-artifacts.PNG "Deployed Components")

## Upgrading
To upgrade the chart use the 'helm upgrade' command with the same parameters specified with the 'helm install' command.

```sh
 helm upgrade {{ .TemplateBuilder.Name }} helm/{{ .TemplateBuilder.Name }} --values helm/{{ .TemplateBuilder.Name }}/values.yaml --namespace=pingfed
```

## Uninstalling
To uninstall the chart use the 'helm uninstall' command with the name of the release that was specified during the install.

```sh
 helm upgrade {{ .TemplateBuilder.Name }} helm/{{ .TemplateBuilder.Name }} --values helm/{{ .TemplateBuilder.Name }}/values.yaml --namespace=pingfed
```

To list the installed helm charts in the cluster use the 'helm list' command.

![alt text](../../artifacts/helm-list.PNG "Helm List")

## Helm & ACR

Add ACR helm chart repository

```sh
az acr helm repo add --name [repo name]]
```

List the charts in the ACR repo

```sh
az acr helm list -n [repo name]]
```

To push a chart into the ACR repo

```sh
az acr helm push -n [repo name] [image:tag]
```


# Pre-requisites
At a minmum in order to build and deploy the images and helm charts the following tools must be installed locally:

* docker 
* helm v3
* [notary](https://github.com/theupdateframework/notary/releases/tag/v0.6.1)

