############################################################
# Dockerfile to build Nginx Installed Containers
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu #:14.04
FROM ubuntu:14.04

# File Author / Maintainer
MAINTAINER Maintaner Name

## ADD Nginx
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

## ADD PHP 5.6.2
#RUN echo "deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main" >> /etc/apt/sources.list
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C

## ADD PHP5.4 REPOSITORY
RUN echo "deb http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu precise main " > /etc/apt/sources.list.d/ondrej.list 
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C


# Update the repository
RUN apt-get update
RUN apt-get upgrade -y

###################################################

# Install necessary tools
#RUN apt-get install -y nano 
#wget dialog net-tools

# Download and Install Nginx
RUN apt-get install -y nginx

# Downlad and Install GIT
RUN apt-get install -y git

# Install PHP-FPM and popular/laravel required extensions
RUN apt-get install -y \
    curl \
    php5-cli \
    php5-fpm \
    php5-curl \
    php5-gd \
    php5-geoip \
    php5-imagick \
    php5-imap \
    php5-json \
    php5-ldap \
    php5-mcrypt \
    php5-memcache \
    php5-memcached \    
    php5-mssql \
    php5-mysqlnd \
    php5-pgsql \    
    php5-sqlite \
    php5-xdebug \
    php5-xmlrpc \   
    php5-xcache
    
    
#RUN apt-get update -y
#RUN apt-get upgrade -y  
#RUN apt-get install -y php5-mongo
#RUN apt-get install -y php5-redis


###################################################

# Remove the default Nginx configuration file
RUN rm -v /etc/nginx/nginx.conf

# Copy a configuration file from the current directory
ADD /configs/nginx.conf /etc/nginx/


# Append "daemon off;" to the beginning of the configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

###################################################

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini

# Set up php fpm, restart php
ADD /configs/php_pool /etc/php5/fpm/pool.d/default.conf

# Remove default
RUN rm -v /etc/php5/fpm/pool.d/www.conf

###################################################


# Install composer
RUN curl -sS https://getcomposer.org/installer | php \
        && mv composer.phar /usr/local/bin/composer


###################################################



# Expose ports
EXPOSE 80
 
# Set the default command to execute
# when creating a new container
#CMD service nginx start
#CMD service php5-fpm start


CMD service php5-fpm start && nginx