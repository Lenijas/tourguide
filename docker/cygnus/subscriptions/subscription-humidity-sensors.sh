#!/bin/bash
# subscription-humidity-sensors.sh
# Copyright(c) 2016 Bitergia
# Author: Alberto Martín <amartin@bitergia.com>
# MIT Licensed
#
# IDAS humidity sensors used in restaurants subscription

CYGNUS_HOST=$( getent hosts cygnus | sort -u | awk '{print $1}' )
CYGNUS_PORT=5050
CYGNUS_URL=http://${CYGNUS_HOST}:${CYGNUS_PORT}/notify
ORION_URL=http://${ORION_HOSTNAME}:${ORION_PORT}/v1/subscribeContext

cat <<EOF | curl ${ORION_URL} -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'Fiware-Service: tourguide' --header 'Fiware-ServicePath: /#' -d @-
{
    "entities": [
        {
            "type": "Restaurant",
            "isPattern": "false",
            "id": "0115206c51f60b48b77e4c937835795c33bb953f"
        }
    ],
    "attributes": [
        "relativeHumidity:kitchen",
        "relativeHumidity:dining"
    ],
    "reference": "${CYGNUS_URL}",
    "duration": "P1M",
    "notifyConditions": [
        {
            "type": "ONCHANGE",
            "condValues": [
                "relativeHumidity:kitchen",
                "relativeHumidity:dining"
            ]
        }
    ],
    "throttling": "PT1S"
}
EOF
