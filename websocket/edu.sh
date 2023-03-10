#!/bin/bash
# Proxy For Edukasi & Imclass
# ==========================================

# Getting Proxy Template
wget -q -O /usr/local/bin/ssh-ws https://raw.githubusercontent.com/kenDevXD/narassh/main/websocket/websocket.py
chmod +x /usr/local/bin/ssh-ws

# Installing Service
cat > /etc/systemd/system/ssh-ws@.service << END
[Unit]
Description=KENN
Documentation=KENN
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/ssh-ws %i
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ssh-ws@80
systemctl enable ssh-ws@8080
systemctl restart ssh-ws@80
systemctl restart ssh-ws@8080
