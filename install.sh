# This script runs before the Postfix service starts;
# we do all our configuration stuff in here.

# Get environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ENV_FILE="${DIR}/.env"
eval $(cat $ENV_FILE | sed 's/^/export /')

echo $mailhost

########################
# Configure supervisor #
########################

cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[supervisord]
nodaemon=true

[program:postfix]
command=/opt/postfix.sh

[program:rsyslog]
command=/usr/sbin/rsyslogd -n -c3
EOF

################################
# Configure Postfix-Postgresql #
################################

cat > /etc/postfix/pgsql-aliases.cf <<EOF
hosts = $db_host
user = $db_user
password = $db_password
dbname = $db_name
query = SELECT user_id from addresses_address where alias='%s'
EOF

####################################################
# Create a Postfix script for supervisord to watch #
####################################################

cat >> /opt/postfix.sh <<EOF
#!/bin/bash
service postfix start
EOF
chmod +x /opt/postfix.sh

#####################
# Configure Postfix #
#####################

# See http://flurdy.com/docs/postfix/

# Set mail host
postconf -e "myhostname=$mailhost"

# Use PostgreSQL lookup for aliases
postconf -e "alias_maps=pgsql:/etc/postfix/pgsql-aliases.cf"

# Disable VRFY command
postconf -e "disable_vrfy_command=yes"

# Limit DOS attacks, courtesy of https://security-24-7.com/hardening-guide-for-postfix-2-x/
postconf -e default_process_limit=100
postconf -e smtpd_client_connection_count_limit=10
postconf -e smtpd_client_connection_rate_limit=30
postconf -e queue_minfree=20971520
postconf -e header_size_limit=51200
postconf -e message_size_limit=10485760
postconf -e smtpd_recipient_limit=100

# Configure TLS
# TODO: Certs
postconf -e smtp_tls_security_level=may
postconf -e smtpd_tls_security_level=may
postconf -e smtp_tls_note_starttls_offer=yes
postconf -e smtpd_tls_loglevel=1
postconf -e smtpd_tls_received_header=yes
postconf -e smtpd_tls_session_cache_timeout=3600s
postconf -e tls_random_source=dev:/dev/urandom

# Check the config
postfix check
