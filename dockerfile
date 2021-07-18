FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y apt-utils ssh netcat jq psmisc && \
    apt-get install -y python3 python3-pip && \
    apt-get install -y chromium-browser udev chromium-chromedriver

RUN pip3 install --upgrade pip && pip3 install beautifulsoup4 requests selenium

# Set Lang
ENV LANG C.UTF-8
ENV LC_ALL=C.UTF-8

# Insert ssh proxy launching command to aws sh
ARG PROXY_HOST
ARG PROXY_PORT
ARG PROXY_USER
ARG PROXY_PEM
ADD $PROXY_PEM /proxy.pem
RUN chmod 600 /proxy.pem

ARG proxy_command="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -N -D8079 -p$PROXY_PORT -4 $PROXY_USER@$PROXY_HOST -i /proxy.pem &\nwait \$!"
RUN echo "$proxy_command" > /proxy_launch.sh && \
    chmod 755 /proxy_launch.sh

