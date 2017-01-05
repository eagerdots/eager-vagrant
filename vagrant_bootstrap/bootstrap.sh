#@IgnoreInspection BashAddShebang

sudo add-apt-repository ppa:ondrej/php
sudo add-apt-repository ppa:ondrej/apache2
sudo apt-get update
sudo apt-get install apache2 php7.1 libapache2-mod-php7.1 php7.1-mcrypt php7.1-curl php7.1-gd php7.1-gmp php7.1-mbstring php7.1-posix php7.1-xml php7.1-sqlite sqlite3 -y

sudo a2enmod rewrite

sudo bash -c "cat > /etc/apache2/sites-available/000-default.conf" << EOF
<Directory /var/www>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>

<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo apachectl restart
