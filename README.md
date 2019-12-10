
# vasmm68k pre-built for Linux and Windows

![](https://github.com/prebuilt-amiga-dev-tools/vasmm68k/workflows/Build/badge.svg)

# Windows users

There are two distributions for Windows users; an installr package, and a raw set of binaries.

## Run installer

Download a windows-installer package from the [releases](https://github.com/prebuilt-amiga-dev-tools/vasmm68k/releases) page. Then run the installer. It will install `vasmm68k_mot.exe`, `vasmm68k_std.exe` and `vobjdump.exe` into `<Program Files location>\prebuilt-amiga-dev-tools\bin`, and add that folder to your path.

## Download binaries

Download a windows-binaries package from the [releases](https://github.com/prebuilt-amiga-dev-tools/vasmm68k/releases) page. Then unpack the archive to a suitable location.

# Linux (Ubuntu) users

First, add the Apt repository to your list of default repos:

```
sudo echo "deb https://prebuilt-amiga-dev-tools.github.io/apt/ xenial main" | sudo tee /etc/apt/sources.list.d/prebuilt-amiga-dev-tools.list
wget http://prebuilt-amiga-dev-tools.github.io/apt/PUBLIC.KEY -O - | sudo apt-key add -
```

Then, install vasmm68k:
```
sudo apt-get update && apt-get install vasmm68k
```

# Development

Check out the [development manual](DEVELOPMENT.md).