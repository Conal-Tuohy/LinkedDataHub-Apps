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

#query=$(
#./create-select.sh  \
#-b "$base" \
#-f "$cert_pem_file" \
#-p "$cert_password" \
#--title "Molecule logp" \
#--query-file "${pwd}/queries/chembl/molecule-logp.rq" \
#--service "${base}/services/chembl/#this" \
# "${request_base}queries/"
#)
#
#./create-result-set-chart.sh \
#-b "$base" \
#-f "$cert_pem_file" \
#-p "$cert_password" \
#--title "Partition coefficients" \
#--query "${query}#this" \
#--chart-type https://w3id.org/atomgraph/client#BarChart \
#--category-var-name "mol_name" \
#--series-var-name "logp_val" \
# "${request_base}charts/"

query=$(
./create-select.sh  \
-b "$base" \
-f "$cert_pem_file" \
-p "$cert_password" \
--title "Protein counts by organism" \
--query-file "${pwd}/queries/uniprot/select-protein-count-by-organism.rq" \
--service "${base}services/uniprot-enzymes/#this" \
"${request_base}queries/"
)

./create-result-set-chart.sh \
-b "$base" \
-f "$cert_pem_file" \
-p "$cert_password" \
--title "Protein counts by organism" \
--query "${query}#this" \
--chart-type https://w3id.org/atomgraph/client#BarChart \
--category-var-name "name" \
--series-var-name "count" \
"${request_base}charts/"

popd
