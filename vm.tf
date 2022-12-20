resource "proxmox_vm_qemu" "dev" {
  name        = var.hostname
  target_node = var.TARGET_NODES[0]
  vmid        = "8888"
  clone       = var.template
  agent       = 1
  os_type     = "cloud-init"
  cores       = var.cpu_count
  sockets     = 1
  cpu         = "host"
  memory      = var.memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  depends_on  = [null_resource.git_clone, local_file.ipv4]

  disk {
    slot     = 0
    size     = var.disk_size
    type     = "scsi"
    storage  = var.disk_storage
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  network {
    model  = "virtio"
    bridge = "vmbr1"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=${var.ipv4}/24,gw=${var.ipv4_gateway}"
  ipconfig1 = "ip=${var.ipv4_data}/24"

  sshkeys = <<EOF
  ${file(var.public_key_file)}
  EOF

  connection {
    type        = "ssh"
    user        = var.user
    private_key = file(var.private_key_file)
    host        = var.ipv4
  }

  # This helps to wait and test connection before executing local commands.
  provisioner "remote-exec" {
    inline = [
      "date",
      "sleep 60"
    ]
  }

  # Remove Existing ssh fingerprint
  provisioner "local-exec" {
    command = "ssh-keygen -f ~/.ssh/known_hosts -R `cat ./.dots/ipv4`"
  }
}

resource "null_resource" "ansible" {
  depends_on = [null_resource.git_clone, local_file.ansible_hosts, local_file.id_rsa, proxmox_vm_qemu.dev]
  # Run Ansible Playbook
  provisioner "local-exec" {
    command = "cd ./.dots && ansible-playbook -i hosts ansible/dev.yml"
  }
}

resource "null_resource" "git_clone" {
  # Clone Dots Ansible Project
  provisioner "local-exec" {
    command = "git clone ${var.dots_ansible_repo} .dots/ansible"
  }
}

resource "null_resource" "cleanup" {
  depends_on = [
    local_file.ipv4,
    null_resource.git_clone
  ]
  # Cleanup on destroy
  provisioner "local-exec" {
    when = destroy
    command = "bash -x scripts/cleanup.sh"
  }
}