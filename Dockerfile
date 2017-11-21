FROM ubuntu:zesty

RUN echo "postfix postfix/mailname string your.hostname.com" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type string \"Internet Site\"" | debconf-set-selections

# Update
RUN apt-get update

# Install packages
RUN apt-get -y install supervisor postfix python3
RUN apt-get -y install postfix-pgsql

# Add install script
ADD ./install.sh /opt/install.sh

# Run!
CMD /opt/install.sh;/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
