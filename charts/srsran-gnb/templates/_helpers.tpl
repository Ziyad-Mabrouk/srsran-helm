{{/*
Generate a full name for the release
*/}}
{{- define "srsran-gnb.fullname" -}}
srsran-gnb
{{- end }}

{{/*
Standard labels
*/}}
{{- define "srsran-gnb.labels" -}}
app.kubernetes.io/name: {{ include "srsran-gnb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: Helm
{{- end }}

{{/*
Selector labels
*/}}
{{- define "srsran-gnb.selectorLabels" -}}
app: srsran
component: gnb
{{- end }}
