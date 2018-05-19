# Self Service Password Container

Container for https://ltb-project.org/documentation/self-service-password

## Example

Example invocation with FreeIPA :

```bash
$ docker run --rm --name ssp -p 8080:8080 -p 8443:8443 \
         -v $(pwd)/ssp:/etc/ssp \
         -e "LDAP_URL=ldap://ipa.example.com" \
         -e "LDAP_BINDDN=uid=admin,cn=users,cn=accounts,dc=ipa,dc=example,dc=com" \
         -e "LDAP_BASE=cn=users,cn=accounts,dc=ipa,dc=example,dc=com" \
         -e "SMTP_HOST=smtp.example.com" \
         -e "SMPT_FROM=ldap_admin@example.com" \
         -e "DEBUG=true" barkbay/ssp:latest
```

Secrets like LDAP manager/SMTP password must be stored in a file, e.g. :

```bash
$ find ssp
ssp
ssp/smtppass
ssp/bindpw
```