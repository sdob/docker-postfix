FROM ubuntu:latest

# Update
RUN apt-get update

# Install packages
RUN apt-get -y install supervisor postfix python3
