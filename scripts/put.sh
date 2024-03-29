#!/bin/bash

#définition des paramètres (à changer selon le template à envoyer)
DSW_API=http://localhost:3000
DSW_USERNAME=albert.einstein@example.com
DSW_PASSWORD=password
TEMPLATE_PATH="../document-templates/document-template-moisa-cirad"
PROJECT_UUUID=9fb99155-7a3f-4ada-9468-805d4079652a
FORMAT_UUUID=f3a904e4-9468-4605-99ca-a86155ce8f69 # l'id du format à tester (HTML, CSV, DOCX...), il se trouve dans template.json
# test : 3009fe7e-4df5-4281-813a-a89980e874a6
# docx-fr : f3a904e4-9468-4605-99ca-a86155ce8f69
if ! command -v dsw-tdk &>/dev/null; then
    echo "Installez dsw-tdk (pip install dsw-tdk)"
    exit 1
fi

#récupération du token d'identification
URL_TOKEN=$DSW_API/tokens
BODY_TOKEN=\{\"email\":\"$DSW_USERNAME\",\"password\":\"$DSW_PASSWORD\"\}
TOKEN=$(curl --request POST -sL \
     --url $URL_TOKEN\
     -H "Content-Type: application/json"\
     -d $BODY_TOKEN\
      | jq '.token')
TOKEN=Bearer\ "${TOKEN//\"}"

#définition de l'id complet du template
templateID=$(cat $TEMPLATE_PATH/template.json | jq '.organizationId'):$(cat $TEMPLATE_PATH/template.json | jq '.templateId'):$(cat $TEMPLATE_PATH/template.json | jq '.version')
templateID="${templateID//\"}" # je retire les "

# # je supprime le document déjà existant
# URL_DELETE_TEMPLATE=$(cat lastDocument)
# URL_DELETE_TEMPLATE=$DSW_API/documents/"${URL_DELETE_TEMPLATE//\"}"
# echo $URL_DELETE_TEMPLATE
# curl --request DELETE -sL \
#      --url "$URL_DELETE_TEMPLATE"\
#      -H "Content-Type: application/json"\
#      -H "Authorization: $TOKEN"

# je supprime le template déjà existant
URL_DELETE_TEMPLATE=$DSW_API/document-templates/$templateID
curl --request DELETE -sL \
     --url "$URL_DELETE_TEMPLATE"\
     -H "Content-Type: application/json"\
     -H "Authorization: $TOKEN"

# j'envoie le template au serveur
dsw-tdk put $TEMPLATE_PATH\
  --api-server $DSW_API\
  --username $DSW_USERNAME\
  --password $DSW_PASSWORD

# je publie le template
# URL_PUBLISH=$DSW_API/document-template-drafts/$templateID
# DATA_PUBLISH=\{${$(cat $TEMPLATE_PATH/template.json):1:-1},\"phase\":\"ReleasedDocumentTemplatePhase\"\,\"readme\":\"\"\}
# curl --request PUT -sL \
#      --url "$URL_PUBLISH"\
#      -H "Content-Type: application/json"\
#      -H "Authorization: $TOKEN"\
#      -d $DATA_PUBLISH > /dev/null

# # j'exporte le projet
# URL_EXPORT=$DSW_API/documents
# BODY_EXPORT=\{\"name\":\"ExportPourTests\",\"questionnaireUuid\":\"$PROJECT_UUUID\",\"documentTemplateId\":\"$templateID\",\"formatUuid\":\"$FORMAT_UUUID\",\"questionnaireEventUuid\":null\}
# curl --request POST -sL \
#      --url $URL_EXPORT\
#      -H "Content-Type: application/json"\
#      -H "Authorization: $TOKEN"\
#      -d $BODY_EXPORT\
#      |\
#      jq '.uuid'\
#      > lastDocument
#
