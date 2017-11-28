# This is our source image
FROM ubuntu:zesty

# Listen on port 25
EXPOSE 25

# Add install script
ADD ./install.sh /opt/install.sh
# Add env variables
ADD .env /opt/.env
# TODO: I don't think this (a) works or (b) is necessary. We can
# source the .env file during installation, anyway.
RUN eval $(cat /opt/.env | sed 's/^/export /')

# TODO: This *isn't* working at the moment; we need to get the environment
# variable in some other way. Right now we're only using it at build time
# anyway, to suppress a request for a value from the Postfix installation
# process.
ARG mailhost=$mailhost

# Echo these to debconf-set-selections to make postfix installation non-interactive
RUN echo postfix postfix/mailname string ${mailhost} | debconf-set-selections
RUN echo postfix postfix/main_mailer_type string "Internet Site" | debconf-set-selections

# Update packages (quietly)
RUN apt-get -qq update

# Install packages
RUN apt-get -qq install postfix postfix-pgsql supervisor
# TODO Remove the following packages when we have a working configuration; they're
# just for debugging
RUN apt-get -qq install less vim python3

# Run the install script, then start Postfix
CMD /opt/install.sh ; /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
