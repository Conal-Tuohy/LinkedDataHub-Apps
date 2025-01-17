#!/bin/bash

[ -z "$SCRIPT_ROOT" ] && echo "Need to set SCRIPT_ROOT" && exit 1;

if [ "$#" -ne 3 ] && [ "$#" -ne 4 ]; then
  echo "Usage:   $0" '$base $cert_pem_file $cert_password [$request_base]' >&2
  echo "Example: $0" 'https://localhost:4443/demo/skos/ ../../../../../certs/martynas.stage.localhost.pem Password' >&2
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

pushd . && cd "$SCRIPT_ROOT"/admin/model

./create-class.sh \
-b "${base}admin/" \
-f "$cert_pem_file" \
-p "$cert_password" \
--uri "${base}ns/domain#Concept" \
--label "Concept" \
--slug concept \
--constructor "${base}ns/domain#ConstructConcept" \
--sub-class-of "${base}ns/domain#TopicOfConceptItem" \
--path "{isPrimaryTopicOf.slug}/" \
--fragment "this" \
--constraint "${base}ns/domain#MissingPrefLabel" \
"${request_base}admin/model/classes/"

./create-class.sh \
-b "${base}admin/" \
-f "$cert_pem_file" \
-p "$cert_password" \
--uri "${base}ns/domain#ConceptItem" \
--label "Concept item" \
--slug concept-item \
--sub-class-of "${base}ns/domain/default#Item" \
--sub-class-of "${base}ns/domain#ItemOfConceptContainer" \
"${request_base}admin/model/classes/"

./create-class.sh \
-b "${base}admin/" \
-f "$cert_pem_file" \
-p "$cert_password" \
--uri "${base}ns/domain#ConceptScheme" \
--label "Concept scheme" \
--slug concept-scheme \
--constructor "${base}ns/domain#ConstructConceptScheme" \
--sub-class-of "${base}ns/domain#TopicOfConceptSchemeItem" \
--path "{isPrimaryTopicOf.slug}/" \
--fragment "this" \
--constraint "${base}admin/ns#MissingTitle" \
"${request_base}admin/model/classes/"

./create-class.sh \
-b "${base}admin/" \
-f "$cert_pem_file" \
-p "$cert_password" \
--uri "${base}ns/domain#ConceptSchemeItem" \
--label "Concept scheme item" \
--slug concept-scheme-item \
--sub-class-of "${base}ns/domain/default#Item" \
--sub-class-of "${base}ns/domain#ItemOfConceptSchemeContainer" \
"${request_base}admin/model/classes/"

popd