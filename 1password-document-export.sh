#!/bin/bash
echo ===============================
echo = 1Password Document Exporter =
echo ===============================

# Get a list of documents from all vaults you have access to
DOCUMENTS=$(op list documents | jq -c '.[] | {uuid: .uuid, title: .overview.title, vault: .vaultUuid}')

# Variables used to provide simple progress status during export
NUM_OF_DOCUMENTS=$(op list documents | jq '. | length')
COUNTER=1
echo $NUM_OF_DOCUMENTS documents to export...

# Export every document item to the correct subfolder
# One subfolder will be created for each source vault with Document items to export
LAST_CHECKED_VAULT=''
VAULT_NAME=''
IFS=$'\n'
for document in $DOCUMENTS
do
    UUID=$(jq -r '.uuid' <<< "$document")
    TITLE=$(jq -r '.title' <<< "$document")
    VAULT_UUID=$(jq -r '.vault' <<< "$document")
    echo [$COUNTER/$NUM_OF_DOCUMENTS] Exporting document $TITLE
    if [[ $VAULT_UUID != $LAST_CHECKED_VAULT ]]; then # New vault: only fetch vault name once per vault
        VAULT_NAME=$(op list vaults | jq -r --arg VAULT_UUID "$VAULT_UUID" '.[] | select(.uuid==$VAULT_UUID) | .name')
        LAST_CHECKED_VAULT=$VAULT_UUID
        mkdir -p /Users/$(whoami)/Downloads/1PasswordDocuments/$VAULT_NAME-$VAULT_UUID
    fi
    op get document $UUID --output /Users/$(whoami)/Downloads/1PasswordDocuments/$VAULT_NAME-$VAULT_UUID/$TITLE
    COUNTER=$[$COUNTER +1]
done
