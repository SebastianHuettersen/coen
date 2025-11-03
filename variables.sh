#!/bin/bash
# Configuration for creating the ISO image. This script is executed by create-iso.sh

set -x   # Print each command before executing it
set -e   # Exit immediately should a command fail
set -u   # Treat unset variables as an error and exit immediately

export RELEASE=0.5.0			        # Release version number
export DATE=20240701			        # Timestamp to use for version packages (`date +%Y%m%d`)
export LOCALE_LC_ALL=POSIX              # Current OS locale setting
export DIST=bookworm			        # Debian distribution base image
export ARCH=amd64			            # Target architecture
export SOURCE_DATE_EPOCH="$(date --utc --date="$DATE" +%s)" # defined by reproducible-builds.org
export WD=/opt/coen-${RELEASE}          # Working directory to create the image
export ISONAME=${WD}-${ARCH}.iso        # Final name of the ISO image
export TOOL_DIR=/tools                  # Location to install the tools
export HOOK_DIR=$TOOL_DIR/hooks         # Hooks
export PACKAGE_DIR=$TOOL_DIR/packages   # Packages
export DISTRO_DIR=$TOOL_DIR/archives-distro # Distro packages
export ISO_SHASUM="10c449c3d7134eb6e7a3d764eaffc85402dc00f75a383e5decd511e79a286e38  -" # ISO image SHA-256

# Define packages for COEN
export PACKAGES_CORE="linux-image-$ARCH live-boot systemd-sysv grub-common grub-pc-bin grub-efi-amd64-bin iproute2 ifupdown iputils-ping pciutils libbsd-dev"
export PACKAGE_DESKTOP="xserver-xorg-core xserver-xorg lightdm xfce4 xfce4-terminal xfce4-panel xfce4-power-manager xfce4-screenshooter"
export PACKAGE_TOOLS="vim less links2 tree xpdf usbutils dosfstools eject exfatprogs openssl"
export PACKAGE_CUSTOM=""
export PACKAGES="$PACKAGES_CORE $PACKAGE_DESKTOP $PACKAGE_TOOLS $PACKAGE_CUSTOM"