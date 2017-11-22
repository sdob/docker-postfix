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

postfix check
