#!/bin/bash
#install backup
curl https://rclone.org/install.sh | bash
printf "q\n" | rclone config
wget -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/kenDevXD/narassh/main/backup/rclone.conf"
git clone  https://github.com/magnific0/wondershaper.git
cd wondershaper
make install
cd
rm -rf wondershaper
echo > /home/limit
apt install msmtp-mta ca-certificates bsd-mailx -y
cat << EOF > /etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
account default
host mail.naravpn.com
port 587
auth on
user admin@naravpn.com
from admin@naravpn.com
password Peciajaib752##
logfile ~/.msmtp.log
EOF

chown -R www-data:www-data /etc/msmtprc
cd /usr/local/sbin
wget -O autobackup "https://raw.githubusercontent.com/kenDevXD/narassh/main/backup/autobackup.sh"
wget -O backup "https://raw.githubusercontent.com/kenDevXD/narassh/main/backup/backup.sh"
wget -O restore "https://raw.githubusercontent.com/kenDevXD/narassh/main/backup/restore.sh"
chmod +x autobackup
chmod +x backup
chmod +x restore
