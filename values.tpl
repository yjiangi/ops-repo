
appname: ${AppName}

replicaCount: 1

image:
  repository: ${IMAGE}/${AppName}
  tag: ${ImageTag}
  pullPolicy: IfNotPresent

#imagePullSecrets:
#  - name: prod-secret

podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "${PORT}"

podLabels:
  app: ${AppName}

service:
  type: ClusterIP
  port: ${PORT}

ingress:
  enabled: false
  className: ""
  annotations:
    kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: "true"
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls: []
  #  - secretName: chart-example-tls
  #    hosts:
  #      - chart-example.local

resources:
  limits:
    cpu: 2000m
    memory: 3072Mi
  requests:
    cpu: 100m
    memory: 128Mi

livenessProbe:
  httpGet:
    path: /
    port: http
readinessProbe:
  httpGet:
    path: /
    port: http

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80
  # targetMemoryUtilizationPercentage: 80

volumes:
  - name: host-time
    hostPath:
      path: /etc/localtime
volumeMounts:
  - name: host-time
    mountPath: /etc/localtime

#nodeSelector:
#  venus: app

#tolerations: []

affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchExpressions:
              - key: app
                operator: In
                values:
                  - ${AppName}
          topologyKey: "kubernetes.io/hostname"

