#!/usr/bin/env sh

#exec > /dev/null 2>&1
set -e

usage() {
  cat <<EOF
build and pushes image to acr repo
usage: ${0} [OPTIONS]

The following flags are optional.
	--appacr		app acr
	--baseacr		base image acr
	--tag   		image tag
EOF
  exit 1
}

appacr={{ .TemplateBuilder.AppACR }}
baseacr={{ .TemplateBuilder.BaseImagesACR }}
tag={{ .TemplateBuilder.ImageTag }}


while [ $# -gt 0 ]; do
  case ${1} in
      --appacr)
          appacr="$2"
          shift
          ;;
      --baseacr)
          baseacr="$2"
          shift
          ;;
      --tag)
          tage="$2"
          shift
          ;;
      --help)
		  usage
          ;;
        *)
          usage
          ;;
  esac
  shift
done

echo "Running gradle..."
./gradlew

echo "Logging into ACR $appacr..."
az acr login --name $appacr

echo "Building docker image $appacr.azurecr.io/{{ .TemplateBuilder.ImageNamespace }}:$tag..."
docker build -f Dockerfile --build-arg BASE_IMAGE_ACR=$baseacr -t $appacr.azurecr.io/{{ .TemplateBuilder.ImageNamespace }}:$tag .

echo "Pushing image $appacr.azurecr.io/{{ .TemplateBuilder.ImageNamespace }}:$tag"
docker push $appacr.azurecr.io/{{ .TemplateBuilder.ImageNamespace }}:$tag

echo "Done!"
