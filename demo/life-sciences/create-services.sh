#!/bin/bash

[ -z "$SCRIPT_ROOT" ] && echo "Need to set SCRIPT_ROOT" && exit 1;

if [ "$#" -ne 3 ] && [ "$#" -ne 4 ]; then
  echo "Usage:   $0" '$base $cert_pem_file $cert_password [$request_base]' >&2
  echo "Example: $0" 'https://linkeddatahub.com/atomgraph/app/ ../../../certs/martynas.localhost.pem Password' >&2
  echo "Note: special characters such as $ need to be escaped in passwords!" >&2
  exit 1
fi

base="$1"
cert_pem_file=$(realpath -s "$2")
cert_password="$3"

if [ -n "$4" ]; then
    request_base="$4"
else
    request_base="$base"
fi

pwd=$(realpath -s $PWD)

pushd . && cd "$SCRIPT_ROOT"

#./create-generic-service.sh \
#-b "$base" \
#-f "$cert_pem_file" \
#-p "$cert_password" \
#--title "ChEMBL" \
#--endpoint https://www.ebi.ac.uk/rdf/services/sparql \
#--slug "chembl" \
# "${request_base}services/"

./create-dydra-service.sh \
-b "$base" \
-f "$cert_pem_file" \
-p "$cert_password" \
--title "Uniprot enzymes" \
--repository https://atomgraph.dydra.com/life-sciences/uniprot-enzymes/ \
--auth-token "zO1m7oDVRXgAc0nO9Twx" \
--slug "uniprot-enzymes" \
"${request_base}services/"

popd
