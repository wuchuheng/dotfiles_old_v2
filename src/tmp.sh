#!/usr/bin/env bash

supportedOSList=(MacOS CentOS UbuntuOS)

TRUE=0
FALSE=1
currentOS='CentOaS'
isSupportedOS=${FALSE}
for os in "${supportedOSList[@]}"; do
    if [[ ${currentOS} == ${os} ]]; then
      isSupportedOS=${TRUE}
      break
    fi
done

echo ${isSupportedOS}
