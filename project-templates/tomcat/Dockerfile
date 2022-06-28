ARG BASE_IMAGE_ACR={{ .TemplateBuilder.BaseImagesACR }}
ARG ACR_REPO="java/tomcat"
ARG BASE_IMAGE_VERSION="85-buster"

FROM ${BASE_IMAGE_ACR}.azurecr.io/${ACR_REPO}:${BASE_IMAGE_VERSION}

ARG SERVICE_NAME="{{ .TemplateBuilder.ApplicationName }}"
ARG PAPWARFILE_PATH="build/libs/{{ .TemplateBuilder.ApplicationName }}"
ARG SERVERLIBS_PATH="docker/tomcat/tomcat/libs"
ARG SHAREDLOADER_PATH="docker/tomcat/shared/lcfgResult"
ARG SHAREDPROPERTIES_PATH="docker/tomcat/conf"
ARG PORT=8080
ARG IMAGE_DATE="{{ .TemplateBuilder.Date }}"
ARG IMAGE_MAINTAINER="{{ .TemplateBuilder.Maintainer }}"
ARG APPLICATION_VERSION="{{ .TemplateBuilder.AppVersion }}"

ENV APPLICATION_VERSION ${APPLICATION_VERSION}

RUN chown -R www-data /usr/local/tomcat
RUN mkdir /usr/local/tomcat/shared

COPY --chown=www-data:www-data ${SHAREDPROPERTIES_PATH}/catalina.properties /usr/local/tomcat/conf
COPY --chown=www-data:www-data ${SHAREDLOADER_PATH}/. /usr/local/tomcat/shared
COPY --chown=www-data:www-data ${SERVERLIBS_PATH}/. /usr/local/tomcat/lib
COPY --chown=www-data:www-data ${PAPWARFILE_PATH}.war /usr/local/tomcat/webapps/

USER www-data

WORKDIR /usr/local/tomcat/webapps/

LABEL maintainer=${IMAGE_MAINTAINER}
LABEL com.gap.${SERVICE_NAME}.version=${APPLICATION_VERSION}
LABEL com.gap.${SERVICE_NAME}.product=${SERVICE_NAME}
LABEL com.gap.${SERVICE_NAME}.release-date==${IMAGE_DATE}

EXPOSE ${PORT} 
