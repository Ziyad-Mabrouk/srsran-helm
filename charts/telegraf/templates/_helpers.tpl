{{/*
Generate a full release name
*/}}
{{- define "telegraf.fullname" -}}
telegraf
{{- end }}

{{/*
Standard labels
*/}}
{{- define "telegraf.labels" -}}
app.kubernetes.io/name: {{ include "telegraf.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: Helm
{{- end }}

{{/*
Selector labels
*/}}
{{- define "telegraf.selectorLabels" -}}
app: telegraf
nf: {{ .Values.labels.nf }}
{{- end }}
