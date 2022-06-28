# helm-templates
Repo for helm chart templates. These templates are used by the 'carbon' app and 'carbon' helm plugin. More on those tools can be found [here](https://github.gapinc.com/Gap-AKS-Pilot/carbon).

## Folder structure 

The source files for each of the templates are stored in the folder for the template via a unique folder name. This name is also used by the helm plugin to display the templates to the user. This folder must be unique and follow normal folder naming conventions. The shorter the better. 


## Template Construction Details

The files in each of the template folders is basically a helm chart with specific data points set to a token for replacement by the carbon app.

For example, in the agic chart.yaml we have:

```yaml
apiVersion: v2
name: {{ .TemplateBuilder.Name }}
description: {{ .TemplateBuilder.Description }}

# A chart can be either an 'application' or a 'library' chart.
#
# Application charts are a collection of templates that can be packaged into versioned archives
# to be deployed.
#
# Library charts provide useful utilities or functions for the chart developer. They're included as
# a dependency of application charts to inject those utilities and functions into the rendering
# pipeline. Library charts do not define any templates and therefore cannot be deployed.
type: application

# This is the chart version. This version number should be incremented each time you make changes
# to the chart and its templates, including the app version.
# Versions are expected to follow Semantic Versioning (https://semver.org/)
version: {{ .TemplateBuilder.ChartVersion }}

# This is the version number of the application being deployed. This version number should be
# incremented each time you make changes to the application. Versions are not expected to
# follow Semantic Versioning. They should reflect the version the application is using.
appVersion: {{ .TemplateBuilder.AppVersion }}
```

All the tokens of the form {{ .TemplateBuilder. }} will be replaced by the carbon app during creation time. 


## Templates Archives

The templates themselves are simply archived files of the template folders which are placed in the 'templates' subfolder. This folder is consumed by the helm plugin.

## Helm Templates Described

Currently there are four templates:

* istio
* agic
* lb
* sample

currently each of the templates represents a specific ingress pattern which was proofed out during the CaaS AKS Pilot. Each template is comprised of a helm chart with all the dependent yaml files to deploy the required kubernetes objects into the cluster: Pod, Deployment, Service, Ingress, and HPA. In addition there are several other third part objects which are installed. 

>***Important** Each of these templates work in conjunction with a service provider infrastructure component and must be configured ahead of time before deploying any of these templates. In addition there are several supporting components called "Shared Services" which also must be deployed and configured ahead of time. Please refer to the shared services repo [here](https://github.gapinc.com/Gap-AKS-Pilot/shared-services).

The complete listing is here:
### Supported Components
#### Kubernetes Objects

Kubernetes:
* Pod
* Service
* Ingress
* Deployment
* ReplicaSet
* HPA

Istio:
* ServiceEntry
* Gateway
* VirtualService

Argo:
* Rollout

Keda:
* ScaledObject

#### External DNS

In addition there is support in the helm charts for integration with 'external-dns' and 'keda'.

This section in the values.yaml configures external dns:

```yaml
externalDNS:
  enabled: false
  dnsLabel:  your.application.dns.com
```

#### Autoscaling 

The charts also follow a scaling pattern which allows switching or assigning a specific HPA pattern easily from the values.yaml.

```yaml
autoscaling:
  pattern: none
  patterns: 
    baseline:
      hpa: 
        enabled: true
        minReplicas: 1
        maxReplicas: 1
        targetCPUUtilizationPercentage: 65
        #targetMemoryUtilizationPercentage: 65
      keda:
        enabled: false
        pollingInterval: 15
        cooldownPeriod:  10
        minReplicaCount: 1
        maxReplicaCount: 1    
        triggers:
        - type: cpu
          metadata:
            type: Utilization
            value: "65"
    nonprod:
      hpa: 
        enabled: true
        minReplicas: 1
        maxReplicas: 3
        targetCPUUtilizationPercentage: 65
        #targetMemoryUtilizationPercentage: 65
      keda:
        enabled: false
        pollingInterval: 15
        cooldownPeriod:  10
        minReplicaCount: 1
        maxReplicaCount: 3    
        triggers:
        - type: cpu
          metadata:
            type: Utilization
            value: "65"            
    production:
      hpa: 
        enabled: true      
        minReplicas: 3
        maxReplicas: 8
        targetCPUUtilizationPercentage: 65
        #targetMemoryUtilizationPercentage: 65
      keda:
        enabled: false
        pollingInterval: 15
        cooldownPeriod:  10
        minReplicaCount: 3
        maxReplicaCount: 8    
        triggers:
        - type: cpu
          metadata:
            type: Utilization
            value: "65"
```

To deploy the helm chart for a baseline test specifying the hpa pattern like so will deploy a single pod for base line testing:


```sh
helm upgrade my-chart helm/my-chart --install --namespace nms-application-namespace --set autoscaling.pattern=baseline
```

To deploy the helm chart without HPA simply set the autoscaling.pattern=none and the replicaCount in the values.yaml will be used.


```sh
helm upgrade my-chart helm/my-chart --install --namespace nms-application-namespace --set autoscaling.pattern=none
```

For production

```sh
helm upgrade my-chart helm/my-chart --install --namespace nms-application-namespace --set autoscaling.pattern=production
```

#### CSI Secrets Provider

The templates also have support for the CSI Secrets Provider component. The following section in the values.yaml drives this and is consumed by the deployment and rollout yaml files:

```yaml
 csiSecretsProvider:
  enabled: true
  secretProviderClass: ""  # Optional. Defaults to "aib-{{.Release.Namespace }}"
  envFrom:
  - name: ENCRYPT_KEY
    valueFrom:
      secretKeyRef:
        name: {{ .TemplateBuilder.Name }}-encrypt-key
        key: key

```

Additional keys can be added which correspond to secrets in an AKV. Keep in mind there are some shared components which must be provisioned ahead of time which work in conjunction with the CSISP driver and AAD Pod Identity. These are covered in the shared services repo located [here](https://github.gapinc.com/Gap-AKS-Pilot/shared-services).

#### Azure AD Pod Identity

Azure AD Pod Identity is supported and configured via the following section in the values.yaml file.

```yaml
aadPodIdentity:
  enabled: true
  identity: ""    # defaults to "aib-{{ .Release.Namespace }}"
```

### Templates

#### To create a template (plugin)

Specifying the 'chart-from-chart' command via the plugin will allow for creating the template from an existing chart. Take note that the chart most likely will need some manual adjustments depnding on the nature of the chart. If this was a chart created via carbon, then the adjustments will be minimal since it follows the same naming standards and yaml placements.

```sh
➜ helm carbon from-chart --help
carbon 1.0.5
Copyright (C) 2021 Gap Inc

  -l, --location      Required. Location of chart.

  -o, --outputpath    Required. Location of new helm template. Path and files will be overwriten

  -v, --verbose       Set output to verbose messages.

  --help              Display this help screen.

  --version           Display version information.

```

```sh
➜ helm carbon from-chart -l c:\my-chart-files -o c:\my-new-template
```

Review the files in an editor and make sure all the tokens are properly placed.

Once complete you can update the [repo](https://github.gapinc.com/Gap-AKS-Pilot/helm-templates) with the source files and the archived template.

#### To create a new template (Manual)

To create a new helm template perform the following:

* clone this repo
* Make a copy of a helm chart into another folder.
* Perform token replacements on the service name, chart name, chart description using the following tokens in all the files including the _tpl and NOTES.TXT files:

    * chart.yaml name: "{{ .TemplateBuilder.Name }}"
    * chart.yaml  appversion: "{{ .TemplateBuilder.AppVersion }}"
    * chart.yaml version: "{{ .TemplateBuilder.ChartVersion }}"
    * chart.yaml description: "{{ .TemplateBuilder.Description }}"
    * values.yaml condensed: "{{ .TemplateBuilder.Condensed }}"
    * values.yaml externalDNS.dnsLabel: "{{ .TemplateBuilder.DnsLabel }}"
    * values.yaml image.namespace: "{{ .TemplateBuilder.ImageNamespace }}"
    * values.yaml image.tag "{{ .TemplateBuilder.ImageTag }}"

    In all files including tpl and NOTES.TXT replace all occurrences of the service name like so

    * include "spex-background-service.fullname" . replace with "{{ .TemplateBuilder.Name }}". 

    This includes and hardcoded values in the values.yaml which refer to service name or path that correlates back to the service name.

* Create a folder in the helm-templates repo which represents the template name and copy the files there
* Zip the folder and place it in the 'templates' folder.
* Commit changes
* Follow the intructions in the helm plugin repo to update the list of templates using the helm plugin command.

#### Istio Template

The istio template deploys the additional istio objects to the cluster to support the istio ingress pattern. Namely 'Gateway' and 'VirtualService' objects. 

Ths following section in the values.yml file drives the creation of those objects:

```yaml
istio:
  enabled: true
  gateway: igwy-{{ .TemplateBuilder.Name }}
  virtualService:
    host: {{ .TemplateBuilder.Name }}.{{ .TemplateBuilder.DnsLabel }}
    prefix: /{{ .TemplateBuilder.Name }}
    rewrite: /
    route:
      destination:
        port:
          number: 443
  mongodb_serviceentry:
    enabled: false
    location: MESH_INTERNAL         # DNS, MESH_EXTERNAL, MESH_INTERNAL
    resolution: DNS
    create: true
    port: 27017
    protocol: tcp
    hosts: 
    - g-vmx-2d-spcdb-mongo-001.{{ .TemplateBuilder.DnsLabel }}
    addresses:
    - 10.110.189.52
```

In addation to the gatewway and virtualservice objects, serviceentry objects can be deployed as well. This monngodb_serviceentry section is an example of this. 

#### Agic Template (Application Gateway Ingress Controller)

The agic template has support for deploying a helm chart which uses the agic pattern to configure an application gateway as an ingress to the cluster. The following section is provided to support this pattern:


```yaml
agic:
  ssl:
    redirect: false
    certificate:  
    rootCertificate:
    connection:
      timeout: 
  cookieBasedAfffinity: false
  requestTimeout: 
  privateIp: true
  wafPolicyPath:
  servicePort: 80 
  tls:
    enabled: true
    host: 
    secretName: secr-{{ .TemplateBuilder.Name }}-appgw
  frontend:
    port:
  backend:
    port: 
    path: /{{ .TemplateBuilder.Name }}/*
    pathPrefix: 
    hostName:
    protocol:
  healthProbe:
    hostName:
    port:
    path:
    statusCodes:
    interval: 
    timeout: 
    unhealthyThreshold:
```

In most cases only the values being updated by the plugin, denoted here as '{{ .TemplateBuilder.Name }}' will need to be updated, but the ingress yaml does consume this section so all of the supported agic annotations for the ingress are provided.

#### LB Template (Load Balancer)

The lb template is the simplest template compared to the others since it utilizes a simple service object with the type set to 'LoadBalancer'. It also works in conjunction with external-dns to tie the dns entry to the LB's ip address. 

The following two sections are used for configuring this:

```yaml
externalDNS:
  enabled: false
  dnsLabel:  {{ .TemplateBuilder.Name }}.{{ .TemplateBuilder.DnsLabel }} 

loadBalancer:
  internal: true
```

In addition this pattern allows for the provisioning of a persistent volume and persistent volume claim which is mounted to the pod. Azure Files and Azure Disk are both supported and can be configured using the following section in the values.yaml file:


```yaml
persistentStorage:
  enabled: false
  storageClass: managed-premium  # default, managed-premium, azurefile, azurefile-premium
  name: {{ .TemplateBuilder.Name }}
  reclaimPolicy: Retain
  accessMode: ReadWriteOnce # Only ReadWriteOnce and ReadWriteMany is supported
  mountOptions: # Only used for ReadWriteMany access mode
    - dir_mode=0777
    - file_mode=0777
    - uid=0
    - gid=0
    - mfsymlinks
    - cache=strict
    - actimeo=30
  skuName: Standard_LRS # Only used for ReadWriteMany access mode 
                        #Standard_LRS - standard locally redundant storage (LRS)
                        #Standard_GRS - standard geo-redundant storage (GRS)
                        #Standard_ZRS - standard zone redundant storage (ZRS)
                        #Standard_RAGRS - standard read-access geo-redundant storage (RA-GRS)
                        #Premium_LRS - premium locally redundant storage (LRS) - minimum value for storage must be 100Gi.
                        #Premium_ZRS - premium zone redundant storage (ZRS)
  storage: 5Gi

```

and the corresponding two sections in the deployment file:


```yaml
        {{ if .Values.persistentStorage.enabled }}
        volumeMounts:
        - name: {{ .TemplateBuilder.Name }}-options-data
          mountPath: "/opt/out"
        {{ end }}
```

```yaml
      {{ if .Values.persistentStorage.enabled }}
      volumes:
      - name: {{ .TemplateBuilder.Name }}-options-data
        persistentVolumeClaim:
          claimName: "pvc-{{ .Values.persistentStorage.name }}"
      {{ end }}
```

#### Sample Template

The sample application is provided as learning tool and contains all of the ingress patterns and component support described in the other templates.

It has the addition of a pattern mechanism to allow for easily switching between the ingress patterns via the 'ingress.pattern' value:

```yaml
ingress:
  pattern: loadbalancer    # one of: loadbalancer, agic, ingress, none, istio
```

By setting the value a value, that corresponding section will be consumed in the charts templates. For example setting ingress.pattern=istio in the values.yaml file or by setting it on the command line via the --set like so --set ingress.pattern=istio will cause the istio ingress pattern objects to be provisioned.

Which means the following section is used:

```yaml
istio:
  pattern: singlegateway          # serviceentry, sharedgateway, singlegateway
  tls:
    enabled: false
    mode: SIMPLE
    portName: https
    portProtocol: HTTPS
    port: 443
  gateway:
    portName: http
    portProtocol: http
    port: 8080
  virtualService:
    port: 8080
    portProtocol: http 
  serviceEntry:
    location: MESH_INTERNAL         # DNS, MESH_EXTERNAL, MESH_INTERNAL
    ports:
    - number: 443
      name: https
      protocol: TLS      
    resolution: DNS
```
