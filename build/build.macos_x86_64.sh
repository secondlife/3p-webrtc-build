#!/bin/bash

set -ex
cd `dirname $0`
pip3 install setuptools
python3 run.py build --debug macos_x86_64 --webrtc-fetch --commit "$1"
python3 run.py package --debug macos_x86_64
