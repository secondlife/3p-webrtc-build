#!/usr/bin/env bash

cd "$(dirname "$0")"
artifact_id="$1"

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
stage="${top}"/stage

case "$AUTOBUILD_PLATFORM" in
    windows64)
        autobuild="$(cygpath -u "$AUTOBUILD")"
        build_type="windows_x86_64"
    ;;
    darwin64)
        autobuild="$AUTOBUILD"
        build_type="macos_x86_64"
    ;;
    *)
        echo "This project is not currently supported for $AUTOBUILD_PLATFORM" 1>&2 ; exit 1
        
    ;;
esac

source_environment_tempfile="$stage/source_environment.sh"
"$autobuild" source_environment > "$source_environment_tempfile"
. "$source_environment_tempfile"

pushd "$stage"

# download the artifact
curl -o webrtc.tar.bz2.zip -L -H "Accept: application/vnd.github+json" \
                              -H "X-GitHub-Api-Version: 2022-11-28" \
                              -H "Authorization: Bearer $AUTOBUILD_GITHUB_TOKEN" \
                              https://api.github.com/repos/secondlife/3p-webrtc-build/actions/artifacts/"$artifact_id"/zip

# delete it so autobuild upload doesn't assume it's a bad autobuild artifact
# TODO: Find a better way to do this that doesn't involve a 3rd party action
#curl -X DELETE -H "Accept: application/vnd.github+json" \
#               -H "X-GitHub-Api-Version: 2022-11-28" \
#               -H "Authorization: Bearer $AUTOBUILD_GITHUB_TOKEN" \
#               https://api.github.com/repos/secondlife/3p-webrtc-build/actions/artifacts/"$artifact_id"

unzip webrtc.tar.bz2.zip
tar xjf webrtc.tar.bz2 --strip-components=1
rm webrtc.tar.bz2.zip
rm webrtc.tar.bz2

# Munge the WebRTC Build package contents into something compatible
# with the layout we use for other autobuild pacakges
mv include webrtc
mkdir include
mv webrtc include
mv lib release
mkdir lib
mv release lib
mkdir LICENSES
mv NOTICE LICENSES/webrtc-license.txt

case "$AUTOBUILD_PLATFORM" in
    darwin64)
        mv Frameworks/WebRTC.xcframework/macos-x86_64/WebRTC.framework lib/release
    ;;
esac

build=${AUTOBUILD_BUILD_ID:=0}
echo "${GITHUB_REF:10}.${build}" > "VERSION.txt"
popd

