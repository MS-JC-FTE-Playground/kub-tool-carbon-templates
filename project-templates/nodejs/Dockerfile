# ---- Base Node ----
ARG BASE_IMAGE_ACR={{ .TemplateBuilder.BaseImagesACR }}
ARG ACR_REPO="gap/techops/cloudplatform/baseimage-alpine-nodejs"
ARG BASE_IMAGE_VERSION="0.0.8"
FROM ${BASE_IMAGE_ACR}.azurecr.io/${ACR_REPO}:${BASE_IMAGE_VERSION} as base

WORKDIR /app
COPY package.json /app

# ---- Dependencies ----
FROM base AS dependencies
ARG ARTIFACTORY_HOST_URL=${ARTIFACTORY_HOST_URL}
ARG ARTIFACTORY_USERNAME=${ARTIFACTORY_USERNAME}
ARG ARTIFACTORY_PASSWORD=${ARTIFACTORY_PASSWORD}
ARG ARTIFACTORY_NPM_TOKEN=${ARTIFACTORY_NPM_TOKEN}
ARG NPM_DEPLOY_REPO=${NPM_DEPLOY_REPO}

COPY . .

RUN npm config set registry "https://${ARTIFACTORY_HOST_URL}/gapinc/api/npm/${NPM_DEPLOY_REPO}" && \
    npm config set _auth ${ARTIFACTORY_NPM_TOKEN} && \
    npm set progress=false && npm config set depth 0

RUN npm ci --only=production
RUN cp -R node_modules prod_node_modules
RUN npm ci

# ---- Test ----
# run linters, setup and tests
FROM dependencies AS test

COPY . .
#RUN  npm run lint && npm run setup && npm run test


#FROM gcr.io/distroless/nodejs:10
#COPY --from=build-env /app /app

# ---- Release ----
FROM base AS release

ARG SERVICE_NAME="{{ .TemplateBuilder.ApplicationName }}"
ARG IMAGE_DATE="{{ .TemplateBuilder.Date }}"
ARG IMAGE_MAINTAINER="{{ .TemplateBuilder.Maintainer }}"
ARG APPLICATION_VERSION="{{ .TemplateBuilder.AppVersion }}"
ARG PORT=3000

ENV APPLICATION_VERSION ${APPLICATION_VERSION}

COPY --from=dependencies /app/prod_node_modules ./node_modules
COPY . .
EXPOSE $PORT

CMD ["npm", "start"]
