#!/bin/bash

#!/bin/bash

kli init --name controller --salt 0ACDEyMzQ1Njc4OWxtbm9aBc --nopasscode
kli incept --name controller --alias controller

kli vc registry incept --name controller --alias controller --registry-name authId

kli saidify --file ../ns-aid-auth-rules-schema.json --label "\$id"
kli saidify --file ../ns-aid-auth-attr-schema.json --label "\$id"
# manually add rules SAID and attribute SAID to the ns-aid-auth-schema.json
read -p "Hit enter after you have added the SAIDs to the auth-schema.json"
kli saidify --file ../ns-aid-auth-schema.json --label "\$id"

kli saidify --file ./ns-aid-auth-rules.json --label "d"
kli saidify --file ./ns-aid-auth-attr.json --label "d"

# manually add rules example SAID and attribute example SAID to the ns-aid-auth.json
# read -p "Hit enter after you have added the SAIDs to the auth.json"
# kli saidify --file ./ns-aid-auth.json --label "d"

kli vc create --name controller --alias controller --registry-name authId --schema EPi_tVS3zDN4wo-T3NQb5pUtdeup98yoJ_hrNReD86xO --data ../ns-aid-auth-attr.json
SAID=$(kli vc list --name controller --alias controller --issued --said --schema EPi_tVS3zDN4wo-T3NQb5pUtdeup98yoJ_hrNReD86xO)

# kli vc create --name controller --alias controller --registry-name vLEI --schema EBfdlu8R27Fbx-ehrqwImnK-8Cm79sqbAQ4MmvEAYqao --recipient ELjSFdrTdCebJlmvbFNX9-TLhR2PO0_60al1kQp5_e6k --data @${KERI_DEMO_SCRIPT_DIR}/data/credential-data.json
# SAID=$(kli vc list --name controller --alias controller --issued --said --schema EBfdlu8R27Fbx-ehrqwImnK-8Cm79sqbAQ4MmvEAYqao)

# kli ipex grant --name controller --alias controller --said "${SAID}" --recipient ELjSFdrTdCebJlmvbFNX9-TLhR2PO0_60al1kQp5_e6k

# echo "Checking holder for grant messages..."
# GRANT=$(kli ipex list --name holder --alias holder --poll --said)

# echo "Admitting credential from grant ${GRANT}"
# kli ipex admit --name holder --alias holder --said "${GRANT}"

kli vc list --name controller --alias controller

kli vc revoke --name controller --alias controller --registry-name authId --said "${SAID}"
sleep 2
kli vc list --name controller --alias controller --poll