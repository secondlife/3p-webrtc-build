#!/bin/bash

autobuild build -A64 -- ../build-local.sh
autobuild package --build-dir stage -A64
