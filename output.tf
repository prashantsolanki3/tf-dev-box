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

resource "local_file" "id_rsa" {
  content = templatefile("${path.module}/templates/id_rsa.tpl",
    {
      public_key  = file(var.public_key_file)
    }
  )
  filename = "./.dots/id_rsa.pub"
}

resource "local_file" "ipv4" {
  content = templatefile("${path.module}/templates/ipv4.tpl",
    {
      ipv4  = var.ipv4
    }
  )
  filename = "./.dots/ipv4"
}