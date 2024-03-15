#!/bin/bash

sleep 30
set -e

# Update all packages
sudo yum -y update

# Configure SSH for custom SSH account and disable root login
sudo usermod -aG wheel ec2-user
sudo passwd -d ec2-user  # Disable password login for ec2-user
echo 'AllowUsers ec2-user' | sudo tee -a /etc/ssh/sshd_config
echo 'PasswordAuthentication no' | sudo tee -a /etc/ssh/sshd_config
echo 'PermitRootLogin no' | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart sshd
#sudo yum update

# Installing SSH key
#sudo mkdir -p /home/ec2-user/.ssh
#sudo chmod 700 /home/ec2-user/.ssh
#sudo cp /tmp/tf-packer.pub /home/ec2-user/.ssh/authorized_keys
#sudo chmod 600 /home/ec2-user/.ssh/authorized_keys
#sudo chown -R ec2-user /home/ec2-user/.ssh
#sudo usermod --shell /bin/bash ec2-user

# Install and configure Apache web server
sudo yum install -y httpd php php-mysqli mariadb105
sudo systemctl start httpd
sudo systemctl enable httpd

sudo usermod -a -G apache ec2-user
sudo yum -y update
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

sudo mv /tmp/info.php /var/www/html/info.php
sudo chmod +x /var/www/html/info.php
sudo systemctl restart httpd

#install composer and php dependencies
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
    >&2 echo 'ERROR: Invalid Composer installer signature'
    rm composer-setup.php
    exit 1
fi
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
composer require aws/aws-sdk-php
composer install 

sudo mv /home/ec2-user/vendor /var/www/html/vendor
sudo systemctl restart httpd