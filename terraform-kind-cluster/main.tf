terraform {
  required_version = ">= 1.10.0"

  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.7.0"
    }
  }
}

resource "kind_cluster" "cluster" {
  name            = local.cluster_name
  node_image      = "kindest/node:v${local.cluster_version}"
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    # Control plane node configuration
    node {
      role = "control-plane"

      kubeadm_config_patches = [
        <<EOT
kind: InitConfiguration
nodeRegistration:
  kubeletExtraArgs:
    node-labels: "ingress-ready=true"
EOT
      ]

      extra_port_mappings {
        container_port = 30001
        host_port      = 30001
      }
      extra_port_mappings {
        container_port = 30002
        host_port      = 30002
      }
      extra_port_mappings {
        container_port = 30003
        host_port      = 30003
      }
      extra_port_mappings {
        container_port = 30004
        host_port      = 30004
      }
      extra_port_mappings {
        container_port = 30005
        host_port      = 30005
      }
      extra_port_mappings {
        container_port = 30006
        host_port      = 30006
      }
      extra_port_mappings {
        container_port = 30007
        host_port      = 30007
      }
      extra_port_mappings {
        container_port = 30008
        host_port      = 30008
      }
      extra_port_mappings {
        container_port = 30009
        host_port      = 30009
      }
      extra_port_mappings {
        container_port = 80
        host_port      = 80
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
        protocol       = "TCP"
        listen_address = "0.0.0.0"
      }
    }

    # Worker node configuration
    node {
      role = "worker"

      kubeadm_config_patches = [
        <<EOT
kind: JoinConfiguration
nodeRegistration:
  kubeletExtraArgs:
    node-labels: "ingress-ready=true"
EOT
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 8080
        listen_address = "0.0.0.0"
      }
    }
  }
}

locals {
  cluster_name    = "cluster1"
  cluster_version = "1.31.0"
}

output "cluster_endpoint" {
  value = kind_cluster.cluster.endpoint
}

