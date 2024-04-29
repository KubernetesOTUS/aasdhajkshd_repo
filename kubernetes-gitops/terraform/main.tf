locals {
  chart_values = {
    # echo 'yamldecode(file("values.yaml"))' | terraform console
    "global" = {
      "nodeSelector" = {
        "workload" = "infra"
      }
      "tolerations" = [
        {
          "effect"   = "NoSchedule"
          "key"      = "node-role"
          "operator" = "Exists"
        },
      ]
    }
  }
}

data "yandex_kubernetes_cluster" "this" {
  folder_id = var.folder_id
  name      = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.yandex_kubernetes_cluster.this.master[0].external_v4_endpoint
    cluster_ca_certificate = data.yandex_kubernetes_cluster.this.master[0].cluster_ca_certificate
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["k8s", "create-token"]
      command     = "yc"
    }
  }
}

resource "helm_release" "this" {
  namespace        = "argocd"
  create_namespace = true
  name             = "argocd"
  repository       = "oci://cr.yandex/yc-marketplace/yandex-cloud/argo/chart"
  chart            = "argo-cd"
  wait             = true
  version          = var.chart_version
  lint             = false
  atomic           = true
  cleanup_on_fail  = true
  verify           = false
  max_history      = 3
  timeout          = 360

  depends_on = [
    data.yandex_kubernetes_cluster.this
  ]

  values = [
    # file("${path.module}/../argo-cd/values.yaml")
    # yamlencode(local.chart_values)
  ]

  set {
    name  = "global.nodeSelector.workload"
    value = "argocd"
  }
  set {
    name  = "global.tolerations[0].key"
    value = "node-role"
  }
  set {
    name  = "global.tolerations[0].value"
    value = "infra"
  }
  set {
    name  = "global.tolerations[0].operator"
    value = "Equal"
  }
  set {
    name  = "global.tolerations[0].effect"
    value = "NoSchedule"
  }
}
