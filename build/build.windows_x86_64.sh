#!/bin/bash

set -ex
cd `dirname $0`
pip3 install setuptools
python3 run.py build windows_x86_64 --webrtc-fetch --commit "$1"
python3 run.py package windows_x86_64
