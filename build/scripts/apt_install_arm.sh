#!/bin/bash

set -ex

apt-get update
apt-get -y upgrade

# On Ubuntu, need to set tzdata to noninteractive or else it'll stop.
apt-get -y install tzdata
echo 'UTC' > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

export DEBIAN_FRONTEND=noninteractive

apt-get -y install \
  build-essential \
  curl \
  git \
  gtk+-3.0 \
  lbzip2 \
  libgtk-3-dev \
  libstdc++6 \
  locales \
  lsb-release \
  ninja-build \
  multistrap \
  python3 \
  python3-setuptools \
  rsync \
  software-properties-common \
  sudo \
  unzip \
  vim \
  xz-utils

# https://github.com/volumio/Build/issues/348#issuecomment-462271607
# Fixes error with multistrap on Ubuntu
sed -e 's/Apt::Get::AllowUnauthenticated=true/Apt::Get::AllowUnauthenticated=true";\n$config_str .= " -o Acquire::AllowInsecureRepositories=true/' -i /usr/sbin/multistrap
