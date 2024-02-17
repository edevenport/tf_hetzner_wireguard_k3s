apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: caddy-data-pvc
  namespace: ${app_name}
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-path
  resources:
    requests:
      storage: 5Gi
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: caddyfile
  namespace: ${app_name}
data:
  Caddyfile: |
    ${domain_name} {
      handle_path /* {
        basicauth /* {
          wg ${http_password}
        }
        root * /usr/share/caddy
        file_server
      }
    }
---
apiVersion: v1
kind: Service
metadata:
  name: caddy
  namespace: ${app_name}
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
  - name: https
    port: 443
    protocol: TCP
    targetPort: 443
  type: LoadBalancer
  selector:
    app: caddy
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: caddy
  namespace: ${app_name}
  labels:
    app: caddy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: caddy
  template:
    metadata:
      labels:
        app: caddy
    spec:
      containers:
      - image: caddy:latest
        name: caddy
        securityContext:
          capabilities:
            add:
            - NET_ADMIN
        ports:
        - containerPort: 80
          protocol: TCP
        - containerPort: 443
          protocol: TCP
        volumeMounts:
        - name: caddy-config
          mountPath: /etc/caddy
        - name: caddy-data-vol
          mountPath: /data
        - name: wg-peer-config-vol
          mountPath: /usr/share/caddy
      volumes:
      - name: caddy-config
        configMap:
          name: caddyfile
          items:
          - key: Caddyfile
            path: Caddyfile
      - name: caddy-data-vol
        persistentVolumeClaim:
          claimName: caddy-data-pvc
      - name: wg-peer-config-vol
        persistentVolumeClaim:
          claimName: wg-peer-config-pvc
