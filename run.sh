#!/bin/bash

# Read password from secret file     
if [ -f /etc/ssp/bindpw ]; then
   export LDAP_BINDPW=$(cat /etc/ssp/bindpw)
else
   echo "File /etc/ssp/bindpw does not exist."
   exit 1
fi

# Read keyphrase from secret file     
if [ -f /etc/ssp/keyphrase ]; then
   export KEYPHRASE=$(cat /etc/ssp/keyphrase)
else
   echo "File /etc/ssp/keyphrase does not exist, generate a random phrase."
   export KEYPHRASE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
fi

# Read smtp pass from secret file     
if [ -f /etc/ssp/smtppass ]; then
   export SMTP_PASS=$(cat /etc/ssp/smtppass)
   export SMTP_AUTH="true"
else
   echo "File /etc/ssp/smtppass does not exist"
   export SMTP_AUTH="false"
fi

export MAIL_FROM=${MAIL_FROM:-admin@example.com}
export MAIL_FROM_NAME=${MAIL_FROM_NAME:-Self Service Password}
export SMTP_HOST=${SMTP_HOST:-localhost}
export DEBUG=${DEBUG:-false}
export LDAP_URL=${LDAP_URL:-ldaps://localhost}
export LDAP_BINDDN=${LDAP_BINDDN:-cn=manager,dc=example,dc=com}
export LDAP_BASE=${LDAP_BASE:-dc=example,dc=com}

envsubst '$DEBUG ${MAIL_SIGNATURE} ${MAIL_FROM} ${MAIL_FROM_NAME} ${SMTP_HOST} ${SMTP_USER} ${SMTP_PASS} ${LDAP_URL} ${LDAP_BASE} ${LDAP_BINDDN} ${KEYPHRASE} ${LDAP_BINDPW}' \
         < /usr/share/self-service-password/conf/config.inc.tmpl.php > /usr/share/self-service-password/conf/config.inc.php


unset LDAP_BINDPW KEYPHRASE SMTP_PASS SMTP_HOST LDAP_URL LDAP_BINDDN LDAP_BASE
exec /usr/sbin/apache2ctl -D FOREGROUND
