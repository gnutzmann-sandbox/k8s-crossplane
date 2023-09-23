terraform {
  required_version = "1.1.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
    #kubernetes = {
    #  source  = "hashicorp/kubernetes"
    #  version = "2.11.0"
    #}
  }
}

# provider "kubernetes" {
#  config_path = "~/.kube/config"
#}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" # 
  }
}

resource "helm_release" "crossplane" {
  name             = "crossplane"
  repository       = "https://charts.crossplane.io/stable"
  chart            = "crossplane"
  version          = "1.13.2"
  namespace        = "crossplane-system"
  create_namespace = true
  set {
    name  = "replicas"
    value = "2"
  }

  set {
    name  = "rbacManager.replicas"
    value = "2"
  }

  set {
    name  = "provider.packages"
    value = "{xpkg.upbound.io/upbound/provider-terraform:v0.10.0}"
  }

  set {
    name  = "rbacManager.managementPolicy"
    value = "All"
  }

  set {
    name  = "customAnnotations.sidecar\\.istio\\.io/inject"
    value = "false"
    type  = "string"
  }

}
