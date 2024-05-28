# Local Variables
locals {
  project     = "playpen-e3bd38"
  region      = "europe-central2"
  zone        = "europe-central2-a"
  credentials = "keys.json" //creds change from Service Account
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
    device_name = "teradatavm1"
    initialize_params {
      image = "https://www.googleapis.com/compute/beta/projects/debian-cloud/global/images/debian-12-bookworm-v20240415" 
      # image needs to be updated to ubuntu
      # image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240519"
      size  = 100

      type  = "pd-balanced"
    }
    mode = "READ_WRITE"

  }
  labels = {
    goog-ec-src = "vm_add-tf"
  }
  machine_type = "n2-standard-2"
  metadata = {
    # Change the SSH Keys , Generate and add Public Key here
    ssh-keys       = "terakey:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnxCEnzViMKv16Sv6UbTCGQut+l2MlqvYagB6bYRAxC mohan.kanni@lloydsbanking.com"
  }
  name = "teradatavm1"
  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
        // Need to Change as per Playpen

    network = "https://www.googleapis.com/compute/v1/projects/playpen-e3bd38/global/networks/eu-comp1" 
    stack_type         = "IPV4_ONLY"
        // Need to Change as per Playpen

    subnetwork         = "https://www.googleapis.com/compute/v1/projects/playpen-e3bd38/regions/europe-central2/subnetworks/eu-comp1"  // Need to Change
    subnetwork_project = "playpen-e3bd38"
  }
  project = local.project
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    provisioning_model  = "STANDARD"
  }
  advanced_machine_features {
    enable_nested_virtualization = true
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
  zone = local.zone
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
      user        = "terakey" // Linux User which is used for SSH Login and Files get copied to same path
      private_key = file("id_ed25519") // Generate SSH and add Private Key Path
      host = google_compute_instance.teradatavm.network_interface.0.access_config.0.nat_ip
    }
  provisioner "remote-exec" {
    inline = [
      "sudo sh /home/terakey/install.sh",
    ]

  }
}
