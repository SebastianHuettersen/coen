# Custom Ceremony Operating ENvironment (COEN)<!-- omit in toc -->

COEN-Custom provides a simplified and robust framework for quickly generating custom, lightweight, and secure Live Operating System ISO images. These images are tailored for specialized tasks, such as Certification Ceremonies, secure offline signing, or key generation events.

This project is a reworked version of the original COEN by IANA, with a focus on ease of modification.

## What is COEN-Custom?
COEN-Custom generates a live bootable environment based on:
- A custom Debian GNU/Linux Live CD
- A minimized Xfce Desktop Environment (easily modifiable)
- A self defined amount of Tools

The primary goal is to provide a clean, secure, and isolated environment for critical, verifiable procedures.

## Reproducible Custom COEN ISO image to enhance Root ceremony trustworthiness

The **reproducible** CUSTOM COEN ISO image provides a verifiable process to generate the same hash any time the COEN ISO image is built, which consequently increases trustworthiness in root ceremoneies.

### What are reproducible builds?

Quoted from https://reproducible-builds.org

> Reproducible builds are a set of software development practices that create an independently-verifiable path from source to binary code.

> The motivation behind the **Reproducible Builds** project is therefore to allow verification that no vulnerabilities or backdoors have been introduced during this compilation process. By promising identical results are always generated from a given source, this allows multiple third parties to come to a consensus on a "correct" result, highlighting any deviations as suspect and worthy of scrutiny.

## Quick Start Guide to build a custom CEON
### Requirements for Building
You will need a Linux host system with a container engine installed.
- Container Engine: Docker (recommended) or Podman
- Permissions: Execute commands as an administrator, root, or with sudo. The ISO generation process requires elevated container privileges (--privileged) to handle filesystem and device node creation.

Warning on SELinux: 
If you are using a Red Hat-based distribution (RHEL, CentOS, Fedora), SELinux may interfere with the build process, causing the resulting ISO hash to be non-reproducible. For the most reliable builds, disable SELinux entirely before execution.

### Custominze 
Identify the tools required for your key ceremony:
- If a package is available in the official Debian repository, add its name to the PACKAGE_CUSTOM variable in variables.sh.
- For Debian packages not in the official repository, copy the .deb file into tools/packages.
- Create and add a hook script to tools/hooks.

Modify MAKE variables:
- Set RELEASE
- Set CONTAINER_ENGINE to either docker or podman

Modify variable.sh:
- Set RELEASE to match the version specified in the Make file.
- Set DATE to the desired snapshot of the Debian archive repository.

Modify Dockerfiles
- Configure the base image to match the DATE variable specified in variables.sh.

### Pull the packages and create the HASH
Pull all required packages from the official Debian repository and calculate the necessary hash:

    make cache

### Create ISO
Generate the ISO using the following command:

    make build

Fix the mismatched hash of the ISO file by modifying the variable ISO_SHASUM in variables.sh.

### Test ISO
Test the ISO and all its built-in functions using a virtualization platform.

## Acknowledgments

This project is made possibly by:
- The [Reproducible Builds](https://reproducible-builds.org/) project
- [Debian serving as trust anchor](https://www.debian.org/)
- [Debuerreotype](https://github.com/debuerreotype/debuerreotype) a reproducible, snapshot-based Debian rootfs builder ([License](https://github.com/debuerreotype/debuerreotype/blob/master/LICENSE))
- [The Amnesic Incognito Live System](https://tails.boum.org/index.en.html) ([License](https://tails.boum.org/doc/about/license/index.en.html))
- [ iana-org coen](https://github.com/iana-org/coen/tree/master) ([License](https://github.com/iana-org/coen/blob/master/LICENSE.md))
