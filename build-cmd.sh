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

case "$AUTOBUILD_PLATFORM" in
    windows*)
        autobuild="$(cygpath -u "$AUTOBUILD")"
    ;;
    *)
        autobuild="$AUTOBUILD"
    ;;
esac

source_environment_tempfile="$stage/source_environment.sh"
"$autobuild" source_environment > "$source_environment_tempfile"
. "$source_environment_tempfile"

pushd "$stage"
    case "$AUTOBUILD_PLATFORM" in
        windows*)
            # Grab the release from GitHub
            tar xjf --strip-components=1 "$top"/webrtc.windows_x86_64.tar.bz2

            # Munge the WebRTC Build package contents into something compatible
            # with the layout we use for other autobuild pacakges
            mv include webrtc
            mkdir include
            # mv webrtc include
            # In Cygwin, when running build-cmd.sh, the previous mv
            # command fails with a permission error - works at the
            # command line - rather than fight Cygwin, we just copy 
            # the files instead of move them... (Same for 'release lib'
            # line below)
            cp -R webrtc/ include/
            mv lib release
            mkdir lib
            # mv release lib
            cp -R release/ lib/
            mkdir LICENSES
            mv NOTICE LICENSES/webrtc-license.txt
        ;;

        darwin*)
            # Grab the release from GitHub
            tar xjf --strip-components=1 "$top"/webrtc.macos_x86_64.tar.bz2

            # Munge the WebRTC Build package contents into something compatible
            # with the layout we use for other autobuild pacakges
            mv include webrtc
            mkdir include
            mv webrtc include
            mv lib release
            mkdir lib
            mv release lib
            mv Frameworks/WebRTC.xcframework/macos-x86_64/WebRTC.framework lib/release
            mkdir LICENSES
            mv NOTICE LICENSES/webrtc-license.txt
        ;;

        linux*)
            echo "This project is not currently supported for $AUTOBUILD_PLATFORM" 1>&2 ; exit 1
        ;;
    esac

    # Generate the version number used to name packages from an entry
    # in the VERSIONS file that is distributed as part of the main package.
    # TODO: change 'tag' to '3P_WEBRTC_BUILD_RELEASE_VERSION' when
    # that line makes it into the VERSIONS file in releases
    version=${RELEASE#*=}
    build=${AUTOBUILD_BUILD_ID:=0}
    echo "${version}.${build}" > "${stage}/VERSION.txt"
popd
