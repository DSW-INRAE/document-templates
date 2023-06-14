#!/bin/bash

TEMPLATE_PATH="../document-templates/document-template-moisa-cirad"

if ! command -v dsw-tdk &>/dev/null; then
    echo "Installez dsw-tdk (pip install dsw-tdk)"
    exit 1
fi

(cd $TEMPLATE_PATH && dsw-tdk package -o template.zip -f)
