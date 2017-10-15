#!/bin/bash
if [ $(curl -k -XGET -H "Authorization: Bearer $KONTENA_TOKEN" -H "Accept: application/json" -H "Content-Type: application/json" $STACK_ENDPOINT | jq -r '.services | .[0].image') != "jatula/hyperspace:$IMAGE_TAG" ]; then exit 1; fi