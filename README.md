# Enapter Industrial Linux

## Overview

Welcome to the Enapter Industrial Linux (EIL) repository. Here, you'll find recipes and scripts to build a robust reliable and extendable industrial Linux distro image designed for easy and reliable operation. Our image ensures all system files and the root filesystem are mounted in read-only mode, preventing any accidental changes from being saved after a reboot.

## Key Features

- **Reliable and Secure**: Utilizes an overlayfs with a SquashFS root image for read-only root, aiding in system stability and reliability.

- **Power Failure Tolerance**: System files are read-only, reducing the risk of corruption during power failures.

- **USB Stick Boot**: Easily boot from a USB stick with a simple FAT32 partition.

- **Service Discovery**: Built-in service for device discovery in the network.

- **Docker Integration**: Easily run third-party programs and services inside Docker containers using Podman.

- **Flexible Layer System**: Introducing the concept of layers for modular and scalable system enhancements. Add functionality using layers with systemd services, Docker containers, and more.

## Enapter Gateway

Based on this image, we provide the Enapter Gateway firmware, which includes the prebundled Enapter IoT platform.

For more information about Enapter Gateway, please refer to the [Enapter Handbook](https://handbook.enapter.com/software/gateway_software/).

## Filesystem Layout

After flashing the EIL `.img` file onto a USB stick with [Etcher](https://etcher.balena.io) or the `dd` utility, the USB stick will contain a single FAT32 partition with:

- Bootloader and configuration files (Shim, Grub2 config, Grub2 EFI image)

- System Files (Linux Kernel, Linux Kernel Initramfs, Root filesystem image (`rootfs.img`))

- Layers (optional)

Persistent user data is stored separately in the `/user` partition mounted from the internal disk of your PC.

## Layer System

In addition to the main distribution and the functionality of Docker Compose, we present the concept of layers.

### What is a Layer?

A layer is an `.img` file, a SquashFS image, comprising two main components: system files and Docker container images.

- **System Files**: These files can update, add, or delete any files in the base layer. This includes systemd service files, scripts, binary files, and even kernel modules. Layers can be distributed separately from the base image, ensuring GPL license compliance.

- **Docker Container Images**: These include pre-defined Docker containers of specific applications or services.

An example layer and corresponding build scripts can be found in the Cloudflare Remote Access layer example [repository](https://github.com/Enapter/cloudflared-remote-access-layer).

## Yocto-based

This image is built on Yocto, and the repository includes a `.gitlab-ci.yml` file along with a set of scripts for the build process.

The build is executed inside the Yocto Build container based on the [enapter/build-yocto](https://github.com/Enapter/build-yocto/blob/main/Dockerfile) image.

The Enapter Industrial Linux distribution is based on the [meta-enapter](https://github.com/enapter/meta-enapter) layer. This layer includes all necessary modifications and enhancements to adapt generic Linux for use in industrial IoT scenarios.

## Secure Boot Support

Enapter Industrial Linux supports Secure Boot, but we do not have our own certificate signed by Microsoft. As a result, booting the Enapter Industrial Linux distribution on a PC with Secure Boot enabled will show an error. The system will suggest adding a hash or certificate to the trusted database.

To resolve this, add the `Enapter.cer` certificate to the trusted certificates database. The `Enapter.cer` file is located at the root of the filesystem on the USB stick after flashing the image to the disk.

## Support

For any questions, feel free to reach out to us at [developers@enapter.com](mailto:developers@enapter.com) or join our community on [Discord](https://discord.com/invite/TCaEZs3qpe).
