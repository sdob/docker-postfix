# This is our source image
FROM ubuntu:zesty

# Listen on port 25
EXPOSE 25

# Add install script
ADD ./install.sh /opt/install.sh
# Add env variables
ADD .env /opt/.env
RUN eval $(cat /opt/.env | sed 's/^/export /')

ARG mailhost=$mailhost
# ENV mailhost


# Echo these to debconf-set-selections to make postfix installation non-interactive
RUN echo postfix postfix/mailname string ${mailhost} | debconf-set-selections
RUN echo postfix postfix/main_mailer_type string "Internet Site" | debconf-set-selections

# Update packages (quietly)
RUN apt-get -qq update

# Install packages
RUN apt-get -qq install postfix postfix-pgsql
# TODO Remove the following packages when we have a working configuration; they're
# just for debugging
RUN apt-get -qq install less vim python3

# Run the install script, then start Postfix
CMD ["sh", "-c", "/opt/install.sh ; service postfix start ; tail -F /var/log/mail.log"]
