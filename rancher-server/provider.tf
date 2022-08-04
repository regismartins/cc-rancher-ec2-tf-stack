## Providers

terraform {
  required_providers {
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "4.18.0"
    # }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    # tls = {
    #   source  = "hashicorp/tls"
    #   version = "3.4.0"
    # }
    ssh = {
      source  = "loafoe/ssh"
      version = "2.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.24.0"
    }
  }
}

provider "aws" {
  region = module.common.aws_region
  default_tags {
    tags = {
      Environment = "rancher-workshop"
      Owner       = module.common.owner
      Terraform   = "true"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = local_file.kube_config_server_yaml.filename
  }
}

# Rancher2 
provider "rancher2" {
  api_url   = "https://${data.terraform_remote_state.aws_infra.outputs.rancher_url}"
  token_key = rancher2_bootstrap.admin.token
}

# Rancher2 bootstrapping provider
provider "rancher2" {
  alias = "bootstrap"

  api_url   = "https://${data.terraform_remote_state.aws_infra.outputs.rancher_url}"
  insecure  = true
  bootstrap = true
}

# Rancher2 administration provider
provider "rancher2" {
  alias = "admin"

  api_url   = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
  insecure  = true
}