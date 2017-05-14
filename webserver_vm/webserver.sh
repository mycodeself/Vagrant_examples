#!/usr/bin/env bash

apt-get update


#install apache2
apt-get install -y apache2

#install php5 & modules
apt-get install -y php5 libapache2-mod-php5
apt-get install -y php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps 
apt-get install -y php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php-apc

sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 10M/" /etc/php5/apache2/php.ini
sed -i "s/short_open_tag = On/short_open_tag = Off/" /etc/php5/apache2/php.ini
sed -i "s/_errors = Off/_errors = On/" /etc/php5/apache2/php.ini


#install mysql
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get install -y mysql-server mysql-client
if [ ! -f /etc/phpmyadmin/config.inc.php ];
then
#install phpmyadmin
	debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean false'
	debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
	debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password root'
    debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password root'
    debconf-set-selections <<< 'phpmyadmin phpmyadmin/password-confirm password root'
    debconf-set-selections <<< 'phpmyadmin phpmyadmin/setup-password password root'
    debconf-set-selections <<< 'phpmyadmin phpmyadmin/database-type select mysql'
    debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password root'
    debconf-set-selections <<< 'dbconfig-common dbconfig-common/mysql/app-pass password root'
    debconf-set-selections <<< 'dbconfig-common dbconfig-common/mysql/app-pass password'
    debconf-set-selections <<< 'dbconfig-common dbconfig-common/password-confirm password root'
    debconf-set-selections <<< 'dbconfig-common dbconfig-common/app-password-confirm password root'
    debconf-set-selections <<< 'dbconfig-common dbconfig-common/app-password-confirm password root'
    debconf-set-selections <<< 'dbconfig-common dbconfig-common/password-confirm password root'
	
	apt-get install -y phpmyadmin
fi
#install composer
if [ ! -f /usr/local/bin/composer ];
then
	curl -sS https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer
	chmod a+x /usr/local/bin/composer
fi


# openjdk-7
sudo apt-get install -y openjdk-7-jre


#install git
apt-get install -y git

rm -rf /var/www
ln -fs /vagrant /var/www
/etc/init.d/apache2 restart
if [ ! -f /var/www/info.php ];
then
	echo "<?php phpinfo() ?>" >> /var/www/info.php
fi
apt-get upgrade -y
apt-get autoremove -y