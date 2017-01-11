#@IgnoreInspection BashAddShebang

sudo add-apt-repository ppa:ondrej/php
sudo add-apt-repository ppa:ondrej/apache2
sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install apache2 php7.1 libapache2-mod-php7.1 php7.1-mcrypt php7.1-curl php7.1-gd php7.1-gmp php7.1-mbstring php7.1-posix php7.1-xml php7.1-sqlite3 sqlite3 php7.1-mysql -y

sudo a2enmod rewrite

sudo bash -c "cat > /etc/apache2/sites-available/000-default.conf" << EOF
<Directory /var/www/html/public>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>

<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/public

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo rm -f /var/www/html/index.html
sudo apachectl restart

#mysql
# prepare mysql installation anserws
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password P@ssw0rd'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password P@ssw0rd'

# install MySQL
echo "installing mysql-server"
sudo apt-get install mysql-server -y
echo "mysql version is:"
mysql --version

#configure MySQL
#sudo rm /etc/mysql/my.cnf
sudo bash -c "cat > /etc/mysql/my.cnf" << EOF
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mysql.conf.d/
# start your overrides
[mysql]
bind-address = 0.0.0.0
EOF

#####
##### Somehow comment out `skip-external-locking' from /etc/mysql/mysql.conf.d/mysqld.cnf
#####

sudo mysql -u root -pP@ssw0rd -e "create database WEBAPP";
mysql -u root -pP@ssw0rd -e "CREATE USER 'webappuser'@'localhost' IDENTIFIED BY 'P@ssw0rd'";
mysql -u root -pP@ssw0rd -e "GRANT ALL PRIVILEGES ON WEBAPP.* TO 'webappuser'@'localhost'";

mysql -u root -pP@ssw0rd -e "CREATE USER 'webappuser'@'10.0.2.2' IDENTIFIED BY 'P@ssw0rd'";
mysql -u root -pP@ssw0rd -e "GRANT ALL PRIVILEGES ON WEBAPP.* TO 'webappuser'@'10.0.2.2'";
mysql -u root -pP@ssw0rd -e "FLUSH PRIVILEGES";

sudo systemctl restart mysql
sudo systemctl enable mysql
