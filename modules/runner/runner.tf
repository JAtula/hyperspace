# resource google_compute_network gitlab_network in gitlab.tf

provider "google" {
    credentials = "${file("${var.auth_file}")}"
    project = "${var.project}"
    region = "${var.region}"
}

data "template_file" "runner_host" {
    template = "$${runner_host == "GENERATE" ? generated_host : runner_host}"
    vars {
      runner_host = "${var.runner_host}"
      generated_host = "http${var.ssl_certificate != "/dev/null" ? "s" : ""}://${var.dns_name}"
    }
}

resource "google_compute_instance" "gitlab-ci-runner" {
    count = "${var.runner_count}"
    name = "${var.prefix}ci-runner-${count.index}"
    machine_type = "${var.runner_machine_type}"
    zone = "${var.zone}"

    tags = ["gitlab-ci-runner"]

    network_interface {
        network = "${var.network}"
        access_config {
          // Ephemeral IP
        }
    }

    metadata {
        sshKeys = "ubuntu:${file("${var.ssh_key}.pub")}"
    }

    connection {
        type = "ssh"
        user = "ubuntu"
        agent = "false"
        private_key = "${file("${var.ssh_key}")}"
    }

    boot_disk {
        initialize_params {
            image = "${var.image}"
            size = "${var.runner_disk_size}"            
        }
    }

    provisioner "file" {
        source = "${path.module}/bootstrap_runner"
        destination = "/tmp/bootstrap_runner"
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${var.gitlab_ce_address} ${var.dns_name} | sudo tee -a /etc/hosts",
            "sudo mkdir -p /etc/gitlab-runner/certs",
            "sudo chmod +x /tmp/bootstrap_runner",
            "sudo /tmp/bootstrap_runner ${google_compute_instance.gitlab-ci-runner.name} ${data.template_file.runner_host.rendered} ${var.runner_token} ${var.runner_image} ${var.dns_name}"
        ]
    }

    provisioner "remote-exec" {
      when = "destroy"
      inline = [
        "sudo gitlab-ci-multi-runner unregister --name ${google_compute_instance.gitlab-ci-runner.name}"
      ]

    }
}

output "runner_disk_size" {
    value = "${var.runner_disk_size}"
}

output "runner_image" {
    value = "${var.runner_image}"
}

output "runner_host" {
    value = "${data.template_file.runner_host.rendered}"
}
