DISTRO_NAME = "Enapter Industrial Linux"
DISTRO_CODENAME = "genapter"
PACKAGE_CLASSES = "package_rpm"
USER_CLASSES = "buildstats"
PATCHRESOLVE = "noop"

MAINTAINER = "Enapter Developers <developers@enapter.com>"

TARGET_VENDOR = "-enapter"

IMAGE_FEATURES[validitems] += "secureboot"
EXTRA_IMAGE_FEATURES += "secureboot"

BB_DANGLINGAPPENDS_WARNONLY = "1"
INITRAMFS_MAXSIZE="655360"

ROOT_HOME = "/root"
VOLATILE_LOG_DIR = "no"
SERIAL_CONSOLES = ""

IMAGE_FS_TOOLS = "\
    dosfstools \
    e2fsprogs \
    e2fsprogs-e2fsck \
    e2fsprogs-mke2fs \
    e2fsprogs-resize2fs \
    e2fsprogs-tune2fs \
    grub-editenv \
    parted \
    squashfs-tools \
    util-linux \
"

IMAGE_INITRD_KERNEL_DEPS = "\
    lshw \
    pciutils \
    usbutils \
"

IMAGE_KERNEL_DEPS = "\
    ${IMAGE_INITRD_KERNEL_DEPS} \
    iucode-tool \
    kernel-modules \
    linux-firmware-i915 \
    linux-firmware-ibt \
    linux-firmware-iwlwifi \
    module-init-tools \
    packagegroup-base-wifi \
"

IMAGE_ROOTFS_INSTALL_BASE_UTILS = "\
    bash \
    bc \
    bind-utils \
    coreutils \
    file \
    findutils \
    grep \
    gzip \
    iproute2 \
    iproute2-ip \
    iproute2-ss \
    iproute2-tc \
    iputils-arping \
    iputils-ping \
    less \
    net-tools \
    procps \
    sed \
    shadow-base \
    tar \
    time \
    traceroute \
    unzip \
    wget \
    which \
"

IMAGE_ROOTFS_INSTALL_CONNECTIVITY = "\
    avahi-daemon \
    avahi-utils \
    bluez5 \
    can-utils \
    can-utils-access \
    can-utils-cantest \
    can-utils-log \
    can-utils-slcan \
    dnsmasq \
    hostapd \
    mobile-broadband-provider-info \
    modemmanager \
    netplan \
    networkmanager \
    networkmanager-nmtui \
    networkmanager-ppp \
    networkmanager-wwan \
    openssh \
"

IMAGE_ROOTFS_INSTALL_ENAPTER_OSS_SOFTWARE = "\
    enapter-authorized-ssh-keys-configurator \
    enapter-cron-hook \
    enapter-cron-hook-timer \
    enapter-initscripts \
    enapter-journald-persistence \
    enapter-login-cli \
    enapter-network-configurator \
    enapter-networkmanager-configurator \
    enapter-password-configurator \
    enapter-scripts \
    enapter-setup-machine-id \
    enapter-user \
    enapter-wifi-watchdog \
    enapter-wifi-watchdog-timer \
    gpl-source-code-offer \
    nginx \
    rauc \
"

IMAGE_ROOTFS_INSTALL_EXTENDED_UTILS = "\
    curl \
    dmidecode \
    iptables \
    jq \
    sudo-lib \
    sudo-sudo \
"

IMAGE_ROOTFS_INSTALL_OS_SUPPORT = "\
    bash-completion \
    bash-completion-extra \
    systemd-bash-completion \
"

IMAGE_ROOTFS_INSTALL_SYSTEM_DAEMONS = "\
    auditd \
    chrony \
    chronyc \
    cronie \
"

IMAGE_ROOTFS_INSTALL = "\
    ${IMAGE_FS_TOOLS} \
    ${IMAGE_KERNEL_DEPS} \
    ${IMAGE_ROOTFS_INSTALL_BASE_UTILS} \
    ${IMAGE_ROOTFS_INSTALL_CONNECTIVITY} \
    ${IMAGE_ROOTFS_INSTALL_ENAPTER_OSS_SOFTWARE} \
    ${IMAGE_ROOTFS_INSTALL_EXTENDED_UTILS} \
    ${IMAGE_ROOTFS_INSTALL_OS_SUPPORT} \
    ${IMAGE_ROOTFS_INSTALL_SYSTEM_DAEMONS} \
    "

# this breaks some stuff, like initramfs-framework installs rootfs sub-package by default
# NO_RECOMMENDATIONS = "1"
INIT_MANAGER = "systemd"
VIRTUAL-RUNTIME_dev_manager = "udev"
# busybox is already a default base-utils package
PREFERRED_PROVIDER_virtual/base-utils = "busybox"
VIRTUAL-RUNTIME_base-utils = "busybox"
VIRTUAL-RUNTIME_base-utils-hwclock = "util-linux-hwclock"
VIRTUAL-RUNTIME_syslog = ""
VIRTUAL-RUNTIME_base-utils-syslog = ""

PREFERRED_PROVIDER_virtual/kernel = "linux-yocto"
PREFERRED_VERSION_linux-yocto = "6.12.%"
KERNEL_MODULE_AUTOLOAD:append = " squashfs i2c-dev"

PREFERRED_VERSION_grub = "2.12"
PREFERRED_VERSION_grub-efi = "2.12"

RUSTVERSION = "1.79%"
GOVERSION = "1.25.5"

GO_LINKSHARED = ""

hostname_pn-base-files = ""

PACKAGECONFIG:remove:pn-systemd = "timesyncd networkd resolved nss-resolve userdb"
PACKAGECONFIG:append:pn-systemd = " pcre2"

PACKAGECONFIG:append:pn-rauc = " gpt service network streaming"

DISTRO_FEATURES = "acl ipv4 ipv6 largefile pam usbhost wifi xattr pci vfat seccomp modsign rauc"

MACHINE_FEATURES:remove = " \
    alsa \
    irda \
    pcmcia \
    phone \
    qvga \
    touchscreen \
    usbgadget \
    "

require conf/distro/include/security_flags.inc
