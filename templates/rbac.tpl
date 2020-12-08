{{- if .Values.serviceAccount.create -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "enterprise-steam.serviceAccountName" . }}
  labels:
    {{- include "enterprise-steam.labels" . | nindent 4 }}
  {{- with .Values.serviceAccount.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: {{ include "enterprise-steam.fullname" . }}
  labels:
    {{- include "enterprise-steam.labels" . | nindent 4 }}
rules:
  - apiGroups: ["", "apps", "storage.k8s.io"]
    resources: ["namespaces", "pods", "pods/log", "deployments", "secrets", "services", "persistentvolumeclaims", "persistentvolumes", "events", "configmaps", "storageclasses"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: {{ include "enterprise-steam.fullname" . }}
  labels:
    {{- include "enterprise-steam.labels" . | nindent 4 }}
subjects:
  - kind: ServiceAccount
    namespace: {{ .Release.Namespace }}
    name: {{ include "enterprise-steam.serviceAccountName" . }}
roleRef:
  kind: ClusterRole
  name: {{ include "enterprise-steam.fullname" . }}
  apiGroup: rbac.authorization.k8s.io
{{- end }}