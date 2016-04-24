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
#RUN echo "deb http://ftp.debian.org/debian/ stretch main" >> /etc/apt/sources.list
#RUN apt-get -y update

RUN cd rippled/Builds/Ubuntu && ./install_rippled_depends_ubuntu.sh 
RUN cd rippled && scons -j 4

#&& ./install_boost.sh

#clang 3.7 is not available in the standard PPA

#RUN apt-get -y install wget
#RUN wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key|sudo apt-key add -
#RUN echo "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.7 main" >> /etc/apt/sources.list
#RUN apt-get update

#RUN cd rippled/Builds/Ubuntu && ./build_clang_libs.sh




