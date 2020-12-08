apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "enterprise-steam.fullname" . }}
  labels:
    {{- include "enterprise-steam.labels" . | nindent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "enterprise-steam.selectorLabels" . | nindent 6 }}
  replicas: {{ .Values.replicaCount }}
  template:
    metadata:
    {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      labels:
        {{- include "enterprise-steam.selectorLabels" . | nindent 8 }}
    spec:
      serviceAccountName: {{ include "enterprise-steam.serviceAccountName" . }}
      securityContext:
        runAsUser: 955
        runAsGroup: 955
        fsGroup: 955
        {{- with .Values.podSecurityContext}}
        {{- toYaml . | nindent 10 }}
        {{- end }}
      containers:
        - name: enterprise-steam
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          {{- with .Values.resources }}
          resources:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          ports:
            - name: steam
              containerPort: 9555
              protocol: TCP
          volumeMounts:
            - mountPath: /opt/h2oai/steam/data
              name: enterprise-steam-data
          securityContext:
            allowPrivilegeEscalation: false
            {{- with .Values.securityContext}}
            {{- toYaml . | nindent 14 }}
            {{- end }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      volumes:
        - name: enterprise-steam-data
          persistentVolumeClaim:
            claimName: {{ include "enterprise-steam.fullname" . }}