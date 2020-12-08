{{- if not .Values.persistentVolume.existingClaim }}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ include "enterprise-steam.fullname" . }}
  labels:
    {{- include "enterprise-steam.labels" . | nindent 4 }}
  annotations:
    pv.beta.kubernetes.io/gid: "955"
    {{- with .Values.persistentVolume.annotations }}
    {{ toYaml . | indent 4 }}
    {{- end }}
spec:
  accessModes:
    {{- .Values.persistentVolume.accessModes | toYaml | nindent 4 }}
{{- if .Values.persistentVolume.storageClassName }}
  storageClassName: {{ .Values.persistentVolume.storageClassName }}
{{- end }}
  resources:
    requests:
      storage: {{ .Values.persistentVolume.size }}
{{- end }}