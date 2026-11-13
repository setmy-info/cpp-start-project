#!/bin/sh
# SMI_STAGE is set by smi-incoming-deploy: published, or draft for the draft directory.
echo "smi-example-config installed for the ${SMI_STAGE:-published} stage"
