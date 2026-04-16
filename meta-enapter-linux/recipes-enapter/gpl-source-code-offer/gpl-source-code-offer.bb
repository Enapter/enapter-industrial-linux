SUMMARY = "GPL Source Code Offer"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "file://GPL-SOURCE-CODE-OFFER.txt \
           file://LICENSE \
          "

do_install() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/GPL-SOURCE-CODE-OFFER.txt ${D}${sysconfdir}/GPL-SOURCE-CODE-OFFER.txt
}

FILES:${PN} += " \
    ${sysconfdir}/GPL-SOURCE-CODE-OFFER.txt \
"
