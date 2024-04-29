output "cluster_external_v4_endpoint" {
  value = data.yandex_kubernetes_cluster.this.master.0.external_v4_endpoint
}

output "argocd_version" {
  value = helm_release.this.metadata[0].app_version
}

output "helm_revision" {
  value = helm_release.this.metadata[0].revision
}

output "chart_version" {
  value = helm_release.this.metadata[0].version
}

