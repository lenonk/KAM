KDE KAM
=======================

KAM is a reimplementation of NZXT CAM, on Linux.  I got tired of using multiple programs and libraries to control
my Kraken and my case lighting, so I just remade CAM, without the spyware, of course.

Currently, KAM is very, very alpha.  I have limited time to work on it, and since it all works for me, bug fixes may be slow.  That being said, pull requests are welcome, and I encourage you to open issues as you find them.

KAM *should* work for any Asatek cooler, at least as far as the fan profiles go.  Honestly though, if you're not using
a Kraken and/or a smart device, the system monitoring stuff is available elsewhere, and liquidctl does a fine job of setting fan profiles.

If you're not using KDE, have a look at GKraken.  He claims that lighting control is coming soon.

# Compilation instructions

*Dependencies*

Install the dependencies first:

* Qt5 Core Gui Qml QuickControls2 Svg
* KF5 Kirigami 2
* KF5 I18n
* Boost System Filesystem exception
* X11 dev
* lmsensors

*Temporary dependencies*

These dependencies are temporary, and will be optional eventually.

* Nvml

## From the source root:
mkdir build
cd build
cmake ..
make && make install

## Nvidia GPU is curently required

I don't have an AMD GPU to test with.  I'm working on that.  As soon as I do, AMD GPUs will be supported
and Nvml will no longer be required to compile, as the makefiles will be smart enough to choose Nvml or
the AMD equivalent.
