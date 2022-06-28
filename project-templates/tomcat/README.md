# PAS Provider Attribute Provider

# Table of Contents

- [`Docker Image`](#Docker-images)
- [`Helm Chart`](#helm-chart)

## Description
Repository for the AKS artifacts (Docker files, Helm, yamls, etc.) for the Provider Attribute Provider implementation. All artifacts needed to deploy the components into an AKS cluster. The helm chart deploys a application as a container in AKS Pods.


## Docker image
The Docker file is fairly straight forward. The image will be built using semantic versioning.


### Build the image

The application image is built from Tomcat85 base image. The Tomcat85 base image is built from OpenJDK8 image.

To build the image ensure you have the pre-requisites installed on you machine as described in the [Pre-Requisites](##pre-requisites)

The tag should be of the format:
[nonprod repo name].azurecr.io/[company]]/[team]/[product family]/[product]:[version]

#### Tagging
The tag for an image needs to be specific and provide clarity as to what is being deployed. In this case we will create a tag which contains the semantic version v1.0.0. Additional tags can be added. for example build#, commit Id, or even latest for dev teams. In production, a specific tag should always be referenced from a helm chart as opposed to latest.

From the same directory where the docker file resides

```sh
docker build -f Dockerfile -t nonprodrepo.azurecr.io/gap/customer-communication/pas/personal-attribute-provider:v1.0.0 .
```

### Login to ACR

To login to the ACR:

```sh
az acr login --name [repository name] 
```

_Note: the repository name should not contain the azurecr.io suffix._


### Push to ACR
After logging into the ACR, pushing the image to the repository is the same command used to push to a docker repository:

```sh
docker push nonprodrepo.azurecr.io/gap/customer-communication/pas/personal-attribute-provider:v1.0.0
```

## Docker Images Best Practices
For Best Practices on how to create your Docker image, please refer to [this page](https://github.gapinc.com/Gap-AKS-Pilot/platform-base-images/blob/master/BEST_PRACTICES.md).


## Helm Charts
There are two helm charts as part of this repo:
Helm Chart is found in the helm chart folder found in the application folder.


### Helm Attributes
Helm Attributes can be found in the values file in the helm folder.


#### Chart Version
The chart version is in the Chart.yaml in the Helm folder

### App version
From the documentation "This is the version number of the application being deployed. This version number should be incremented each time you make changes to the application. Versions are not expected to  follow Semantic Versioning. They should reflect the version the application is using."


#### Folder Structure
The folder structure follows the typical helm v3 folder structure with a chart.yaml and values.yaml files in the root. A templates folder which contains all the templates as well as the _helpers.tpl and Notes.TXT. 

The templates folder is made up of sub folders denoting each type of kuberentes component being deployed. i.e. deployments, services, etc. Within each sub folder resides the respective component being configured using the naming convention of the main component it refers to.

For example this chart deploys the Personal Attribute Provider for PAS. 

#### Values
The Values file follows the helm syntax and contains all the relevant information which is passed into the templates during the deployment of the chart. For ARM Template folks this is the parameters.json file.

This values file is structured with the global parameters at the top and then a section for each component labeled 'console' and 'engine'. Each of the component sections contains the values corresponding to that component.

## Gradle Tasks

#### Starting the app
``` bash
$ ./gradlew bootRun
```
#### Running Sonar local
```
$ ./gradlew clean sonar
```
> This task run the unit test and generate a report in `build/sonar/issues-report/issues-report.html`


## Pre-requisites
At a minmum in order to build and deploy the images and helm charts the following tools must be installed locally:

* docker 
* helm v3
* [notary](https://github.com/theupdateframework/notary/releases/tag/v0.6.1)



## References
* [Docker Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
* [AKS Checklist](https://www.the-aks-checklist.com/)
* [Helm & ACR](https://docs.microsoft.com/en-us/cli/azure/acr/helm?view=azure-cli-latest)
* [Best Practices](https://snyk.io/blog/10-docker-image-security-best-practices/?ref=akschecklist)

touch
