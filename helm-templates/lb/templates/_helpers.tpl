{{/*
Expand the name of the chart.
*/}}
{{- define "{{ .TemplateBuilder.Name }}.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "{{ .TemplateBuilder.Name }}.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "{{ .TemplateBuilder.Name }}.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "{{ .TemplateBuilder.Name }}.labels" -}}
helm.sh/chart: {{ include "{{ .TemplateBuilder.Name }}.chart" . }}
{{ include "{{ .TemplateBuilder.Name }}.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "{{ .TemplateBuilder.Name }}.selectorLabels" -}}
app.kubernetes.io/name: {{ include "{{ .TemplateBuilder.Name }}.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ .TemplateBuilder.Name }}
{{- end }}

{{/*
Create the names of the service accounts to use
*/}}
{{- define "{{ .TemplateBuilder.Name }}.console.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "{{ .TemplateBuilder.Name }}.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
{{- define "{{ .TemplateBuilder.Name }}.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "{{ .TemplateBuilder.Name }}.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
