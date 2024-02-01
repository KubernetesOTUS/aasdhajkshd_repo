# Репозиторий для выполнения домашних заданий курса "Инфраструктурная платформа на основе Kubernetes-2023-12"

aasdhajkshd repository


> <span style="color:red">INFO</span>
<span style="color:blue">Информация на картинках, как IP адреса, порты или время, может отличаться от приводимой в тексте.</span>

---

## Содержание

* [Знакомство с Kubernetes, основные понятия и архитектура](#kubernetes-intro)
* [Управление жизненным циклом и взаимодействием pod в Kubernetes](#kubernetes-controllers)

---

## <a name="kubernetes-controllers">Управление жизненным циклом и взаимодействием pod в Kubernetes</a>

### ДЗ // Kubernetes controllers. ReplicaSet, Deployment, DaemonSet

#### Выполнение

1. Созданы манифесты `kubernetes-controllers/namespace.yaml`, `kubernetes-controllers/configmap.yaml` и `kubernetes-controllers/desployment.yaml`
2. Манифест `deployment.yaml` имеет *kind: Deployment*, запускает 3 экземпляра пода *replicas: 3*.
3. Добавлен readiness probe, которая проверяяет наличие файла /homework/index.html
4. Описынвается стратегия обновления *RollingUpdate*, настроенную так, что в процессе обновления может быть недоступен максимум 1 pod: *maxUnavailable: 1*.

Резлуьтат примения:

```bash
$ export KUBECONFIG=/tmp/kind/.kube/config; kubectl config use-context kind-kind
Switched to context "kind-kind".

$ kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://127.0.0.1:6443
  name: kind-kind
contexts:
- context:
    cluster: kind-kind
    user: kind-kind
  name: kind-kind
current-context: kind-kind
kind: Config
preferences: {}
users:
- name: kind-kind
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED

$ k get nodes
NAME                 STATUS   ROLES           AGE   VERSION
kind-control-plane   Ready    control-plane   89m   v1.27.3
kind-worker          Ready    <none>          89m   v1.27.3
kind-worker2         Ready    <none>          89m   v1.27.3
kind-worker3         Ready    <none>          89m   v1.27.3

$ kubectl apply -f namespace.yaml
namespace/homework created
$ kubectl get namespace
NAME                 STATUS   AGE
default              Active   4h44m
homework             Active   9s
kube-node-lease      Active   4h44m
kube-public          Active   4h44m
kube-system          Active   4h44m
local-path-storage   Active   4h44m

$ kubectl apply -f configmap.yaml
configmap/nginx-config-homework created

$ kubectl apply -f deployment.yaml
deployment.apps/web created

$ kubectl -n homework get deployments
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
web    3/3     3            3           99s

$ kubectl -n homework get pods -o wide
NAME                   READY   STATUS    RESTARTS   AGE     IP           NODE           NOMINATED NODE   READINESS GATES
web-7c5d79b5bb-894jg   1/1     Running   0          2m20s   10.244.2.2   kind-worker3   <none>           <none>
web-7c5d79b5bb-92z86   1/1     Running   0          2m20s   10.244.1.2   kind-worker    <none>           <none>
web-7c5d79b5bb-czxpz   1/1     Running   0          2m20s   10.244.3.2   kind-worker2   <none>           <none>

$ kubectl -n homework set image deployment/web nginx=nginx:1.16.1
deployment.apps/web image updated

$ kubectl -n homework edit deployment/web
deployment.apps/web edited

$ kubectl -n homework rollout status deployment/web
Waiting for deployment "web" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "web" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "web" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "web" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "web" rollout to finish: 1 old replicas are pending termination...
deployment "web" successfully rolled out


$ kubectl -n homework describe deployments.apps/web
Name:                   web
Namespace:              homework
CreationTimestamp:      Thu, 01 Feb 2024 17:03:39 +0300
Labels:                 app=nginx
                        component=homework
Annotations:            deployment.kubernetes.io/revision: 9
Selector:               app=nginx,component=homework
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 50% max surge
Pod Template:
  Labels:       app=nginx
                component=homework
  Annotations:  kubectl.kubernetes.io/restartedAt: 2024-02-01T17:27:50+03:00
...
    Liveness:   http-get http://:8000/index.html delay=5s timeout=1s period=360s #success=1 #failure=3
    Readiness:  exec [cat /homework/index.html] delay=5s timeout=1s period=30s #success=1 #failure=3
...
```

#### Задание со *

1. Добавление меток *workload* к worker-узлам

```bash
$ kubectl get nodes --show-labels
NAME                 STATUS   ROLES           AGE     VERSION   LABELS
kind-control-plane   Ready    control-plane   6h35m   v1.27.3   ...kubernetes.io/hostname=kind-control-plane,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
kind-worker          Ready    <none>          6h35m   v1.27.3   ...kubernetes.io/hostname=kind-worker,kubernetes.io/os=linux
kind-worker2         Ready    <none>          6h35m   v1.27.3   ...kubernetes.io/hostname=kind-worker2,kubernetes.io/os=linux
kind-worker3         Ready    <none>          6h35m   v1.27.3   ...kubernetes.io/hostname=kind-worker3,kubernetes.io/os=linux

$ kubectl label --list nodes kind-worker3
beta.kubernetes.io/os=linux
kubernetes.io/arch=amd64
kubernetes.io/hostname=kind-worker3
kubernetes.io/os=linux
beta.kubernetes.io/arch=amd64

$ kubectl label nodes kind-worker2 kind-worker3 workload=production
node/kind-worker2 labeled
node/kind-worker3 labeled

$ kubectl label --overwrite=true nodes kind-worker workload=staging
node/kind-worker labeled

$ kubectl get nodes --show-labels
NAME                 STATUS   ROLES           AGE     VERSION   LABELS
...
kind-worker          Ready    <none>          6h38m   v1.27.3   ...workload=staging
kind-worker2         Ready    <none>          6h38m   v1.27.3   ...workload=production
kind-worker3         Ready    <none>          6h38m   v1.27.3   ...workload=production
```

2. Pod'ы запущены равномерно без привязки

```bash
$ kubectl -n homework get pods -o wide
NAME                   READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
web-7679b85bf8-c2d7n   1/1     Running   0          43m   10.244.1.8   kind-worker    <none>           <none>
web-7679b85bf8-lhhm9   1/1     Running   0          43m   10.244.2.7   kind-worker3   <none>           <none>
web-7679b85bf8-rkdfw   1/1     Running   0          43m   10.244.3.7   kind-worker2   <none>           <none>
```

3. Изменения в конфигурации манифестов

для `kubernetes-controllers\deployment.yaml`

```yaml
      nodeSelector:
        workload: production
```

для `kubernetes-intro\pod.yaml`

```yaml
      nodeSelector:
        workload: staging
```

```bash
$ kubectl apply -f deployment.yaml
deployment.apps/web configured

```

> Изменение статуса

```bash
$ kubectl -n homework get pods -o wide
NAME                   READY   STATUS            RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
web-566b65f6b7-hfm4k   0/1     Running           0          5s    10.244.2.8   kind-worker3   <none>           <none>
web-566b65f6b7-r5psl   0/1     Running           0          5s    10.244.3.9   kind-worker2   <none>           <none>
web-566b65f6b7-wfzfb   0/1     PodInitializing   0          5s    10.244.3.8   kind-worker2   <none>           <none>
web-7679b85bf8-lhhm9   1/1     Running           0          44m   10.244.2.7   kind-worker3   <none>           <none>
web-7679b85bf8-rkdfw   1/1     Running           0          44m   10.244.3.7   kind-worker2   <none>           <none>

$ kubectl -n homework get pods -o wide
NAME                   READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
web-566b65f6b7-hfm4k   1/1     Running   0          73s   10.244.2.8   kind-worker3   <none>           <none>
web-566b65f6b7-r5psl   1/1     Running   0          73s   10.244.3.9   kind-worker2   <none>           <none>
web-566b65f6b7-wfzfb   1/1     Running   0          73s   10.244.3.8   kind-worker2   <none>           <none>
```

для `kubernetes-intro\pod.yaml`

```yaml
      nodeSelector:
        workload: staging
```

```bash

$ kubectl apply -f ../kubernetes-intro/pod.yaml
configmap/nginx-config-homework unchanged
pod/web created

```bash
$ kubectl -n homework get pods -o wide
NAME                   READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
web                    1/1     Running   0          6s    10.244.1.9   kind-worker    <none>           <none>
web-566b65f6b7-hfm4k   1/1     Running   0          98s   10.244.2.8   kind-worker3   <none>           <none>
web-566b65f6b7-r5psl   1/1     Running   0          98s   10.244.3.9   kind-worker2   <none>           <none>
web-566b65f6b7-wfzfb   1/1     Running   0          98s   10.244.3.8   kind-worker2   <none>           <none>
```

#### Список документации

- [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Настройка Liveness, Readiness и Startup проб](https://kubernetes.io/ru/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
- [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)

---

## <a name="kubernetes-intro">Знакомство с Kubernetes, основные понятия и архитектура</a>

### ДЗ // Знакомство с решениями для запуска локального Kubernetes кластера, создание первого pod

#### Выполнение

1. Создан файл манифест `kubernetes-intro/namespace.yaml`
2. Создан файл манифест `kubernetes-intro/pod.yaml`
3. Создание namespace *homework*:

```bash
$ kubectl create -f kubernetes-intro/namespace.yaml
namespace/homework created

$ kubectl get namespaces
NAME                   STATUS   AGE
default                Active   72m
homework               Active   20s
---
```

4. Применение манифестов:

```bash
$ kubectl apply -f kubernetes-intro/pod.yaml
configmap "nginx-config-homework" deleted
pod "web" deleted
configmap/nginx-config-homework created
pod/web created
```

5. Описание *pod'а*:

```bash
$ kubectl describe -n homework pod web
Name:             web
Namespace:        homework
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Mon, 15 Jan 2024 21:14:45 +0300
Labels:           app=nginx
                  component=homework
Annotations:      <none>
Status:           Running
IP:               10.244.0.9
IPs:
  IP:  10.244.0.9
Init Containers:
  install:
    Container ID:  docker://b1a094146a6b58ed6375f84893a0834b4e2aa48828fd5fc459d974db2a33b0d5
    Image:         busybox:1.28
    Image ID:      docker-pullable://busybox@sha256:141c253bc4c3fd0a201d32dc1f493bcf3fff003b6df416dea4f41046e0f37d47
    Port:          <none>
    Host Port:     <none>
    Command:
      /bin/sh
      -c
    Args:
      cat << EOF > /init/index.html
      <!DOCTYPE html><html lang="en"><head><title>Hello, World!</title></head><body><h1>Hello, World!</h1><h2>Today is $(date)</h2></body></html>
      EOF

    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Mon, 15 Jan 2024 21:14:46 +0300
      Finished:     Mon, 15 Jan 2024 21:14:46 +0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /init from homework-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-5mqzl (ro)
Containers:
  nginx:
    Container ID:  docker://3a8d1afc4e666be779e647200ea9092b4aa15c917dc2743821631c6bec472a27
    Image:         nginx
    Image ID:      docker-pullable://nginx@sha256:4c0fdaa8b6341bfdeca5f18f7837462c80cff90527ee35ef185571e1c327beac
    Port:          8000/TCP
    Host Port:     0/TCP
    Command:
      nginx-debug
      -g
      daemon off;
    State:          Running
      Started:      Mon, 15 Jan 2024 21:14:49 +0300
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     500m
      memory:  128Mi
    Requests:
      cpu:     500m
      memory:  128Mi
    Environment:
      NGINX_PORT:  8000
    Mounts:
      /etc/nginx/conf.d/homework.conf from nginx-config-volume (rw,path="homework.conf")
      /homework from homework-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-5mqzl (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  homework-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:
    SizeLimit:  <unset>
  nginx-config-volume:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      nginx-config-homework
    Optional:  false
  kube-api-access-5mqzl:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  5m25s  default-scheduler  Successfully assigned homework/web to minikube
  Normal  Pulled     5m24s  kubelet            Container image "busybox:1.28" already present on machine
  Normal  Created    5m24s  kubelet            Created container install
  Normal  Started    5m24s  kubelet            Started container install
  Normal  Pulling    5m23s  kubelet            Pulling image "nginx"
  Normal  Pulled     5m21s  kubelet            Successfully pulled image "nginx" in 1.433760432s (1.433771463s including waiting)
  Normal  Created    5m21s  kubelet            Created container nginx
  Normal  Started    5m21s  kubelet            Started container nginx

```

6. Проверка:

```bash
$ kubectl exec -n homework -it web -- ls -Al
Defaulted container "nginx" out of: nginx, install (init)
total 4
-rw-r--r-- 1 root root 161 Jan 15 18:14 index.html

$ kubectl exec -n homework -it web -- cat /etc/nginx/conf.d/homework.conf
Defaulted container "nginx" out of: nginx, install (init)
server {
    listen 8000;
...

$ kubectl get pods -n homework -o wide
NAME   READY   STATUS    RESTARTS   AGE     IP           NODE       NOMINATED NODE   READINESS GATES
web    1/1     Running   0          2m22s   10.244.0.9   minikube   <none>           <none>

$ kubectl exec -n homework -it web -- curl http://localhost:8000
Defaulted container "nginx" out of: nginx, install (init)
<!DOCTYPE html><html lang="en"><head><title>Hello, World!</title></head><body><h1>Hello, World!</h1><h2>Today is Mon Jan 15 18:14:46 UTC 2024</h2></body></html>

$ kubectl port-forward -n homework pods/web 8000:8000
Forwarding from 127.0.0.1:8000 -> 8000
Handling connection for 8000
```

![](images/Screenshot_20240115_212306.png)

#### Полезные ссылки

- [Deploying Your First Nginx Pod](https://collabnix.github.io/kubelabs/pods101/deploy-your-first-nginx-pod.html)
