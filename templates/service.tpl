apiVersion: v1
kind: Service
metadata:
  {{- if .Values.service.name}}
  name: {{ .Values.service.name }}
  {{- else }}
  name: {{ include "enterprise-steam.fullname" . }}
  {{- end }}
  labels:
    {{- include "enterprise-steam.labels" . | nindent 4 }}
  {{- with .Values.service.annotations }}
  annotations:
  {{ toYaml . | indent 4 }}
  {{- end }}
spec:
  type: {{ .Values.service.type }}
  {{- if .Values.service.loadBalancerIP}}
  loadBalancerIP: {{ .Values.service.loadBalancerIP }}
  {{- end }}
  ports:
    - port: {{ .Values.service.port }}
      name: steam
      protocol: TCP
  selector:
    {{- include "enterprise-steam.selectorLabels" . | nindent 4 }}