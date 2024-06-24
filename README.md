# Репозиторий для выполнения домашних заданий курса "Инфраструктурная платформа на основе Kubernetes-2023-12"

aasdhajkshd repository

> <span style="color:red">INFO</span>
<span style="color:blue">Информация на картинках, как IP адреса, порты или время, может отличаться от приводимой в тексте.</span>

> [Шпаргалка по kubectl](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/)

---

## Содержание

* [Знакомство с Kubernetes, основные понятия и архитектура](#kubernetes-intro)
* [Управление жизненным циклом и взаимодействием pod в Kubernetes](#kubernetes-controllers)
* [Сетевая подсистема и сущности Kubernetes](#kubernetes-networks)
* [Хранение данных в Kubernetes: Volumes, Storages, Statefull-приложения](#kubernetes-volumes)
* [Основы безопасности в Kubernetes](#kubernetes-security)
* [Шаблонизация манифестов. Helm и его аналоги (Jsonnet, Kustomize)](#kubernetes-templating)
* [Custom Resource Definitions. Operators](#kubernetes-operators)
* [Мониторинг компонентов кластера и приложений, работающих в нем](#kubernetes-monitoring)
* [Сервисы централизованного логирования для компонентов Kubernetes и приложений](#kubernetes-logging)
* [CSI. Обзор подсистем хранения данных в Kubernetes](#kubernetes-csi)
* [Хранилище секретов для приложений. Vault](#kubernetes-vault)
* [GitOps и инструменты поставки](#kubernetes-gitops)
* [Подходы к развертыванию и обновлению production-grade кластера](#kubernetes-prod)
* [Диагностика и отладка в Kubernetes](#kubernetes-debug)

---


## <a name="kubernetes-debug">Диагностика и отладка в Kubernetes</a>

### ДЗ // Производить отладку контейнеров и нод Kubernetes с помощью эфемерных контейнеров и kubectl debug

#### Выполнение

Получение доступа `kubectl exec -it -n default deployments/nginx-distroless -- sh` к _distroless_ контейнеру:

```bash
OCI runtime exec failed: exec failed: unable to start container process: exec: "sh": executable file not found in $PATH: unknown
command terminated with exit code 126
```

Добавление эфемерныго контейнера:

```bash
POD_NAME=$(kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl debug -it --attach=false -c ${POD_NAME}-debugger --image=ubuntu ${POD_NAME}
kubectl attach -it -c debugger ${POD_NAME}-test
kubectl get pod ${POD_NAME} -o json | jq -r '.status.ephemeralContainerStatuses'
kubectl get pod ${POD_NAME} -o json | jq -r '.spec.ephemeralContainers'
```

Получение доступа к процессам из `debug` контейнера:

```bash
POD_NAME=$(kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl debug -it --attach=true --image=ubuntu ${POD_NAME} -c nginx-distroless-debugger --copy-to nginx-distroless-${POD_NAME}-test --share-processes --tty=true -- /bin/bash
```

Результат выполнения различных команд:

```output
If you don't see a command prompt, try pressing enter.
root@nginx-distroless-65cfd466bd-xkd7x-test:/# ps aux --forest
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root          14  0.0  0.0   4588  3712 pts/0    Ss   17:38   0:00 /bin/bash
root         952  0.0  0.0   7888  4096 pts/0    R+   18:34   0:00  \_ ps aux --forest
root           7  0.0  0.0  10812  6016 ?        Ss   17:38   0:00 nginx: master process nginx -g daemon off;
tcpdump       13  0.0  0.0  11204  3004 ?        S    17:38   0:00  \_ nginx: worker process
65535          1  0.0  0.0   1028   640 ?        Ss   17:38   0:00 /pause

root@nginx-distroless-65cfd466bd-xkd7x-test:/# ls -Al /proc/$(pgrep nginx | head -n1)/root/etc/nginx/
total 40
drwxr-xr-x 2 root root 4096 Oct  5  2020 conf.d
-rw-r--r-- 1 root root 1007 Apr 21  2020 fastcgi_params
-rw-r--r-- 1 root root 2837 Apr 21  2020 koi-utf
-rw-r--r-- 1 root root 2223 Apr 21  2020 koi-win
-rw-r--r-- 1 root root 5231 Apr 21  2020 mime.types
lrwxrwxrwx 1 root root   22 Apr 21  2020 modules -> /usr/lib/nginx/modules
-rw-r--r-- 1 root root  643 Apr 21  2020 nginx.conf
-rw-r--r-- 1 root root  636 Apr 21  2020 scgi_params
-rw-r--r-- 1 root root  664 Apr 21  2020 uwsgi_params
-rw-r--r-- 1 root root 3610 Apr 21  2020 win-utf
root@nginx-distroless-65cfd466bd-xkd7x-test:/# apt update && apt install -y mc strace tcpdump
...
root@nginx-distroless-65cfd466bd-xkd7x-test:/# tcpdump -nn -i any -e port 80
tcpdump: data link type LINUX_SLL2
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on any, link-type LINUX_SLL2 (Linux cooked v2), snapshot length 262144 bytes

14:47:52.857259 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.34604 > 127.0.0.1.80: Flags [S], seq 3821589659, win 33280, options [mss 65495,sackOK,TS val 1571353223 ecr 0,nop,wscale 7], length 0
14:47:52.857285 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.34604: Flags [S.], seq 139964721, ack 3821589660, win 33280, options [mss 65495,sackOK,TS val 1571353223 ecr 1571353223,nop,wscale 7], length 0
14:47:52.857312 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.34604 > 127.0.0.1.80: Flags [.], ack 1, win 260, options [nop,nop,TS val 1571353223 ecr 1571353223], length 0

14:48:00.838699 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.43114 > 127.0.0.1.80: Flags [S], seq 4200543795, win 33280, options [mss 65495,sackOK,TS val 1571361204 ecr 0,nop,wscale 7], length 0
14:48:00.838714 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.43114: Flags [S.], seq 1641929663, ack 4200543796, win 33280, options [mss 65495,sackOK,TS val 1571361204 ecr 1571361204,nop,wscale 7], length 0
14:48:00.838727 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.43114 > 127.0.0.1.80: Flags [.], ack 1, win 260, options [nop,nop,TS val 1571361204 ecr 1571361204], length 0
14:48:00.839186 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.43128 > 127.0.0.1.80: Flags [S], seq 1666333252, win 33280, options [mss 65495,sackOK,TS val 1571361205 ecr 0,nop,wscale 7], length 0
14:48:00.839198 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.43128: Flags [S.], seq 3967951248, ack 1666333253, win 33280, options [mss 65495,sackOK,TS val 1571361205 ecr 1571361205,nop,wscale 7], length 0
14:48:00.839209 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.43128 > 127.0.0.1.80: Flags [.], ack 1, win 260, options [nop,nop,TS val 1571361205 ecr 1571361205], length 0
14:48:00.839261 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1461: 127.0.0.1.43128 > 127.0.0.1.80: Flags [P.], seq 1:1390, ack 1, win 260, options [nop,nop,TS val 1571361205 ecr 1571361205], length 1389: HTTP: GET / HTTP/1.1
14:48:00.839269 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.43128: Flags [.], ack 1390, win 260, options [nop,nop,TS val 1571361205 ecr 1571361205], length 0
14:48:00.839394 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 310: 127.0.0.1.80 > 127.0.0.1.43128: Flags [P.], seq 1:239, ack 1390, win 260, options [nop,nop,TS val 1571361205 ecr 1571361205], length 238: HTTP: HTTP/1.1 200 OK
14:48:00.839402 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.43128 > 127.0.0.1.80: Flags [.], ack 239, win 259, options [nop,nop,TS val 1571361205 ecr 1571361205], length 0
14:48:00.839428 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 684: 127.0.0.1.80 > 127.0.0.1.43128: Flags [P.], seq 239:851, ack 1390, win 260, options [nop,nop,TS val 1571361205 ecr 1571361205], length 612: HTTP
14:48:00.839432 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.43128 > 127.0.0.1.80: Flags [.], ack 851, win 260, options [nop,nop,TS val 1571361205 ecr 1571361205], length 0
14:48:01.038814 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1387: 127.0.0.1.43128 > 127.0.0.1.80: Flags [P.], seq 1390:2705, ack 851, win 260, options [nop,nop,TS val 1571361404 ecr 1571361205], length 1315: HTTP: GET /favicon.ico HTTP/1.1
14:48:01.038945 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 782: 127.0.0.1.80 > 127.0.0.1.43128: Flags [P.], seq 851:1561, ack 2705, win 260, options [nop,nop,TS val 1571361404 ecr 1571361404], length 710: HTTP: HTTP/1.1 404 Not Found
14:48:01.038952 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.43128 > 127.0.0.1.80: Flags [.], ack 1561, win 260, options [nop,nop,TS val 1571361404 ecr 1571361404], length 0
```

Получение `kubectl logs nginx-distroless-65cfd466bd-xkd7x-test` log-информации '"сбойного контейнера"':

```output
Defaulted container "nginx" out of: nginx, nginx-distroless-65cfd466bd-xkd7x-debugger
127.0.0.1 - - [21/Jun/2024:22:48:00 +0800] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" "-"
127.0.0.1 - - [21/Jun/2024:22:48:01 +0800] "GET /favicon.ico HTTP/1.1" 404 555 "http://localhost:8081/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" "-"
2024/06/21 22:48:01 [error] 13#13: *3 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 127.0.0.1, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "localhost:8081", referrer: "http://localhost:8081/"

```

#### Задание с *

```bash
POD_NAME=$(kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl debug -it --attach=false --image=ubuntu ${POD_NAME} -c nginx-distroless-debugger --copy-to nginx-distroless-test --share-processes --tty=true
kubectl attach -it -c nginx-distroless-debugger nginx-distroless-test
```

Если и внести изменения в сам Deployment, установить на работающиее приложение `securityContext`, это пересоздаст контейнеры - что уже **плохо**,

```bash
$ kubectl patch deployment nginx-distroless --patch '
spec:
  template:
    spec:
      shareProcessNamespace: true
      containers:
      - name: nginx
        securityContext:
          allowPrivilegeEscalation: true
          capabilities:
            add: ["SYS_PTRACE"]'
```

и посмотреть `kubectl get pods nginx-distroless-test -o yaml`

у контейнера *kyos0109/nginx-distroless* - есть права,

```bash
  containers:
  - image: kyos0109/nginx-distroless
    imagePullPolicy: Always
    name: nginx
    ports:
    - containerPort: 80
      protocol: TCP
    resources:
      limits:
        cpu: "1"
        memory: 512Mi
      requests:
        cpu: 500m
        memory: 256Mi
    securityContext:
      allowPrivilegeEscalation: true
      capabilities:
        add:
        - SYS_PTRACE
        - SYS_ADMIN

```

Но, данный контейнер без `shell` и утилит и ничего с ним сделать не получается, следовательно, как внести **securityContext** в контейнер `debug`, который создается к копии под приложения в команде `kubectl debug...`?

А вот у `ubuntu` - нет этих _capabilities_:

```yaml
  - image: ubuntu
    imagePullPolicy: Always
    name: nginx-distroless-debugger
    resources: {}
    stdin: true
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    tty: true
```

Ведь **--copy-to=** создается только копию pod'а в который вносить изменения как в _deployment_ не получается, так же нет возможности сделать **--overrides=**, который есть у `kubectl run...`

И при попытке получить доступ к _pid_'у _nginx_ - ошибка:

```bash
root@nginx-distroless-test:/# strace -p 7
strace: attach: ptrace(PTRACE_SEIZE, 7): Operation not permitted
```

А вот ключ [`--profile=sysadmin`](https://github.com/kubernetes/enhancements/blob/master/keps/sig-cli/1441-kubectl-debug/README.md#profile-sysadmin) добавляет нам **privileged: true** к pod'у диангностики:

```yaml
  - image: ubuntu
    imagePullPolicy: Always
    name: nginx-distroless-debugger
    resources: {}
    securityContext:
      privileged: true
    stdin: true
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    tty: true
```

Таким образом, из `shell` получаем доступ к процессу копии pod'а _nginx.

```bash
root@nginx-distroless-test:/# strace -p 13 -f -yy
strace: Process 13 attached
epoll_wait(8<anon_inode:[eventpoll]>, 
```

В другой консоли запустим `curl -sL http://localhost:8081/`

```bash
[{events=EPOLLIN, data={u32=3491196944, u64=129793107914768}}], 512, -1) = 1
accept4(6<TCP:[0.0.0.0:80]>, {sa_family=AF_INET, sin_port=htons(37238), sin_addr=inet_addr("127.0.0.1")}, [112 => 16], SOCK_NONBLOCK) = 3<TCP:[127.0.0.1:80->127.0.0.1:37238]>
epoll_ctl(8<anon_inode:[eventpoll]>, EPOLL_CTL_ADD, 3<TCP:[127.0.0.1:80->127.0.0.1:37238]>, {events=EPOLLIN|EPOLLRDHUP|EPOLLET, data={u32=3491197408, u64=129793107915232}}) = 0
epoll_wait(8<anon_inode:[eventpoll]>, [{events=EPOLLIN, data={u32=3491197408, u64=129793107915232}}], 512, 60000) = 1
recvfrom(3<TCP:[127.0.0.1:80->127.0.0.1:37238]>, "GET / HTTP/1.1\r\nHost: localhost:"..., 1024, 0, NULL, NULL) = 77
stat("/usr/share/nginx/html/index.html", {st_mode=S_IFREG|0644, st_size=612, ...}) = 0
openat(AT_FDCWD</>, "/usr/share/nginx/html/index.html", O_RDONLY|O_NONBLOCK) = 11</usr/share/nginx/html/index.html>
fstat(11</usr/share/nginx/html/index.html>, {st_mode=S_IFREG|0644, st_size=612, ...}) = 0
writev(3<TCP:[127.0.0.1:80->127.0.0.1:37238]>, [{iov_base="HTTP/1.1 200 OK\r\nServer: nginx/1"..., iov_len=238}], 1) = 238
sendfile(3<TCP:[127.0.0.1:80->127.0.0.1:37238]>, 11</usr/share/nginx/html/index.html>, [0] => [612], 612) = 612
write(5<pipe:[1552318]>, "127.0.0.1 - - [24/Jun/2024:20:21"..., 89) = 89
close(11</usr/share/nginx/html/index.html>) = 0
setsockopt(3<TCP:[127.0.0.1:80->127.0.0.1:37238]>, SOL_TCP, TCP_NODELAY, [1], 4) = 0
epoll_wait(8<anon_inode:[eventpoll]>, [{events=EPOLLIN|EPOLLRDHUP, data={u32=3491197408, u64=129793107915232}}], 512, 65000) = 1
recvfrom(3<TCP:[127.0.0.1:80->127.0.0.1:37238]>, "", 1024, 0, NULL, NULL) = 0
close(3<TCP:[127.0.0.1:80->127.0.0.1:37238]>) = 0
epoll_wait(8<anon_inode:[eventpoll]>, ^Cstrace: Process 13 detached
 <detached ...>

```

---

## <a name="kubernetes-prod">Подходы к развертыванию и обновлению production-grade кластера</a>

### ДЗ // Создание и обновление кластера при помощи kubeadm

#### Выполнение

Необходимо внести изменения в настройки `kubernetes-prod/terraform/stage/terraform.tfvars` для YC.

Например, ключ для доступа к _folder_ YC

```bash
yc iam access-key create --service-account-name sa-otus-kuber-repo-tf --output .secrets/sa.json
```

Создание кластера с использоавнием terraform и ansible ()

```bash
terraform -chdir=terraform/stage/ apply -auto-approve
```

**Результаты выполнения в `kubernetes-prod/README.md`**

```output
null_resource.run_ansible (local-exec): NAME                   STATUS     ROLES           AGE    VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
null_resource.run_ansible (local-exec): fhm5tub66ct0p545llq7   NotReady   <none>          6s     v1.29.6   192.168.99.16   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
null_resource.run_ansible (local-exec): fhmp3j4sp3aki3njfd23   Ready      control-plane   2m7s   v1.29.6   192.168.99.17   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
null_resource.run_ansible (local-exec): fhms3ck7p68bont19jk5   NotReady   <none>          15s    v1.29.6   192.168.99.32   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
null_resource.run_ansible (local-exec): fhmt1bh2p955d0f1f72a   NotReady   <none>          14s    v1.29.6   192.168.99.24   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33

```

Обновление kubernetes

```bash
$ export KUBECONFIG=kubeadm/.secrets/kube-k8s-master-0.conf
$ ansible-playbook -v -T 300 -i environments/stage/inventory.json playbooks/k8s_upgrade.yml
$ kubectl get nodes -o wide
NAME                   STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
fhm5tub66ct0p545llq7   Ready    <none>          12m   v1.29.6   192.168.99.16   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
fhmp3j4sp3aki3njfd23   Ready    control-plane   14m   v1.30.2   192.168.99.17   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
fhms3ck7p68bont19jk5   Ready    <none>          12m   v1.30.2   192.168.99.32   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
fhmt1bh2p955d0f1f72a   Ready    <none>          12m   v1.29.6   192.168.99.24   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
```

Результат:

```bash
$ kubectl get nodes -o wide
NAME                   STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
fhm5tub66ct0p545llq7   Ready    <none>          29m   v1.30.2   192.168.99.16   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
fhmp3j4sp3aki3njfd23   Ready    control-plane   31m   v1.30.2   192.168.99.17   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
fhms3ck7p68bont19jk5   Ready    <none>          29m   v1.30.2   192.168.99.32   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
fhmt1bh2p955d0f1f72a   Ready    <none>          29m   v1.30.2   192.168.99.24   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.6.33
```

В процессе обновления, можно наблюдать, как deployment test pod'ы терминируются при применении _drain_ команды, запуск на другом третьем узле. Здесь не рассматривался вариант, когда приложение работает без перерыва связи. Но для понимания, как выполняется "переезд". В зависимости от этого и реализуется стратегия. Здесь же концептуальный подход к процедуре повышения версии.

```bash
$ kubectl get pods -o wide
NAME                    READY   STATUS        RESTARTS   AGE   IP               NODE                   NOMINATED NODE   READINESS GATES
test-566dbfbbc4-hqlxp   1/1     Running       0          20s   10.244.246.74    fhm5tub66ct0p545llq7   <none>           <none>
test-566dbfbbc4-vqdsp   1/1     Terminating   0          38m   10.244.152.198   fhms3ck7p68bont19jk5   <none>           <none>
```

#### Задание с *

Для выполнения установки **kubespray** необходимо закомментировать _resource "null_resource" "run_ansible"_ в `kubernetes-prod/terraform/stage/resources.tf`, чтобы потом можно было после создания виртуальных машин вручную запустить выполнение ansible для kubespray.

```terraform
resource "local_file" "kubespray_inventory" {
  content = templatefile("${path.module}/templates/kubespray.ini.tpl",
  {
    master_ips = module.kubernetes.master_ip_address
    master_ids = module.kubernetes.master_instance[0]
    worker_ips = module.kubernetes.worker_ip_address
    worker_ids = module.kubernetes.worker_instance[0]
    node_ips = concat(module.kubernetes.master_ip_address, module.kubernetes.worker_ip_address)
  })
  filename = "../../kubespray/inventory/local/inventory.ini"
}
```

Для указания новых параметров количества и характеристик виртуальныхмашин для kubernetes кластера, изменения необходимы в `kubernetes-prod/terraform/modules/kubernetes/variables.tf`

После установки виртуальных машин и сформированного _terraform_'ом `kubespray/inventory/local/inventory.ini` требуется для `ansible` версии ниже 2.17.0.

```bash
git clone https://github.com/kubernetes-sigs/kubespray.git
python3 -m venv .venv
python3 -m pip install ansible ansible-core==2.16.8
python3 -m pip install -r requirements.txt
ansible-playbook -i inventory/local/inventory.ini --become --become-user=root cluster.yml
```

Вывод команды `kubectl get nodes –o wide`

```bash
$ ssh -l ubuntu -i ~/.ssh/id_rsa-appuser 158.160.97.146 kubectl get nodes -o wide
NAME                   STATUS   ROLES           AGE    VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
fhm1q990n3ve0rlv7q48   Ready    <none>          22m    v1.29.5   192.168.99.29   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.7.16
fhm23nh49uft58qu43qa   Ready    control-plane   102m   v1.29.5   192.168.99.27   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.7.16
fhm4jldk6ls9qm2tclqm   Ready    <none>          22m    v1.29.5   192.168.99.14   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.7.16
fhmav03g08hr6feh31au   Ready    <none>          22m    v1.29.5   192.168.99.35   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.7.16
fhmibjl39dmiukfvfsd4   Ready    control-plane   122m   v1.29.5   192.168.99.20   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.7.16
fhms56jfu94iaefdph12   Ready    control-plane   101m   v1.29.5   192.168.99.33   <none>        Ubuntu 20.04.6 LTS   5.4.0-186-generic   containerd://1.7.16
$ ssh -l ubuntu -i ~/.ssh/id_rsa-appuser 158.160.97.146 kubectl get pods -A -o wide
NAMESPACE     NAME                                           READY   STATUS    RESTARTS       AGE    IP              NODE                   NOMINATED NODE   READINESS GATES
kube-system   calico-kube-controllers-68485cbf9c-jbvcb       1/1     Running   0              19m    10.233.79.1     fhm1q990n3ve0rlv7q48   <none>           <none>
kube-system   calico-node-2q5mn                              1/1     Running   0              20m    192.168.99.33   fhms56jfu94iaefdph12   <none>           <none>
kube-system   calico-node-7ms9h                              1/1     Running   0              20m    192.168.99.14   fhm4jldk6ls9qm2tclqm   <none>           <none>
kube-system   calico-node-9qptt                              1/1     Running   0              20m    192.168.99.27   fhm23nh49uft58qu43qa   <none>           <none>
kube-system   calico-node-dbf2f                              1/1     Running   0              20m    192.168.99.29   fhm1q990n3ve0rlv7q48   <none>           <none>
kube-system   calico-node-k86jp                              1/1     Running   0              20m    192.168.99.20   fhmibjl39dmiukfvfsd4   <none>           <none>
kube-system   calico-node-mrqw8                              1/1     Running   0              20m    192.168.99.35   fhmav03g08hr6feh31au   <none>           <none>
kube-system   coredns-69db55dd76-b49fg                       1/1     Running   0              17m    10.233.79.65    fhms56jfu94iaefdph12   <none>           <none>
kube-system   coredns-69db55dd76-tq9mh                       1/1     Running   0              17m    10.233.74.2     fhm23nh49uft58qu43qa   <none>           <none>
kube-system   dns-autoscaler-6f4b597d8c-plx7t                1/1     Running   0              17m    10.233.74.1     fhm23nh49uft58qu43qa   <none>           <none>
kube-system   kube-apiserver-fhm23nh49uft58qu43qa            1/1     Running   0              102m   192.168.99.27   fhm23nh49uft58qu43qa   <none>           <none>
kube-system   kube-apiserver-fhmibjl39dmiukfvfsd4            1/1     Running   2              122m   192.168.99.20   fhmibjl39dmiukfvfsd4   <none>           <none>
kube-system   kube-apiserver-fhms56jfu94iaefdph12            1/1     Running   0              102m   192.168.99.33   fhms56jfu94iaefdph12   <none>           <none>
kube-system   kube-controller-manager-fhm23nh49uft58qu43qa   1/1     Running   1              102m   192.168.99.27   fhm23nh49uft58qu43qa   <none>           <none>
kube-system   kube-controller-manager-fhmibjl39dmiukfvfsd4   1/1     Running   2              122m   192.168.99.20   fhmibjl39dmiukfvfsd4   <none>           <none>
kube-system   kube-controller-manager-fhms56jfu94iaefdph12   1/1     Running   1              102m   192.168.99.33   fhms56jfu94iaefdph12   <none>           <none>
kube-system   kube-proxy-7x88q                               1/1     Running   0              22m    192.168.99.27   fhm23nh49uft58qu43qa   <none>           <none>
kube-system   kube-proxy-c9v7h                               1/1     Running   0              22m    192.168.99.14   fhm4jldk6ls9qm2tclqm   <none>           <none>
kube-system   kube-proxy-g6rtv                               1/1     Running   0              22m    192.168.99.20   fhmibjl39dmiukfvfsd4   <none>           <none>
kube-system   kube-proxy-qgxz4                               1/1     Running   0              22m    192.168.99.35   fhmav03g08hr6feh31au   <none>           <none>
kube-system   kube-proxy-thpsk                               1/1     Running   0              22m    192.168.99.29   fhm1q990n3ve0rlv7q48   <none>           <none>
kube-system   kube-proxy-v7sg7                               1/1     Running   0              22m    192.168.99.33   fhms56jfu94iaefdph12   <none>           <none>
kube-system   kube-scheduler-fhm23nh49uft58qu43qa            1/1     Running   2 (101m ago)   102m   192.168.99.27   fhm23nh49uft58qu43qa   <none>           <none>
kube-system   kube-scheduler-fhmibjl39dmiukfvfsd4            1/1     Running   1              122m   192.168.99.20   fhmibjl39dmiukfvfsd4   <none>           <none>
kube-system   kube-scheduler-fhms56jfu94iaefdph12            1/1     Running   1              102m   192.168.99.33   fhms56jfu94iaefdph12   <none>           <none>
kube-system   nginx-proxy-fhm1q990n3ve0rlv7q48               1/1     Running   0              22m    192.168.99.29   fhm1q990n3ve0rlv7q48   <none>           <none>
kube-system   nginx-proxy-fhm4jldk6ls9qm2tclqm               1/1     Running   0              22m    192.168.99.14   fhm4jldk6ls9qm2tclqm   <none>           <none>
kube-system   nginx-proxy-fhmav03g08hr6feh31au               1/1     Running   0              22m    192.168.99.35   fhmav03g08hr6feh31au   <none>           <none>
kube-system   nodelocaldns-6ttt7                             1/1     Running   0              17m    192.168.99.33   fhms56jfu94iaefdph12   <none>           <none>
kube-system   nodelocaldns-8dwlf                             1/1     Running   0              17m    192.168.99.35   fhmav03g08hr6feh31au   <none>           <none>
kube-system   nodelocaldns-bbjn9                             1/1     Running   0              17m    192.168.99.27   fhm23nh49uft58qu43qa   <none>           <none>
kube-system   nodelocaldns-kvkzq                             1/1     Running   0              17m    192.168.99.29   fhm1q990n3ve0rlv7q48   <none>           <none>
kube-system   nodelocaldns-nf44g                             1/1     Running   0              17m    192.168.99.14   fhm4jldk6ls9qm2tclqm   <none>           <none>
kube-system   nodelocaldns-xl496                             1/1     Running   0              17m    192.168.99.20   fhmibjl39dmiukfvfsd4   <none>           <none>

```

---

#### Список документации:

* [Automating System Updates for Kubernetes Clusters using Ansible](https://itnext.io/automating-system-updates-for-kubernetes-clusters-using-ansible-94a70f4e1972)
* [Install packages in a virtual environment using pip and venv](https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/)

---

## <a name="kubernetes-gitops">GitOps и инструменты поставки</a>

### ДЗ // GitOps и инструменты поставки

#### Выполнение

```bash
kubectl taint nodes --overwrite=true $(kubectl get nodes -o name | cut -f2 -d'/' | tail -n1) node-role=infra:NoSchedule
kubectl label nodes --overwrite=true $(kubectl get nodes -o name | cut -f2 -d'/' | tail -n1) workload=argocd
kubectl label nodes --overwrite=true $(kubectl get nodes -o name | cut -f2 -d'/' | head -n1) workload=production # чтобы приложение из network установилось
kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints,LABELS:.metadata.labels
```

Разметка узлов:

```output
NAME                        TAINTS                                               LABELS
cl1l5bap1aj1ve73gt9u-afyf   <none>                                               map[...topology.kubernetes.io/zone:ru-central1-a workload=production]
cl1l5bap1aj1ve73gt9u-erun   <none>                                               map[...topology.kubernetes.io/zone:ru-central1-a]
cl1l5bap1aj1ve73gt9u-ocil   <none>                                               map[...topology.kubernetes.io/zone:ru-central1-a]
cl1l5bap1aj1ve73gt9u-omyq   [map[effect:NoSchedule key:node-role value:infra]]   map[...topology.kubernetes.io/zone:ru-central1-a workload:argocd ...]
```

```bash
helm pull oci://cr.yandex/yc-marketplace/yandex-cloud/argo/chart/argo-cd --version 5.46.8-6 --untar
helm install --namespace argo --create-namespace argo-cd ./argo-cd/
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Установка была выполнена с использованием _terraform_:

```tf
data.yandex_kubernetes_cluster.this: Reading...
data.yandex_kubernetes_cluster.this: Read complete after 0s [id=cat0e4p2c14825kmt7o6]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # helm_release.this will be created
  + resource "helm_release" "this" {
      + atomic                     = true
      + chart                      = "argo-cd"
      + cleanup_on_fail            = true
      + create_namespace           = true
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 3
      + metadata                   = (known after apply)
      + name                       = "argocd"
      + namespace                  = "argocd"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "oci://cr.yandex/yc-marketplace/yandex-cloud/argo/chart"
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + values                     = []
      + verify                     = false
      + version                    = "5.46.8-6"
      + wait                       = true
      + wait_for_jobs              = false

      + set {
          + name  = "global.nodeSelector.workload"
          + value = "argocd"
            # (1 unchanged attribute hidden)
        }
      + set {
          + name  = "global.tolerations[0].effect"
          + value = "NoSchedule"
            # (1 unchanged attribute hidden)
        }
      + set {
          + name  = "global.tolerations[0].key"
          + value = "node-role"
            # (1 unchanged attribute hidden)
        }
      + set {
          + name  = "global.tolerations[0].operator"
          + value = "Equal"
            # (1 unchanged attribute hidden)
        }
      + set {
          + name  = "global.tolerations[0].value"
          + value = "infra"
            # (1 unchanged attribute hidden)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + argocd_version               = (known after apply)
  + chart_version                = (known after apply)
  + helm_revision                = (known after apply)
helm_release.this: Creating...
helm_release.this: Still creating... [10s elapsed]
helm_release.this: Still creating... [20s elapsed]
helm_release.this: Still creating... [30s elapsed]
helm_release.this: Creation complete after 31s [id=argocd]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

argocd_version = "v2.8.4"
chart_version = "5.46.8-6"
cluster_external_v4_endpoint = "https://158.160.36.230"
helm_revision = 1
```

```bash
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

![Reference](/images/Screenshot_20240429_234800.png)

---

#### Список документации:

* [terraform-yc-modules / terraform-yc-kubernetes](https://github.com/terraform-yc-modules/terraform-yc-kubernetes/tree/master)
* [ArgoCD deployment by Terraform](https://github.com/adv4000/argocd-terraform.git)
* [ArgoCD Applications per EKS Cluster](https://github.com/adv4000/argocd)
* [Установка Jenkins с помощью terraform в Kubernetes в Yandex Cloud с letsencypt](https://habr.com/ru/articles/683844/)

---

## <a name="kubernetes-vault">Хранилище секретов для приложений. Vault</a>

### ДЗ // Хранилище секретов для приложения. Vault

#### Выполнение

```bash
helmfile apply --validate -f helmfile.yaml
```

В `pod` _vault-X_ выполняется инициализация:

```bash
vault operator init -key-shares=1 -key-threshold=1

vault login token=...
vault secrets enable -version=2 -description="Otus homework" -path=otus kv
vault kv put otus/cred username='otus' password='asajkjkahs'

vault kv get otus/cred

vault policy write otus-policy - <<EOF
path "otus/*" {
    capabilities = ["read", "list"]
}
EOF

vault auth enable kubernetes

vault write auth/kubernetes/config \
  disable_iss_validation=true \
  token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
  issuer="https://kubernetes.default.svc.cluster.local"
  
vault write auth/kubernetes/role/otus \
  bound_service_account_names=vault-auth \
  bound_service_account_namespaces=default,vault,external-secrets \
  policies=otus-policy \
  ttl=72h

vault read auth/kubernetes/role/otus
vault kv get -mount="otus" "cred"
vault auth list
vault secrets list --detailed
```

Проверка получения доступа, в `vault-0` нет curl, поэтому используем `kubernetes-monitoring/console.yaml`

```bash
curl -vLk --header "X-Vault-Token: ..." --request GET http://vault.vault.svc.cluster.local:8200/v1/otus/data/cred
```

Для доступа kubernetes применяются следующие манифесты:

```bash
kubectl apply -n vault -f serviceaccount.yaml
kubectl apply -n vault -f clusterrolebinding.yaml
kubectl apply -n vault -f external-secrets.yaml
```

Проверка создания ESO секретов из Vault'а:

```bash
kubectl get externalsecrets.external-secrets.io
kubectl describe externalsecrets.external-secrets.io vault-otus-cred-kubernetes
kubectl describe secrets otus-cred
kubectl apply -f pod.yaml
kubectl exec -ti -n vault pods/test -- cat /vault/secrets/config.txt
```

Результат:

```output
NAME                         STORE                      REFRESH INTERVAL   STATUS         READY
vault-otus-cred-kubernetes   vault-backend-kubernetes   15s                SecretSynced   True
vault-otus-cred-token        vault-backend-token        15s                SecretSynced   True
...

Status:
  Binding:
    Name:  otus-cred
  Conditions:
    Last Transition Time:   2024-04-26T16:06:52Z
    Message:                Secret was synced
    Reason:                 SecretSynced
    Status:                 True
    Type:                   Ready
  Refresh Time:             2024-04-26T16:08:42Z
  Synced Resource Version:  1-363819bb4b55b71d2b8af02b17981e24
Events:
  Type    Reason   Age                From              Message
  ----    ------   ----               ----              -------
  Normal  Updated  2s (x8 over 112s)  external-secrets  Updated Secret
...

Name:         otus-cred
Namespace:    default
Labels:       reconcile.external-secrets.io/created-by=154221e1de97ef5e01363f3b2b524406
Annotations:  reconcile.external-secrets.io/data-hash: f445955da15f3ae1278448facb7667cf

Type:  Opaque

Data
====
password:  10 bytes
username:  4 bytes

$ kubectl get secrets otus-cred -o json | jq -r '.data'
{
  "password": "YXNhamtqa2Focw==",
  "username": "b3R1cw=="
}
...

Defaulted container "test" out of: test, vault-agent, vault-agent-init (init)
data: map[password:asajkjkahs username:otus]
metadata: map[created_time:2024-04-26T12:53:28.070451868Z custom_metadata:<nil> deletion_time: destroyed:false version:1]
```

---

#### Список документации:

* [What is Vault](https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-intro)
* [Kubernetes auth method](https://developer.hashicorp.com/vault/docs/auth/kubernetes)
* [HashiCorp Vault](https://external-secrets.io/latest/provider/hashicorp-vault/)
* [Deploy service and endpoints to address an external Vault](https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-external-vault)

---

## <a name="kubernetes-csi">CSI. Обзор подсистем хранения данных в Kubernetes</a>

### ДЗ // Установка и использование CSI драйвера

#### Выполнение

```bash
export HELM_EXPERIMENTAL_OCI=1
SA_CSI_NAME=sa-otus-kuber-repo-sci
YC_FOLDER_ID=$(yc resource-manager folder list --format json | jq -r '.[].id')
yc storage bucket create --name s3-$YC_FOLDER_ID-sci
yc iam service-account create --name $SA_CSI_NAME --description "CSI Service Account for S3 bucket"
YC_SA_ID=$(yc iam service-account get --name $SA_CSI_NAME --format json | jq -r '.id')
yc resource-manager folder add-access-binding $YC_FOLDER_ID --role storage.editor --subject serviceAccount:$YC_SA_ID
yc iam service-account set-access-bindings $YC_SA_ID --access-binding role=storage.editor,subject=serviceAccount:$YC_SA_ID
yc iam key create --service-account-name $SA_CSI_NAME --output key.json
yc iam access-key create --service-account-name=$SA_CSI_NAME
```

```output
name: s3-b1gui0rctn8j2m54dpnu-sci
folder_id: b1gui0rctn8j2m54dpnu
anonymous_access_flags:
  read: false
  list: false
default_storage_class: STANDARD
versioning: VERSIONING_DISABLED
acl: {}
created_at: "2024-04-17T20:04:10.661832Z"
...
done (1s)
id: aje4v88tldsqn6r90a67
folder_id: b1gui0rctn8j2m54dpnu
created_at: "2024-04-17T20:05:22.041230584Z"
name: sa-otus-kuber-repo-sci
description: CSI Service Account for S3 bucket
...
effective_deltas:
  - action: ADD
    access_binding:
      role_id: storage.editor
      subject:
        id: aje4v88tldsqn6r90a67
        type: serviceAccount
...
effective_deltas:
  - action: ADD
    access_binding:
      role_id: storage.editor
      subject:
        id: aje4v88tldsqn6r90a67
        type: serviceAccount
...
id: ajeaao7orubqv2r8bc8a
service_account_id: aje4v88tldsqn6r90a67
created_at: "2024-04-17T20:08:16.581124336Z"
key_algorithm: RSA_2048
...
access_key:
  id: aje5h876s8t8rpaqnah7
  service_account_id: aje4v88tldsqn6r90a67
  created_at: "2024-04-17T20:08:25.532555244Z"
  key_id: YCAJENew8pXmv3i29jwIaupdV
secret: YCOpVhF6QnbnKmlIauXTu5**********
```

```bash
helm repo add yandex-s3 https://yandex-cloud.github.io/k8s-csi-s3/charts
helm pull yandex-s3/csi-s3
```

Внесение изменений в `csi-s3/values.yaml`

```bash
helm install --atomic csi-s3 csi-s3/
kubectl get storageclasses.storage.k8s.io csi-s3
```

```output
NAME     PROVISIONER        RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
csi-s3   ru.yandex.s3.csi   Delete          Immediate           false                  52m
```

```bash
kubectl apply -f pod.yaml
kubectl get pvc csi-s3-pvc
```

```output
NAME         STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
csi-s3-pvc   Bound    pvc-74261ccf-1a83-4169-9dc0-5954b03f60a4   5Gi        RWX            csi-s3         76m
```

![Reference](/images/Screenshot_20240418_005700.png)

---

#### Список документации:

* [CSI for S3](https://github.com/yandex-cloud/k8s-csi-s3)

---

## <a name="kubernetes-logging">Сервисы централизованного логирования для компонентов Kubernetes и приложений</a>

### ДЗ // Сервисы централизованного логирования для Kubernetes

#### Выполнение

```bash
kubectl taint nodes --overwrite=true $(kubectl get nodes -o name | cut -f2 -d'/' | tail -n1) node-role=infra:NoSchedule
kubectl get nodes
kubectl label nodes --overwrite=true $(kubectl get nodes -o name | cut -f2 -d'/' | tail -n1) workload=infra
kubectl get node -o wide --show-labels

kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints
```

```output
NAME                        STATUS   ROLES    AGE     VERSION   INTERNAL-IP     EXTERNAL-IP      OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME     LABELS
cl1l5bap1aj1ve73gt9u-idib   Ready    <none>   151m    v1.27.3   192.168.21.8    158.160.57.240   Ubuntu 20.04.6 LTS   5.4.0-167-generic   containerd://1.6.22   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=standard-v3,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/zone=ru-central1-a,kubernetes.io/arch=amd64,kubernetes.io/hostname=cl1l5bap1aj1ve73gt9u-idib,kubernetes.io/os=linux,node-group=default-pool,node.kubernetes.io/instance-type=standard-v3,node.kubernetes.io/kube-proxy-ds-ready=true,node.kubernetes.io/masq-agent-ds-ready=true,node.kubernetes.io/node-problem-detector-ds-ready=true,topology.kubernetes.io/zone=ru-central1-a,yandex.cloud/node-group-id=cath3tqaonav9gh3hugt,yandex.cloud/pci-topology=k8s,yandex.cloud/preemptible=true
cl1l5bap1aj1ve73gt9u-ykuc   Ready    <none>   2d21h   v1.27.3   192.168.21.32   84.252.128.204   Ubuntu 20.04.6 LTS   5.4.0-167-generic   containerd://1.6.22   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=standard-v3,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/zone=ru-central1-a,kubernetes.io/arch=amd64,kubernetes.io/hostname=cl1l5bap1aj1ve73gt9u-ykuc,kubernetes.io/os=linux,node-group=default-pool,node.kubernetes.io/instance-type=standard-v3,node.kubernetes.io/kube-proxy-ds-ready=true,node.kubernetes.io/masq-agent-ds-ready=true,node.kubernetes.io/node-problem-detector-ds-ready=true,topology.kubernetes.io/zone=ru-central1-a,**workload=infra**,yandex.cloud/node-group-id=cath3tqaonav9gh3hugt,yandex.cloud/pci-topology=k8s,yandex.cloud/preemptible=true

NAME                        TAINTS
cl1l5bap1aj1ve73gt9u-idib   <none>
cl1l5bap1aj1ve73gt9u-ykuc   [map[effect:NoSchedule key:node-role value:infra]]
```

Создание бакета в _S3 object storage_ и _Service Account_ для доступа к бакету с ключами доступа:

```bash
export HELM_EXPERIMENTAL_OCI=1
SA_LOKI_NAME=sa-otus-kuber-repo-loki
YC_FOLDER_ID=$(yc resource-manager folder list --format json | jq -r '.[].id')
yc storage bucket create --name s3-$YC_FOLDER_ID-loki
yc iam service-account create --name $SA_LOKI_NAME --description "Loki Service Account for S3 bucket"
YC_SA_ID=$(yc iam service-account get --name $SA_LOKI_NAME --format json | jq -r '.id')
yc iam service-account add-access-binding $YC_SA_ID --role storage.editor --subject userAccount:$YC_SA_ID
yc iam key create --service-account-name $SA_LOKI_NAM   E --output ../.secrets/key.json
yc iam access-key create --service-account-name=$SA_LOKI_NAME
helmfile apply -f helmfile.yaml
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
kubectl port-forward -n monitoring deployments/loki-stack-grafana 3000:3000
kubectl -n monitoring create deployment flog --image=mingrammer/flog --replicas=3 -- flog -f rfc3164 -l -d 300ms
kubectl -n monitoring get pods
kubectl -n monitoring logs deployments/flog
```

```output
access_key:
  id: aje99pm9gsu2nersuojr
  service_account_id: ajep4lthb5kaql17jfdv
  created_at: "2024-03-29T20:04:39.629033107Z"
  key_id: YCAJENo8j5r0mfUvt6pHdneUY
secret: YCMSWoEO5WKT4-r5XKkw********** 

```

![Reference](/images/Screenshot_20240402_134700.png)

Импорт dashboard [Logs / App](https://grafana.com/grafana/dashboards/13639-logs-app/)

Можно попробовать применить [LogQL](https://sbcode.net/grafana/nginx-promtail/) для выделения сообщений из [fake log generator](https://github.com/mingrammer/flog)

```logql
{job="monitoring/flog"} | regexp `(?P<timestamp>\w{3} \d{2} \d{2}:\d{2}:\d{2}) (?P<hostname>\S+) (?P<program>\S+)\[(?P<pid>\d+)\]: (?P<message>.*)`
```

![Reference](/images/Screenshot_20240401_131100.png)

---

## <a name="kubernetes-monitoring">Мониторинг компонентов кластера и приложений, работающих в нем</a>

### ДЗ // Мониторинг приложения в кластере

#### Выполнение

Docker контейнер с _nginx:1.25.4-bookworm_ уже собран с модулем **--with-http_stub_status_module**, поэтому в `charts/web/values.yaml` для сбору метрик остается добавить "location = /basic_status"

Адаптирован Chart `homework/charts/web` из предыдущего задания и к _helmfile.yaml_ добавлены _prometheus operator_ и _nginx prometheus exporter_.
Добавлен файл в шаблоны `homework/charts/web/templates/servicemonitor.yaml`

```bash
helmfile apply -f helmfile.yaml
kubectl port-forward services/kube-prometheus-prometheus 9090:9090
```

![Reference](/images/Screenshot_20240319_003556.png)

---

## <a name="kubernetes-operators">Custom Resource Definitions. Operators</a>

### ДЗ // Создание собственного CRD

#### Выполнение

В папке `kubernetes-operators/manifests` приложены файлы для первой части задания.
Образ с *Kopf* был пересобран _23f03013e37f/otus-2023-12-mysql-operator:0.0.1_, внесены изменения с учётом "ошибок" типа _AlreadyExists_ и добавлено [удаление](https://github.com/kubernetes-client/python/blob/master/kubernetes/docs/CoreV1Api.md#delete_namespaced_persistent_volume_claim).

#### Задание с *

Рассмотрено уменьшение возможности прав доступа для макета _clusterrole.yaml_. Значения подбирался с учетом ошибкок *Forbidden:403*, анализируя log pod'а _mysql-operator_ на попытки создать через API резурсы в кластере. Если сразу использовать SDK, то формируются права доступа для контроллера непосредственно, например, `kubernetes-operators/mysql/config/rbac`.

#### Задание с **

```bash
curl -L -o kubebuilder "https://go.kubebuilder.io/dl/latest/$(go env GOOS)/$(go env GOARCH)"
chmod +x kubebuilder && sudo mv kubebuilder /usr/local/bin/
mkdir -p mysql
git clone git@github.com:grtl/mysql-operator.git
wget https://go.dev/dl/go1.22.1.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz

cd mysql

kubebuilder init --repo mysql
kubebuilder create api --group otus.homework --namespaced --version v1 --kind MySQL --controller --resource --plural mysqls --force

make manifests

make run

kubectl apply -f config/crd/bases/otus.homework_mysqls.yaml
kubectl apply -f config/samples/otus.homework_v1_mysql.yaml
kubectl api-resources -o wide --api-group='otus.homework'
kubectl api-versions
kubectl get mysqls
```

В _kubebuilder_ изменения вносились в файлы:

- `kubernetes-operators/mysql/api/v1/mysql_types.go`, например, в части структуры "type MySQLSpec struct"
- `kubernetes-operators/mysql/internal/controller/mysql_controller.go` в методе "Reconcile" добавлены примеры, как знакомство, содание сущностей ServiceAccount, ClusterRole, ClusterRoleBinding и Deployment оператора MySQL, рассмотрен вариант удаления,
- `kubernetes-operators/mysql/internal/controller/mysql_controller_test.go` добавлен пример проверки значений из *mysql.spec*.

---

#### Список документации:

- [KubeBuilber Quick Start](https://book.kubebuilder.io/quick-start.html)
- [Package v1 is the v1 version of the core API](https://pkg.go.dev/k8s.io/api@v0.29.0/core/v1)
- [Custom Resource Definitions (CRD) в Kubernetes. Операторы](https://youtu.be/AuuIhT1QeSI?si=3aGQHLoYDw8Vzc8W)

---

## <a name="kubernetes-templating">Шаблонизация манифестов. Helm и его аналоги (Jsonnet, Kustomize)</a>

### ДЗ // Шаблонизация манифестов приложения, использование Helm. Установка community Helm charts

#### Выполнение

**Задание 1**

Создан helm-chart `web`, который позволяет устанавливать приложение, которое использует манифесты из ДЗ 1-5. Учетены основные параметры: имена контейнеров, имена объектов, используемые образы, хостов, порты, количество запускаемых реплик и т.д.

Описание переменных вынесены в _values.yaml_ в Chart'е `homework/web`.

```bash
for i in metrics-server dashboard volumesnapshots ingress-dns ingress storage-provisioner csi-hostpath-driver; do minikube addons enable $i; done
helm repo update
helm dependency build homework/
helm template --debug web homework/
helm install --atomic --debug web homework/
```

Loki прописан как сервис-зависимость в `homework/Chart.yaml`.

**Задание 2**

> All listeners are configured with protocol 'SASL_PLAINTEXT' by default. See [Upgrading](https://github.com/bitnami/charts/tree/main/bitnami/kafka)

```bash
export HELM_EXPERIMENTAL_OCI=1
helm repo add bitnami https://charts.bitnami.com/bitnami
helm pull oci://registry-1.docker.io/bitnamicharts/kafka --version ^25.3.5 --untar --untardir kafka-25.3.5
```

Установка локально для проверки в minikube:

```bash
helm install --atomic kafka bitnami/kafka --version ^25.3.5 \
 --create-namespace --namespace prod \
 --set controller.replicaCount=5,listeners.persistence.size=1Gi,logPersistence.size=1Gi,auth.clientProtocol=plaintext,serviceAccount.create=true
  
helm install --atomic kafka bitnami/kafka --version ^27.1.1 \
 --create-namespace --namespace dev \
 --set controller.replicaCount=1,listeners.client.protocol=PLAINTEXT,listeners.controller.protocol=PLAINTEXT,listeners.interbroker.protocol=PLAINTEXT,listeners.external.protocol=PLAINTEXT,persistence.size=1Gi,logPersistence.size=1Gi,auth.clientProtocol=plaintext,serviceAccount.create=true

kubectl run kafka-client --restart='Never' --image docker.io/bitnami/kafka:3.7.0-debian-12-r0 --namespace dev --command -- sleep infinity

PRODUCER: kafka-console-producer.sh --broker-list kafka-controller-0.kafka-controller-headless.dev.svc.cluster.local:9092 --topic test

CONSUMER: kafka-console-consumer.sh --bootstrap-server kafka.dev.svc.cluster.local:9092 --topic test --from-beginning
```

![Reference](/images/Screenshot_20240311_214058.png)

Установка в кластер _kind_ с помощью **helmfile**'а из директории:

```bash
helmfile init --force
helmfile apply --kube-context kind -i -f ./helmfile.yaml
```

[Environment Values](https://helmfile.readthedocs.io/en/latest/#environment-values)

В директории `helmfile` можно выполнить установку с использованием переназначения _dev_ в _staging_:

```bash
helmfile template --kube-context kind --debug --environment staging -f helmfile/helmfile.yaml
```

PS. не получается использовать как в примере [Helmfile Быстрый старт](ttps://github.com/zam-zam/helmfile-examples) [_Templates_](https://helmfile.readthedocs.io/en/latest/#environment-values)

---

## <a name="kubernetes-security">Основы безопасности в Kubernetes</a>

### ДЗ // Настройка сервисных аккаунтов и ограничение прав для них

#### Выполнение

1. Манифесты в папке `web`

```bash
for i in metrics-server dashboard volumesnapshots; do minikube addons enable $i; done
kubectl label nodes --overwrite=true minikube workload=production
kubectl get nodes --show-labels=true
```

2. Проверка доступности из shell оболочки _pod_ **web**:

```bash
APISERVER=https://minikube:8443
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)
TOKEN=$(cat ${SERVICEACCOUNT}/token)
CACERT=${SERVICEACCOUNT}/ca.crt

curl -k --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api 
curl -k -s --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/metrics | head -5
```

Результат:

```output

# HELP aggregator_discovery_aggregation_count_total [ALPHA] Counter of number of times discovery was aggregated
# TYPE aggregator_discovery_aggregation_count_total counter
aggregator_discovery_aggregation_count_total 558
...
```

3. Возможность внесения изменений через API, см. `console`

```bash
curl -k --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/apis/apps/v1/namespaces/${NAMESPACE}/deployments
curl -k --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/${NAMESPACE}/endpoints
curl -k --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/${NAMESPACE}/pods
curl -k --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/${NAMESPACE}/services
curl -k --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/apis/apps/v1/namespaces/${NAMESPACE}/deployments/web

curl -k --cacert ${CACERT} --retry 3 --retry-delay 3 -X PATCH \
  -H "Content-Type: application/strategic-merge-patch+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  --data '{"spec":{"replicas":4}}' \
  ${APISERVER}/apis/apps/v1/namespaces/${NAMESPACE}/deployments/web
  
curl -ks --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/apis/apps/v1/namespaces/${NAMESPACE}/deployments/web | jq -r '.spec.replicas'
```

Проверка, что доступность получения списка _list_ endpoints не выполняется, но есть доступ _get_ к endpoint /metrics-server

```bash
curl -ks --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/kube-system/endpoints | jq -r '.message'
```


```output
endpoints is forbidden: User "system:serviceaccount:homework:monitoring" cannot list resource "endpoints" in API group "" in the namespace "kube-system"
```

```bash
curl -ks --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/kube-system/endpoints/metrics-server | jq -r '.metadata.name'
```

```output
metrics-server
```

4. Манифесты для создания _Service Account_'а **cd** в папке `cd`:
  
```bash
kubectl get secret cd -n homework  -o jsonpath='{.data.ca\.crt}' | base64 --decode > ca.crt
kubectl create token cd --namespace homework --duration=24h > token

kubectl config set-cluster minikube-cd --server=https://192.168.49.2:8443 --certificate-authority=ca.crt
kubectl config set-credentials cd --token="$(kubectl create token cd --namespace homework --duration=24h)"
kubectl config set-context minikube-cd --cluster=minikube-cd --user=cd --namespace=homework
kubectl config use-context minikube-cd
```

![Reference](/images/Screenshot_20240310_155821.png)

Проверка, что в своём _namespace_ **homework** доступ есть, но не более

```bash
kubectl --kubeconfig kubeconfig  get deployments -o wide
```

```output
NAME   READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS      IMAGES                                  SELECTOR
web    1/1     1            1           40m   metrics,nginx   curlimages/curl,nginx:1.25.4-bookworm   app=nginx,component=homework
```

```bash
kubectl --kubeconfig kubeconfig --namespace default get deployments
```

```output
Error from server (Forbidden): deployments.apps is forbidden: User "system:serviceaccount:homework:cd" cannot list resource "deployments" in API group "apps" in the namespace "default"
```

#### Задание с *

1. Добавлен в манифест `web/deployment.yaml` дополнительный _pod_ для скачивания и сохранения результата /metrics, содержимое которого доступно по адресу /metrics.html

![Reference](/images/Screenshot_20240310_152443.png)

---

#### Список документации:

- [JSON Web Tokens](https://jwt.io)
- [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Organizing Cluster Access Using kubeconfig Files](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig)
- [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac)
- [Determine the Request Verb](https://kubernetes.io/docs/reference/access-authn-authz/authorization/#determine-the-request-verb)
- [Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account)

---

## <a name="kubernetes-volumes">Хранение данных в Kubernetes: Volumes, Storages, Statefull-приложения</a>

### ДЗ // Volumes, StorageClass, PV, PVC

#### Выполнение

1. Активированы дополнительные [плагины](https://minikube.sigs.k8s.io/docs/tutorials/volume_snapshots_and_csi/) для minikube'а
  
```bash
# minikube start --node=3 --network-plugin=cni --enable-default-cni --container-runtime=containerd --bootstrapper=kubeadm

$ minikube addons enable volumesnapshots
...
  The 'volumesnapshots' addon is enabled

$ minikube addons enable csi-hostpath-driver
...
  The 'csi-hostpath-driver' addon is enabled
```

1. Создан манифест `kubernetes-volumes/storageClass.yaml` с именем *homework-storage* с provisioner: *hostPath* и reclaimPolicy: *Retain*

```bash
$ kubectl apply -f storageClass.yaml
storageclass.storage.k8s.io/homework-storage created

$ kubectl get sc
NAME                 PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
csi-hostpath-sc      hostpath.csi.k8s.io        Delete          Immediate              false                  6m29s
homework-storage     k8s.io/minikube-hostpath   Retain          WaitForFirstConsumer   true                   11s
standard (default)   k8s.io/minikube-hostpath   Delete          Immediate              false                  17h

$ kubectl describe storageClasses/homework-storage
Name:            homework-storage
IsDefaultClass:  No
Annotations:     kubectl.kubernetes.io/last-applied-configuration={"allowVolumeExpansion":true,"apiVersion":"storage.k8s.io/v1","kind":"StorageClass","metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"},"labels":{"addonmanager.kubernetes.io/mode":"EnsureExists","name":"homework"},"name":"homework-storage"},"mountOptions":["discard"],"parameters":{"guaranteedReadWriteLatency":"true"},"provisioner":"k8s.io/minikube-hostpath","reclaimPolicy":"Retain","volumeBindingMode":"WaitForFirstConsumer"}
,storageclass.kubernetes.io/is-default-class=false
Provisioner:           k8s.io/minikube-hostpath
Parameters:            guaranteedReadWriteLatency=true
AllowVolumeExpansion:  True
MountOptions:
  discard
ReclaimPolicy:      Retain
VolumeBindingMode:  WaitForFirstConsumer
Events:             <none>
```

2. Созданы манифесты `kubernetes-volumes/pvc.yaml` и `kubernetes-volumes/pv.yaml`, описывающие PersistentVolumeClaim, PersistentVolume с привязкой к `hostPath` в minikube'е, которые используют хранилище с storageClass из 1-го пункта

```bash
$ kubectl apply -f pv.yaml -f pvc.yaml

$ kubectl -n homework get pvc,pv
NAME                                 STATUS   VOLUME        CAPACITY   ACCESS MODES   STORAGECLASS       AGE
persistentvolumeclaim/homework-pvc   Bound    homework-pv   200Mi      RWO            homework-storage   3h33m

NAME                           CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                   STORAGECLASS       REASON   AGE
persistentvolume/homework-pv   200Mi      RWO            Retain           Bound    homework/homework-pvc   homework-storage            3h33m
```

3. Создан манифест `kubernetes-volumes/cm.yaml` для объекта типа configMap с *nginx-config-file*, описывающий произвольный набор пар ключ-значение

```bash
$ kubectl -n homework get configmaps/nginx-config-file -o yaml
```
```yaml
apiVersion: v1
data:
  file: property=value
kind: ConfigMap
...
```

4. В манифест `kubernetes-volumes/deployment.yaml` внесены изменения в спецификацию volume на pvc - *homework-pvc*

```bash
$ kubectl -n homework describe deployments.apps/web
```
```yaml
    Mounts:
...
      /homework from homework-volume (rw)
...
  Volumes:
   homework-volume:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  homework-pvc
```

#### Задание с *

1. В манифесте `deployment.yaml` добавлено подключение configMap как volume к основному контейнеру пода в директорию /homework/conf, где можно обратиться к /conf/file

```yaml
    Mounts:
...
      /homework/conf/file from nginx-config-file (rw)
  Volumes:
...
   nginx-config-file:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      nginx-config-file
```

```bash
$ curl -I http://10.110.146.145:8888/conf/file
HTTP/1.1 301 Moved Permanently
Server: nginx/1.14.2
Date: Sat, 03 Feb 2024 21:28:46 GMT
Content-Type: text/html
Content-Length: 185
Location: http://10.110.146.145:8000/conf/file/
Connection: keep-alive

$ curl http://10.110.146.145:8888/conf/file/..data/file
property=value

```

2. Внесены изменения в манифест `pvc.yaml` так, чтобы в нем запрашивалось хранилище созданного storageClass'а, см. пункт 2.

Для Retain-политики выполнялась проверка с удалением *Deployment/web*, см. изображение ниже. Как видим, файл не удаляется. Здесь спецификация *preStop* с удалением файла index.html была "закомментирована"

![](images/Screenshot_20240203_235647.png)

#### Список документации:

- [Установка Kubernetes с помощью Minikube](https://kubernetes.io/ru/docs/setup/learning-environment/minikube/)
- [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
- [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)
- [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Configure a Pod to Use a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)
- [Learning Kubernetes: persistent storage with Minikube](https://martincarstenbach.wordpress.com/2019/06/07/learning-kubernetes-persistent-storage-with-minikube/)
- [Configure a Pod to Use a PersistentVolume for Storage](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/)

---

## <a name="kubernetes-networks">Сетевая подсистема и сущности Kubernetes</a>

### ДЗ // Сетевое взаимодействие Pod, сервисы

#### Выполнение

1. Скопированы манифесты `kubernetes-networks/namespace.yaml`, `kubernetes-networks/configmap.yaml` и `kubernetes-networks/desployment.yaml`
2. Внесены измения в манифест `deployment.yaml`, чтобы выполнялась проверка по **httpGet**, вызывающую URL /index.html (далее /homepage/index.html)
3. Cоздан манифест `service.yaml`, который описывает сервис типа ClusterIP, который будет направляет трафик на поды *web*, управляемые *Deployment* сервисом
4. Установлен в кластер *minikube* ingress-контроллер nginx

> порты выбраны специально, чтобы наблюдать проходжение запроса

```bash
$ minikube start --nodes=4 
# https://minikube.sigs.k8s.io/docs/tutorials/multi_node/ 
# for i in 3; do minikube node add --delete-on-failure=true --worker=true; done

$ kubectl label nodes --overwrite=true minikube-m02 minikube-m03 workload=production

$ kubectl apply -f namespace.yaml -f configmap.yaml -f deployment.yaml -f service.yaml
...
service/ui configured

$ kubectl -n homework describe service/ui
Name:              ui
Namespace:         homework
Labels:            app=ui
                   component=homework
Annotations:       <none>
Selector:          app=nginx,component=homework
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.110.146.145
IPs:               10.110.146.145
Port:              <unset>  8888/TCP
TargetPort:        8000/TCP
Endpoints:         10.244.1.2:8000,10.244.1.3:8000,10.244.2.2:8000
Session Affinity:  None
Events:            <none>

$ kubectl -n homework get svc
NAME   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
ui     ClusterIP   10.110.146.145   <none>        8888/TCP   28m

```

Тестирование:

```bash
$ kubectl port-forward -n homework services/ui 8888:8888
```

![img](images/Screenshot_20240202_130355.png)

5. Создан манифест `ingress.yaml`, в котором описывается описан объект типа ingress, направляющий все http запросы к хосту homework.otus на ранее созданный сервис.

```bash
$ minikube addons enable ingress
💡  ingress is an addon maintained by Kubernetes. For any concerns contact minikube on GitHub.
You can view the list of minikube maintainers at: https://github.com/kubernetes/minikube/blob/master/OWNERS
    ▪ Using image registry.k8s.io/ingress-nginx/controller:v1.9.4
    ▪ Using image registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20231011-8b53cabe0
    ▪ Using image registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20231011-8b53cabe0
🔎  Verifying ingress addon...
🌟  The 'ingress' addon is enabled

$ kubectl apply -f ingress.yaml
ingress.networking.k8s.io/ui created

$ kubectl -n homework get ingress
NAME   CLASS   HOSTS           ADDRESS        PORTS   AGE
ui     nginx   homework.otus   192.168.49.2   80      2m36s

$ minikube tunnel
Status:
        machine: minikube
        pid: 1200117
        route: 10.96.0.0/12 -> 192.168.49.2
        minikube: Running
...
```

Проверка:

```bash
$ curl http://homework.otus/
<!DOCTYPE html><html lang="en"><head><title>Hello, World!</title></head><body><h1>Hello, World!</h1><h2>Today is Fri Feb  2 19:31:59 UTC 2024 on web-f7ffc5798-jptjj</h2></body></html>
```

#### Задание со *

Для выполнения задания со \*, где выполняется обращение к *http://homework.otus/index.html*, ingress перенаправляет на *http://homework.otus/homepage* внесены изменения в манифесты, так что запрашиваемая страница доступна по новому адресу service/ClusterIP *http://10.110.146.145:8888/homepage/*

Для проверки при обращении к http://homework.otus/index.html выдается ошибка:

![](images/Screenshot_20240203_011615.png)

Ingress nginx вносит изменения и страница доступна:

![](images/Screenshot_20240203_011445.png)

где адрес *192.168.49.2 homework.otus* прописан локальнов в `/etc/hosts`

```bash
$ kubectl -n homework logs deployments/web -f
Found 3 pods, using pod/web-78c87f6c87-fjbbh
...
10.244.0.5 - - [02/Feb/2024:22:10:40 +0000] "GET /homepage/ HTTP/1.1" 200 180 "-" "curl/8.5.0" "192.168.49.1"
10.244.0.5 - - [02/Feb/2024:22:11:50 +0000] "GET /homepage/index.html HTTP/1.1" 200 180 "-" "curl/8.5.0" "192.168.49.1"
10.244.0.5 - - [02/Feb/2024:22:12:04 +0000] "GET /homepage/index.html HTTP/1.1" 200 180 "-" "curl/8.5.0" "192.168.49.1"
```

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
