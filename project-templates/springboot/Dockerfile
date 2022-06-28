ARG BASE_IMAGE_ACR={{ .TemplateBuilder.BaseImagesACR }}
ARG ACR_REPO="gap/techops/cloudplatform/baseimage-alpine-openjdk11"
ARG BASE_IMAGE_VERSION="0.0.3"
FROM ${BASE_IMAGE_ACR}.azurecr.io/${ACR_REPO}:${BASE_IMAGE_VERSION}

ARG SERVICE_NAME="{{ .TemplateBuilder.ApplicationName }}"
ARG DEPENDENCY=build/libs
ARG PORT=8080
ARG APPLICATION_VERSION="{{ .TemplateBuilder.AppVersion }}"
ARG IMAGE_DATE="{{ .TemplateBuilder.Date }}"
ARG IMAGE_MAINTAINER="{{ .TemplateBuilder.Maintainer }}"

ENV APPLICATION_VERSION ${APPLICATION_VERSION}

WORKDIR /app

USER www-data

COPY --chown=www-data:www-data ${DEPENDENCY}/${SERVICE_NAME}-${APPLICATION_VERSION}.jar .
ENV SERVICE_PATH=/app/${SERVICE_NAME}-${APPLICATION_VERSION}.jar

LABEL maintainer=${IMAGE_MAINTAINER}
LABEL com.gap.${SERVICE_NAME}.version=${APPLICATION_VERSION}
LABEL com.gap.${SERVICE_NAME}.product=${SERVICE_NAME}
LABEL com.gap.${SERVICE_NAME}.release-date=${IMAGE_DATE}

EXPOSE ${PORT}
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar ${SERVICE_PATH}"]
