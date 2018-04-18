#!/bin/bash

# User data
${user_data}

# Dependencies
apt-get install -y curl unzip

NOMAD_DOWNLOAD=https://releases.hashicorp.com/nomad/${nomad_version}/nomad_${nomad_version}_linux_amd64.zip

# Fetch nomad
curl -L $NOMAD_DOWNLOAD > nomad.zip

# Mount disk
echo ";" | sfdisk /dev/sdc
mkfs -t ext4 /dev/sdc1
mkdir ${nomad_dir}
mount /dev/sdc1 ${nomad_dir}
chown -R ubuntu ${nomad_dir}

# Install nomad
unzip nomad.zip -d /usr/local/bin
chmod 0755 /usr/local/bin/nomad
chown root:root /usr/local/bin/nomad

# Configuring nomad
mkdir -p "${nomad_config_dir}"
chmod 0755 ${nomad_config_dir}

tee /etc/nomad.d/config.json > /dev/null <<EOF

datacenter = "${datacenter}"
data_dir   = "${nomad_dir}"

log_level = "DEBUG"

consul {
    address = "127.0.0.1:8500"

    server_service_name = "${server_service_name}"
    client_service_name = "${client_service_name}"
    
    auto_advertise = true

    server_auto_join = true
    client_auto_join = true
}

client {
    enabled = ${client}
}

server {
    enabled             = ${server}
    bootstrap_expect    = ${bootstrap}
}

EOF

tee /etc/systemd/system/nomad.service > /dev/null <<"EOF"
[Unit]
Description = "Nomad"

[Service]
KillSignal=INT
ExecStart=/usr/local/bin/nomad agent -config="/etc/nomad.d"
Restart=always
ExecStopPost=sleep 5
EOF

# Start nomad
systemctl enable nomad
systemctl start nomad
