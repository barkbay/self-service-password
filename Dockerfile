FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -qy apt-transport-https gnupg

COPY ltb-project.list /etc/apt/sources.list.d/ltb-project.list
COPY RPM-GPG-KEY-LTB-project /etc/RPM-GPG-KEY-LTB-project

RUN apt-key add /etc/RPM-GPG-KEY-LTB-project && \
    apt-get -y update && \
    apt-get -y install php-mbstring php-xml openssl self-service-password libapache2-mod-security2 libapache2-mod-gnutls gettext-base && \
    apt-get clean

COPY config.inc.tmpl.php /usr/share/self-service-password/conf/config.inc.tmpl.php
RUN a2dissite 000-default && a2ensite self-service-password && \
    chmod g+rw /usr/share/self-service-password/conf/config.inc.php && \
    a2enmod headers

COPY apache2 /etc/apache2
COPY run.sh /
EXPOSE 8080 8443
CMD /run.sh
