# 3p-webrtc-build

This repository contains scripts and tooling to download, patch, and
build webrtc.  Patches include bugfixes and other fixes inheirited from
the repository from which this repo was forked.  [github.com/webrtc-sdk/webrtc-build](https://github.com/webrtc-sdk/webrtc-build)

The build process clones [github.com/webrtc-sdk/webrtc](https://github.com/webrtc-sdk/webrtc)
into a local source repository and launches the google tools to build the
libraries, followed by packaging by autobuild.

Typically, Github Actions is used to build the packages and release them.
It's also possible to build them locally, as noted below.

# Second Life Local Building and Debugging Notes

These notes describe the process of building the webrtc libraries locally,
installing the libraries to the Second Life viewer build, and debugging webrtc
issues.

## Build Dependencies

The following should be installed to build the webrtc libraries.

* [Autobuild](https://wiki.secondlife.com/wiki/Autobuild)

### Windows
* [Cigwyn](https://www.cygwin.com/)
or
* [git bash shell](https://git-scm.com/downloads/win)

## Building

The following instructins describe the process of building the library package

### Linux

From the root directory of the 3p-webrtc-build, run the following script:
```build-local-autobuild-package.sh```

This will build the Ubuntu 22.04 version of the WebRTC libraries and package
them as an autobuild package.  The autobuild package will be created in
the root directory, and will resemble something like:
```webrtc-m114_release.242741945-linux64-242741945.tar.bz2```

### OSX

From the root directory of the 3p-webrtc-build, run the following script:
```build-local-autobuild-package.sh```

This will build the OSX version of the WebRTC libraries and package
them as an autobuild package.  The autobuild package will be created in
the root directory, and will resemble something like:
```webrtc-m114_release.242741945-darwin64-242741945.tar.bz2```

### Windows

From the root directory of the 3p-webrtc-build, run the following script:
```build-local-autobuild-package.sh```

This will build the OSX version of the WebRTC libraries and package
them as an autobuild package.  The autobuild package will be created in
the root directory, and will resemble something like:
```webrtc-m114_release.242741945-windows64-242741945.tar.bz2```

## Installing In Viewer Builds

### Windows

In the viewer build directory, uninstall the previous webrtc package with:
```autobuild uninstall -c <configuration> -A64 webrtc``` where `configuration` is the configuration you're building with such as `RelWithDebInfoOS.`

Then, you can install your locally built version of the webrtc package with:
```autobuild install -c <configuration> -A64 --local <path-to-webrtc-autobuild-package> webrtc```

where the path is in the form for paths used by your shell, such as:
```autobuild install -c RelWithDebInfoOS -A64 --local /c/Users/roxieuser/git/3p-webrtc-build/webrtc-m114_release.242752326-windows64-242752326.tar.bz2 webrtc```

If you get an error such as:
```ERROR: [WinError 5] Access is denied: 'C:\\Users\\user\\git\\viewer\\build-vc170-64\\packages\\include/webrtc/third_party/depot_tools/.cipd_bin/2.7/bin/include/Python-ast.h'```

You may need to uninstall again, and then delete the viewer/build-vc170-64/packages/include/webrtc directory:
```rm -rf build-vc170-64/packages/include/webrtc/```

### Mac

In the viewer build directory, uninstall the previous webrtc package with:
```autobuild uninstall -c <configuration> -A64 webrtc``` where `configuration` is the configuration you're building with such as `RelWithDebInfoOS.`

Then, you can install your locally built version of the webrtc package with:
```autobuild install -c <configuration> -A64 --local <path-to-webrtc-autobuild-package> webrtc```

where the path is in the form for paths used by your shell, such as:
```autobuild install -c RelWithDebInfoOS -A64 --local /c/Users/roxieuser/git/3p-webrtc-build/webrtc-m114_release.242752326-darwin64-242752326.tar.bz2 webrtc```

### Mac

In the viewer build directory, uninstall the previous webrtc package with:
```autobuild uninstall -c <configuration> -A64 webrtc``` where `configuration` is the configuration you're building with such as `RelWithDebInfoOS.`

Then, you can install your locally built version of the webrtc package with:
```autobuild install -c <configuration> -A64 --local <path-to-webrtc-autobuild-package> webrtc```

where the path is in the form for paths used by your shell, such as:
```autobuild install -c RelWithDebInfoOS -A64 --local /c/Users/roxieuser/git/3p-webrtc-build/webrtc-m114_release.242752326-linux64-242752326.tar.bz2 webrtc```

