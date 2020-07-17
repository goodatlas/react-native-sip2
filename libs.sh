#!/bin/bash

set -e

VERSION="2.9.3"
URL="https://github.com/goodatlas/react-native-sip2-builder/releases/download/2.9.3/switch_android_pjsip_2p9_OPUS_16kHz.zip"
LOCK=".libs.lock"
DEST=".libs.tar.gz"
DOWNLOAD=true

if ! type "curl" > /dev/null; then
    echo "Missed curl dependency" >&2;
    exit 1;
fi
if ! type "tar" > /dev/null; then
    echo "Missed tar dependency" >&2;
    exit 1;
fi

if [ -f ${LOCK} ]; then
    CURRENT_VERSION=$(cat ${LOCK})

    if [ "${CURRENT_VERSION}" == "${VERSION}" ];then
        DOWNLOAD=false
    fi
fi

if [ "$DOWNLOAD" = true ]; then
    curl -L --silent "${URL}" -o "${DEST}"
    tar -xvf "${DEST}"
    rm -f "${DEST}"

	files="android/src/main/java/one/telefon/sip2/PjSipRemoteVideoViewManager.java"
	files+=" android/src/main/java/one/telefon/sip2/PjSipPreviewVideoViewManager.java"
	for file in $files; do
		sed -i "s:import org.pjsip.pjsua2.MediaFormatVector://import org.pjsip.pjsua2.MediaFormatVector:g" $file
	done

    echo "${VERSION}" > ${LOCK}
fi
