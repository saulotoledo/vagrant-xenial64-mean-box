#!/bin/bash

echo -e "## Adding NodeJS 7.x Repo to apt-get"
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -

echo -e "\n## Adding MongoDB Repo to apt-get"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

echo -e "\n## Updating dependency tree and upgrading the system"
sudo apt-get -qq update
sudo apt-get -qq -y upgrade

echo -e "\n## Installing some packages with APT-GET"
sudo apt-get -y -qq install git mongodb-org nodejs build-essential virtualbox-guest-dkms 

echo -e "\n## Adding MongoDB as a Service"
cat <<EOT | sudo tee /etc/systemd/system/mongodb.service > /dev/null
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --bind_ip 0.0.0.0 --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOT
sudo systemctl enable mongodb
sudo systemctl is-enabled mongodb
sudo systemctl start mongodb

echo -e "\n## Installing some NPM global libraries"
sudo npm install -g @angular/cli bower nodemon gulp node-gyp yarn

cat <<EOT >> /home/vagrant/.bashrc
cd /vagrant
EOT

echo -e "\n## Cleaning up and reducing VM size"
/vagrant/cleanup.sh

echo -e "\n## Versioning information"
echo VERSION CONTROL:
echo -n GIT:
git --version
echo -n NODE JS:
node -v
echo -n NPM:
npm -v
echo -n Angular-CLI:
ng --version
echo -n Bower:
bower --version
echo -n Nodemon:
nodemon --version
echo -n gulp:
gulp --version
echo -n node-gyp:
node-gyp --version
echo MONGODB:
mongod --version
sudo systemctl status mongodb
