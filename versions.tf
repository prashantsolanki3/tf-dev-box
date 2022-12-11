terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.10"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
  }
}
