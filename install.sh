# Configure Postfix-Postgres
cat > /etc/postfix/pgsql-aliases.cf <<EOF
hosts = $db_host
user = $db_user
password = $db_password
dbname = $db_name
EOF

cat /etc/postfix/main.cf
