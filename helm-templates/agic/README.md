# Personalization Attribute Provider

## Deployment

### Create the certificate secret

```sh
export cert_path=<path to cert.pem>
export cert_key=<path to cert.key>
```

```sh
kubectl create secret tls secr-personal-attribute-provider --key=$cert_key --cert=$cert_path
```

### Install the helm chart

LEt's do a dry run to see what will get installed

```sh
helm upgrade personal-attribute-provider helm/{{ .TemplateBuilder.Name }} --install --set ingress.pattern=agic --dry-run
```

After verifying the yaml is good

```sh
helm upgrade personal-attribute-provider helm/{{ .TemplateBuilder.Name }} --install --set ingress.pattern=agic
```