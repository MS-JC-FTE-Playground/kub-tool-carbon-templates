[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $tag="{{ .TemplateBuilder.ImageTag }}"
)


$appacr="{{ .TemplateBuilder.AppACR }}"
$baseacr="{{ .TemplateBuilder.BaseImagesACR }}"

$ErrorActionPreference = "Stop"

Write-Host "Running gradle..."
.\gradlew.bat

Write-Host "Logging into ACR $appacr..."
az acr login --name $appacr

Write-Host "Building docker image $appacr.azurecr.io/{{ .TemplateBuilder.ImageNamespace }}:$tag..."
docker build -f Dockerfile --build-arg BASE_IMAGE_ACR=$baseacr -t $appacr.azurecr.io/{{ .TemplateBuilder.ImageNamespace }}:$tag .

Write-Host "Pishing docker image $appacr.azurecr.io/{{ .TemplateBuilder.ImageNamespace }}:$tag..."
docker push $appacr.azurecr.io/{{ .TemplateBuilder.ImageNamespace }}:$tag

Write-Host "Done!"
