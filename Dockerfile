# ---- Base ----
ARG BASE_IMAGE_ACR="gacr2pbaseimages"
ARG BASE_ACR_REPO="gap/hub/caas/carbon"
ARG BASE_IMAGE_VERSION="latest" 

FROM ${BASE_IMAGE_ACR}.azurecr.io/${BASE_ACR_REPO}:${BASE_IMAGE_VERSION} as base

# ---- Dependencies ----
FROM gacr2pbaseimages.azurecr.io/alpine:3.15.0 AS dependencies
RUN apk --no-cache add zip

USER root

COPY ./helm-templates/ /helm-templates/
COPY ./project-templates/ /project-templates/

WORKDIR /helm-templates
RUN chmod +x ./compress-templates.sh && ./compress-templates.sh

WORKDIR /project-templates
RUN chmod +x ./compress-templates.sh && ./compress-templates.sh

# ---- Release ----
FROM base AS release

ARG APP_VERSION=${APP_VERSION}

LABEL maintainer="HQ-IT-PIPES-DG@gap.com"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.version=${APP_VERSION}

USER root

RUN mkdir -p /home/carbon/.carbon/templates/helm/
RUN mkdir -p /home/carbon/.carbon/templates/project/

COPY --from=dependencies /helm-templates/templates/* /home/carbon/.carbon/templates/helm/
COPY --from=dependencies /project-templates/templates/* /home/carbon/.carbon/templates/project/

RUN mkdir /home/carbon/output && chown -R carbon:carbon /home/carbon

USER carbon

HEALTHCHECK NONE

WORKDIR /home/carbon/output

CMD ["carbon"]
