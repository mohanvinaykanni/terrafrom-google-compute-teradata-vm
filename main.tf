# Local Variables
locals {
  project     = "playpen-e3bd38"
  region      = "europe-central2"
  zone        = "europe-central2-c"
  credentials = "keys.json"
}

# Cloud Provider
provider "google" {
  project     = local.project
  region      = local.region
  zone        = local.zone
  credentials = local.credentials
}
resource "google_compute_instance" "teradatavm" {
  boot_disk {
    auto_delete = true
    device_name = "teradatavm"
    initialize_params {
      image = "https://www.googleapis.com/compute/beta/projects/debian-cloud/global/images/debian-12-bookworm-v20240415"
      size  = 100
      type  = "pd-balanced"
    }
    mode = "READ_WRITE"

  }
  labels = {
    # goog-ec-src = "vm_add-tf"
  }
  machine_type = "e2-medium"
  metadata = {
    ssh-keys       = "terakey:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnxCEnzViMKv16Sv6UbTCGQut+l2MlqvYagB6bYRAxC mohan.kanni@lloydsbanking.com"
    # startup-script = "sud"
  }
  name = "teradatavm"
  network_interface {
    access_config {

      network_tier = "PREMIUM"
    }
    network = "https://www.googleapis.com/compute/v1/projects/playpen-e3bd38/global/networks/eu-comp1"
    # network_ip         = "10.186.0.56"
    stack_type         = "IPV4_ONLY"
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/playpen-e3bd38/regions/europe-central2/subnetworks/eu-comp1"
    subnetwork_project = "playpen-e3bd38"
  }
  project = "playpen-e3bd38"
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    provisioning_model  = "STANDARD"
  }
  service_account {
    email  = "terraform@playpen-e3bd38.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }
  tags = ["http-server", "https-server", "lb-health-check"]
  zone = "europe-central2-c"
  provisioner "file" {
    source      = "VantageExpress17.20_Sles12_20230220064202.7z"
    destination = "ve.7z"
  }

    provisioner "file" {
    source      = "install.sh"
    destination = "install.sh"
    
  }
    connection {
      type        = "ssh"
      user        = "terakey"
      private_key = file("id_ed25519")
      host = google_compute_instance.teradatavm.network_interface.0.access_config.0.nat_ip
    }
  provisioner "remote-exec" {
    inline = [
      "sudo sh /home/terakey/install.sh",
      # "echo download start",
      # "echo end",
      # "sudo apt update && apt-get install p7zip-full p7zip-rar virtualbox -y"
    ]

  }
}
