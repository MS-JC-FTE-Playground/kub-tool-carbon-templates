#!/usr/bin/env sh

helm upgrade {{ .TemplateBuilder.Name }} helm/{{ .TemplateBuilder.Name }} --install --namespace nms-{{ .TemplateBuilder.ProductFamily }}-services