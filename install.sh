#!/bin/bash

# Variablen
NODE_EXPORTER_VERSION="1.6.1"
DOWNLOAD_URL="https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VERSION/node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz"
INSTALL_DIR="/usr/local/bin"
SERVICE_FILE="/etc/systemd/system/node_exporter.service"

# Update und Installieren von Abhängigkeiten
echo "Aktualisiere Paketliste und installiere Abhängigkeiten..."
sudo apt-get update
sudo apt-get install -y wget tar

# Herunterladen und Entpacken des Node Exporters
echo "Lade Node Exporter herunter..."
wget $DOWNLOAD_URL -O /tmp/node_exporter.tar.gz

echo "Entpacke Node Exporter..."
tar -xzf /tmp/node_exporter.tar.gz -C /tmp

# Verschieben der Binärdatei in das Installationsverzeichnis
echo "Installiere Node Exporter..."
sudo mv /tmp/node_exporter-$NODE_EXPORTER_VERSION.linux-amd64/node_exporter $INSTALL_DIR

# Bereinigung der temporären Dateien
rm -rf /tmp/node_exporter*

# Erstellen der Systemd-Dienstdatei
echo "Erstelle Systemd-Dienstdatei..."
cat <<EOL | sudo tee $SERVICE_FILE
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=nobody
ExecStart=$INSTALL_DIR/node_exporter

[Install]
WantedBy=default.target
EOL

# Dienst neu laden und starten
echo "Starte Node Exporter Dienst..."
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

echo "Node Exporter Installation abgeschlossen!"