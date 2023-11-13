kli saidify --file ./acdc/schema/ns-aid-auth-rules-schema.json --label "\$id"
kli saidify --file ./acdc/schema/ns-aid-auth-attr-schema.json --label "\$id"
# manually add rules SAID and attribute SAID to the ns-aid-auth-schema.json
read -p "Hit enter after you have added the SAIDs to the auth-schema.json"
kli saidify --file ./acdc/schema/ns-aid-auth-schema.json --label "\$id"

kli saidify --file ./acdc/schema/examples/ns-aid-auth-rules.json --label "d"
kli saidify --file ./acdc/schema/examples/ns-aid-auth-attr.json --label "d"
# manually add rules example SAID and attribute example SAID to the ns-aid-auth.json
read -p "Hit enter after you have added the SAIDs to the auth.json"
kli saidify --file ./acdc/schema/examples/ns-aid-auth-schema.json --label "d"