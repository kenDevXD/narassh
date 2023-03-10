#!/bin/bash
# Scripter Reza Adrian
# ==================================================

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Indonesia
locality=Jakarta
organization=AIXXY.ME
organizationalunit=AIXXY.CODES
commonname=KENN
email=admin@aixxy.codes

# simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/password"
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# install wget and curl
apt -y install wget curl
apt -y install net-tools

# Install Requirements Tools
apt-get install figlet -y
gem install lolcat
apt install python -y
apt install make -y
apt install cmake -y
apt install coreutils -y
apt install rsyslog -y
apt install net-tools -y
apt install zip -y
apt install unzip -y
apt install nano -y
apt install sed -y
apt install gnupg -y
apt install gnupg1 -y
apt install bc -y
apt install jq -y
apt install apt-transport-https -y
apt install build-essential -y
apt install dirmngr -y
apt install libxml-parser-perl -y
apt install neofetch -y
apt install git -y
apt install lsof -y
apt install libsqlite3-dev -y
apt install libz-dev -y
apt install gcc -y
apt install g++ -y
apt install libreadline-dev -y
apt install zlib1g-dev -y
apt install libssl-dev -y
apt install libssl1.0-dev -y
apt install dos2unix -y
apt install toilet -y
apt install cpulimit -y

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/vps.conf"
/etc/init.d/nginx restart

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://github.com/potatonc/ScriptAutoInstallPotato/raw/main/badvpn/badvpn-udpgw"
chmod +x /usr/bin/badvpn-udpgw

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 2253' /etc/ssh/sshd_config
echo "Port 22" >> /etc/ssh/sshd_config
echo "Port 42" >> /etc/ssh/sshd_config
/etc/init.d/ssh restart

# install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 1153"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install squid
#cd
#apt -y install squid3
#wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/squid3.conf"
#sed -i $MYIP2 /etc/squid/squid.conf

# Install SSLH
apt -y install sslh
rm -f /etc/default/sslh

# Settings SSLH
cat > /etc/default/sslh <<-END
# Default options for sslh initscript
# sourced by /etc/init.d/sslh

# Disabled by default, to force yourself
# to read the configuration:
# - /usr/share/doc/sslh/README.Debian (quick start)
# - /usr/share/doc/sslh/README, at "Configuration" section
# - sslh(8) via "man sslh" for more configuration details.
# Once configuration ready, you *must* set RUN to yes here
# and try to start sslh (standalone mode only)

RUN=yes

# binary to use: forked (sslh) or single-thread (sslh-select) version
# systemd users: don't forget to modify /lib/systemd/system/sslh.service
DAEMON=/usr/sbin/sslh

DAEMON_OPTS="--user sslh --listen 0.0.0.0:443 --ssl 127.0.0.1:777 --ssh 127.0.0.1:22 --http 127.0.0.1:80 --pidfile /var/run/sslh/sslh.pid -n"
END

# Restart Service SSLH
service sslh restart
systemctl restart sslh
/etc/init.d/sslh restart
/etc/init.d/sslh status
/etc/init.d/sslh restart

# setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

# install stunnel 5 
cd /root/
wget -q -O stunnel5.zip "https://raw.githubusercontent.com/kenDevXD/narassh/main/stunnel5/stunnel5.zip"
unzip -o stunnel5.zip
cd /root/stunnel
chmod +x configure
./configure
make
make install
cd /root
rm -r -f stunnel
rm -f stunnel5.zip
mkdir -p /etc/stunnel5
chmod 644 /etc/stunnel5

# Download Config Stunnel5
cat > /etc/stunnel5/stunnel5.conf <<-END
cert = /etc/stunnel5/stunnel5.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 445
connect = 127.0.0.1:109

[openssh]
accept = 777
connect = 127.0.0.1:443

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel5/stunnel5.pem

# Service Stunnel5 systemctl restart stunnel5
cat > /etc/systemd/system/stunnel5.service << END
[Unit]
Description=Stunnel5 Service
Documentation=https://stunnel.org
Documentation=https://github.com/sshsedang
After=syslog.target network-online.target

[Service]
ExecStart=/usr/local/bin/stunnel5 /etc/stunnel5/stunnel5.conf
Type=forking

[Install]
WantedBy=multi-user.target
END

# Service Stunnel5 /etc/init.d/stunnel5
wget -q -O /etc/init.d/stunnel5 "https://raw.githubusercontent.com/kenDevXD/narassh/main/stunnel5/stunnel5.init"

# Ubah Izin Akses
chmod 600 /etc/stunnel5/stunnel5.pem
chmod +x /etc/init.d/stunnel5
cp /usr/local/bin/stunnel /usr/local/bin/stunnel5

# Remove File
rm -r -f /usr/local/share/doc/stunnel/
rm -r -f /usr/local/etc/stunnel/
rm -f /usr/local/bin/stunnel
rm -f /usr/local/bin/stunnel3
rm -f /usr/local/bin/stunnel4

# Restart Stunnel 5
systemctl stop stunnel5
systemctl enable stunnel5
systemctl start stunnel5
systemctl restart stunnel5
/etc/init.d/stunnel5 restart
/etc/init.d/stunnel5 status
/etc/init.d/stunnel5 restart

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear

# banner /etc/issue.net
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# Ganti Banner
wget -O /etc/issue.net "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/issue.net"

# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# download script
cd /usr/bin

wget -O hominfo "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/hominfo.sh"
wget -O addhost "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/addhost.sh"
wget -O about "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/about.sh"
wget -O menu "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/menu.sh"
wget -O addssh "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/addssh.sh"
wget -O delssh "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/delssh.sh"
wget -O member "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/member.sh"
wget -O delexp "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/delexp.sh"
wget -O cekssh "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/cekssh.sh"
wget -O trialssh "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/trialssh.sh"
wget -O restart "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/info.sh"
wget -O ram "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/ram.sh"
wget -O renewssh "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/renewssh.sh"
wget -O autokill "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/autokill.sh"
wget -O ceklim "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/ceklim.sh"
wget -O tendang "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/tendang.sh"
wget -O clearlog "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/clearlog.sh"
wget -O changeport "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/changeport.sh"
wget -O webmin "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/webmin.sh"
wget -O xp "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/xp.sh"
wget -O tessh "https://raw.githubusercontent.com/kenDevXD/narassh/main/tessh.sh"
wget -O wss "https://raw.githubusercontent.com/kenDevXD/narassh/main/wss.sh"
wget -O swapkvm "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/swapkvm.sh"
wget -O portsshnontls "https://raw.githubusercontent.com/kenDevXD/narassh/main/websocket/portsshnontls.sh"
wget -O portsshws "https://raw.githubusercontent.com/kenDevXD/narassh/main/websocket/portsshws.sh"
wget -O running "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/running.sh"
wget -O sslh-fix "https://raw.githubusercontent.com/kenDevXD/narassh/main/sslh/sslh-fix"
wget -O limit-bad "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/limit-bad.sh"
wget -O fixbad "https://raw.githubusercontent.com/kenDevXD/narassh/main/ssh/fixbad"


chmod +x hominfo && sed -i -e 's/\r$//' hominfo
chmod +x running && sed -i -e 's/\r$//' running
chmod +x sslh-fix && sed -i -e 's/\r$//' sslh-fix
chmod +x portsshnontls && sed -i -e 's/\r$//' portsshnontls
chmod +x portsshws && sed -i -e 's/\r$//' portsshws
chmod +x addhost && sed -i -e 's/\r$//' addhost
chmod +x menu && sed -i -e 's/\r$//' menu
chmod +x trial-menu && sed -i -e 's/\r$//' trial-menu
chmod +x addssh && sed -i -e 's/\r$//' addssh
chmod +x trial-ssh && sed -i -e 's/\r$//' trial-ssh
chmod +x trialssh && sed -i -e 's/\r$//' trialssh
chmod +x delssh && sed -i -e 's/\r$//' delssh
chmod +x member && sed -i -e 's/\r$//' member
chmod +x delexp && sed -i -e 's/\r$//' delexp
chmod +x cekssh && sed -i -e 's/\r$//' cekssh
chmod +x restart && sed -i -e 's/\r$//' restart
chmod +x speedtest
chmod +x limit-bad
chmod +x fixbad
chmod +x info
chmod +x about
chmod +x autokill && sed -i -e 's/\r$//' autokill
chmod +x tendang && sed -i -e 's/\r$//' tendang
chmod +x ceklim && sed -i -e 's/\r$//' ceklim
chmod +x ram && sed -i -e 's/\r$//' ram
chmod +x renewssh && sed -i -e 's/\r$//' renewssh
chmod +x clearlog && sed -i -e 's/\r$//' clearlog
chmod +x changeport && sed -i -e 's/\r$//' changeport
chmod +x webmin && sed -i -e 's/\r$//' webmin
chmod +x xp && sed -i -e 's/\r$//' xp
chmod +x tessh && sed -i -e 's/\r$//' tessh
chmod +x wss && sed -i -e 's/\r$//' wss
chmod +x swapkvm && sed -i -e 's/\r$//' swapkvm

echo "0 3 * * * root clearlog" >> /etc/crontab
echo "0 1 * * * root delexp" >> /etc/crontab
echo "10 4 * * * root clearlog && sslh-fix-reboot" >> /etc/crontab
echo "0 0 * * * root clearlog" >> /etc/crontab
echo "0 12 * * * root clearlog" >> /etc/crontab
echo "0 * * * * root /usr/bin/fixbad" >> /etc/crontab

# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/sslh restart
/etc/init.d/stunnel5 restart
/etc/init.d/vnstat restart
/etc/init.d/fail2ban restart
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh

# finihsing
clear
