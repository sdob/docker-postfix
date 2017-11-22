# This script runs before the Postfix service starts;
# we do all our configuration stuff in here.

# Configure Postfix-Postgres using the environment variables
# we passed in
cat > /etc/postfix/pgsql-aliases.cf <<EOF
hosts = $db_host
user = $db_user
password = $db_password
dbname = $db_name
EOF

# Set Postfix config options

# Set mail host
postconf -e "myhostname=$mailhost"
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

postfix check
