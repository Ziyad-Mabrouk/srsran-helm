{{/*
Generate a full name for the release
*/}}
{{- define "srsran-ue.fullname" -}}
srsran-ue
{{- end }}

{{/*
Standard labels
*/}}
{{- define "srsran-ue.labels" -}}
app.kubernetes.io/name: {{ include "srsran-ue.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: Helm
{{- end }}

{{/*
Selector labels
*/}}
{{- define "srsran-ue.selectorLabels" -}}
app: srsran
component: ue
{{- end }}
