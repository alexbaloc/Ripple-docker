#
#   Docker for go ethereum with solidity compiler
#

FROM ubuntu:15.10

MAINTAINER https://github.com/alexbaloc


# --- --- ---  Get the source code --- --- ---
RUN apt-get -y install git

RUN git clone https://github.com/ripple/rippled.git
RUN cd rippled && git checkout develop

# --- --- ---  Update OS --- --- ---
#
# The first script below needs python-software-properties, which is not available.
# An update will offer suitable alternatives
#
RUN apt-get -y install apt-transport-https && apt-get update
RUN apt-get -y install wget software-properties-common


# --- --- ---  Install dependencies --- --- ---
RUN cd rippled/Builds/Ubuntu && ./install_rippled_depends_ubuntu.sh

# --- --- ---  Build RippleD --- --- ---
RUN cd rippled && scons -j 4

#install NPM
RUN apt-get -y install npm

#install ripple REST
RUN git clone https://github.com/alexbaloc/ripple-rest.git
RUN cd ripple-rest && npm install
COPY ripple-REST-cfg.json /ripple-rest/config.json

# --- --- ---  Configure  & start--- --- ---
#create DB folder
RUN cd /var/lib && mkdir -p rippled/db/
RUN mkdir /var/log/rippled/

COPY ripple-standalone.cfg /rippled/build/ripple-standalone.cfg

RUN ./rippled --conf /rippled/build/ripple-standalone.cfg --start

#start everything
RUN cd ripple-rest && npm start
