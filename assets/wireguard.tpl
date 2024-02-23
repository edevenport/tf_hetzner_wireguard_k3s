apiVersion: v1
kind: Namespace
metadata:
  name: ${app_name}
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: wg-peer-config-pvc
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
  name: wireguard
  namespace: ${app_name}
data:
  PUID: "1000"
  PGID: "1000"
  TZ: "America/Los_Angeles"
  SERVERURL: ${wg_fqdn}
  SERVERPORT: "51820"
  PEERS: "1"
  PEERDNS: "auto"
  INTERNAL_SUBNET: ${wg_subnet_cidr}
  ALLOWEDIPS: "0.0.0.0/0, ::/0"
  LOG_CONFS: "true"
---
apiVersion: v1
kind: Service
metadata:
  name: wireguard
  namespace: ${app_name}
spec:
  ports:
  - port: 51820
    protocol: UDP
    targetPort: 51820
  type: LoadBalancer
  selector:
    app: wireguard
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wireguard
  namespace: ${app_name}
  labels:
    app: wireguard
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wireguard
  template:
    metadata:
      labels:
        app: wireguard
    spec:
      containers:
      - image: linuxserver/wireguard:latest
        name: wireguard
        envFrom:
        - configMapRef:
            name: wireguard
        ports:
        - containerPort: 51820
          protocol: UDP
        securityContext:
          capabilities:
            add:
            - NET_ADMIN
        volumeMounts:
        - name: wg-peer-config-vol
          mountPath: /config/peer1
      volumes:
      - name: wg-peer-config-vol
        persistentVolumeClaim:
          claimName: wg-peer-config-pvc
