[all]
%{ for index, ip in master_ips ~}
${master_ids[index]} ansible_host=${ip}
%{ endfor ~}
%{ for index, ip in worker_ips ~}
${worker_ids[index]} ansible_host=${ip}
%{ endfor ~}

[kube_control_plane]
%{ for index, ip in master_ips ~}
${master_ids[index]} ansible_host=${ip}
%{ endfor ~}

[etcd]
%{ for index, ip in master_ips ~}
${master_ids[index]} ansible_host=${ip}
%{ endfor ~}

[kube_node]
%{ for index, ip in worker_ips ~}
${worker_ids[index]} ansible_host=${ip}
%{ endfor ~}

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr
