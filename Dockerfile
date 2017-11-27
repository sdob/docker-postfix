# This is our source image
FROM ubuntu:zesty

# Listen on port 25
EXPOSE 25

# Echo these to debconf-set-selections to make postfix installation non-interactive
RUN echo "postfix postfix/mailname string $mailhost" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type string \"Internet Site\"" | debconf-set-selections

# Update packages
RUN apt-get update

# Install packages
RUN apt-get -y install postfix postfix-pgsql
# TODO Remove the following packages when we have a working configuration; they're
# just for debugging
RUN apt-get -y install less vim python3

# Add install script
ADD ./install.sh /opt/install.sh

# Run the install script, then start Postfix
CMD ["sh", "-c", "/opt/install.sh ; service postfix start ; tail -F /var/log/mail.log"]
