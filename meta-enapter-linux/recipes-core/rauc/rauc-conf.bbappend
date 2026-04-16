do_install:prepend() {
    cp ${RAUC_KEYRING} ${WORKDIR}/${RAUC_KEYRING_FILE}
}
