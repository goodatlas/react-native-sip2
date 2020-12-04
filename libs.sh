#!/bin/bash

set -e

VERSION="2.9.4"
URL="https://github.com/goodatlas/react-native-sip2-builder/releases/download/${VERSION}/switch_android_pjsip_OPUS_16kHz_VBR.zip"
LOCK=".libs.lock"
DEST=".libs.zip"
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
	# Android
    curl -L --silent "${URL}" -o "${DEST}"
    unzip "${DEST}"
    rm -f "${DEST}"

	#files="android/src/main/java/one/telefon/sip2/PjSipRemoteVideoViewManager.java"
	#files+=" android/src/main/java/one/telefon/sip2/PjSipPreviewVideoViewManager.java"
	#for file in $files; do
	#	sed -i "s:import org.pjsip.pjsua2.MediaFormatVector://import org.pjsip.pjsua2.MediaFormatVector:g" $file
	#done

	echo "${VERSION}" > ${LOCK}
else
	echo "Android lib is already up-to-date"
fi


# iOS
VERSION="3.5.2"
URL="https://github.com/goodatlas/Vialer-pjsip-iOS/archive/${VERSION}.zip"
LOCK=".libs.ios.lock"
DEST=".libs.ios.zip"
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
	# iOS
	curl -L --silent "${URL}" -o "${DEST}"
	unzip "${DEST}"
	mkdir -p ios/VialerPJSIP.framework
	mv Vialer-pjsip-iOS-${VERSION}/VialerPJSIP.framework/Versions/Current/* ios/VialerPJSIP.framework
	wget "https://github.com/goodatlas/Vialer-pjsip-iOS/raw/develop/VialerPJSIP.framework/Versions/A/VialerPJSIP"
	mv VialerPJSIP ios/VialerPJSIP.framework
	rm -f "${DEST}"
	rm -rf Vialer-pjsip-iOS-${VERSION}

    echo "${VERSION}" > ${LOCK}
else
	echo "iOS lib is already up-to-date"
fi
