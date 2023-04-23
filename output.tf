# generate files for Ansible
resource "local_file" "ansible_hosts" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      dev  = var.ipv4
      user = var.user
    }
  )
  filename = "./.dots/hosts"
}

resource "local_file" "ipv4" {
# Required while destroying the VM
  content = templatefile("${path.module}/templates/ipv4.tpl",
    {
      ipv4  = var.ipv4
    }
  )
  filename = "./.dots/ipv4"
}

resource "local_file" "host_vars" {
  # Ansible Variables
  content = templatefile("${path.module}/templates/host_vars.tpl",
    {
      vars = {
        "host_username" = var.user,
        "authorized_keys" = file(var.public_key_file)
      }
    }
  )
  filename = "./.dots/host_vars.yaml"
}