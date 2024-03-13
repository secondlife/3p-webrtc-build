#!/usr/bin/env bash

cd "$(dirname "$0")"

# turn on verbose debugging output for logs.
exec 4>&1; export BASH_XTRACEFD=4; set -x

# make errors fatal
set -e

# bleat on references to undefined shell variables
set -u

# Suddenly, Cygwin inserts extra CRLFs in places such
# as the code that extracts version numbers so we need
# this command to stop it doing that...
[[ "$OSTYPE" == "cygwin" ]] && set -o igncr

top="$(pwd)"
stage="$top"/stage
mkdir "$stage"

autobuild="$AUTOBUILD"

source_environment_tempfile="$stage/source_environment.sh"
"$autobuild" source_environment > "$source_environment_tempfile"
. "$source_environment_tempfile"

tar xjf --strip-components=1 "$top"/webrtc."$AUTOBUILD_PLATFORM_NAME".tar.bz2

# Munge the WebRTC Build package contents into something compatible
# with the layout we use for other autobuild pacakges
mv include webrtc
mkdir include
mv webrtc include
mv lib release
mkdir lib
mv release lib
mv Frameworks/WebRTC.xcframework/"$AUTOBUILD_PLATFORM_NAME"/macos-x86_64/WebRTC.framework lib/release
mkdir LICENSES
mv NOTICE LICENSES/webrtc-license.txt

version=${RELEASE#*=}
build=${AUTOBUILD_BUILD_ID:=0}
echo "${version}.${build}" > "${stage}/VERSION.txt"
