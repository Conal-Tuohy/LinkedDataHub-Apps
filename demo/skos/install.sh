#!/bin/bash

if [ "$#" -ne 3 ] && [ "$#" -ne 4 ]; then
  echo "Usage:   $0" '$base $cert_pem_file $cert_password [$request_base]' >&2
  echo "Example: $0" 'https://localhost:4443/ ../../../LinkedDataHub/certs/owner.p12.pem Password' >&2
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

pwd="$(realpath -s "$PWD")"

pushd .

printf "\n### Creating authorization to make the app public\n\n"

"$SCRIPT_ROOT"/admin/acl/make-public.sh -b "$base" -f "$cert_pem_file" -p "$cert_password" --request-base "$request_base"

printf "\n### Creating authorizations\n\n"

cd admin/acl

./create-authorizations.sh "$base" "$cert_pem_file" "$cert_password" "$request_base"

cd ..

cd model

printf "\n### Creating constructor queries\n\n"

./create-constructors.sh "$base" "$cert_pem_file" "$cert_password" "$request_base"

printf "\n### Creating classes\n\n"

./create-classes.sh "$base" "$cert_pem_file" "$cert_password" "$request_base"

printf "\n### Creating constraints\n\n"

./create-constraints.sh "$base" "$cert_pem_file" "$cert_password" "$request_base"

printf "\n### Creating restrictions\n\n"

./create-restrictions.sh "$base" "$cert_pem_file" "$cert_password" "$request_base"

cd ..

cd sitemap

printf "\n### Creating template queries\n\n"

./create-queries.sh "$base" "$cert_pem_file" "$cert_password" "$request_base"

printf "\n### Creating templates\n\n"

./create-templates.sh "$base" "$cert_pem_file" "$cert_password" "$request_base"

popd

pushd . && cd ./admin

printf "\n### Clearing ontologies\n\n"

./clear-ontologies.sh "$base" "$cert_pem_file" "$cert_password" "$request_base"

popd

printf "\n### Uploading files\n\n"

find "${pwd}/files" -type f -exec ./upload-file.sh "$base" "$cert_pem_file" "$cert_password" "$pwd" {} "$request_base" \;

printf "\n### Creating containers\n\n"

./create-containers.sh "$base" "$cert_pem_file" "$cert_password" "$request_base"

printf "\n### Updating documents\n\n"

./update-documents.sh "$base" "$cert_pem_file" "$cert_password" "$request_base"

printf "\n### Importing SKOS vocabulary\n\n"

./import-rdf.sh "$base" "$cert_pem_file" "$cert_password" "$request_base"
