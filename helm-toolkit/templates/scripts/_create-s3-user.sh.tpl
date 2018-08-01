{{/*
Copyright 2017 The Openstack-Helm Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/}}

{{- define "helm-toolkit.scripts.create_s3_user" }}
#!/bin/bash

set -ex

function create_admin_user () {
  radosgw-admin user create \
    --uid=${S3_ADMIN_USERNAME} \
    --display-name=${S3_ADMIN_USERNAME}

  radosgw-admin caps add \
      --uid=${S3_ADMIN_USERNAME} \
      --caps={{ .Values.conf.ceph.radosgw.s3_admin_caps | quote }}

  radosgw-admin key create \
    --uid=${S3_ADMIN_USERNAME} \
    --key-type=s3 \
    --access-key ${S3_ADMIN_ACCESS_KEY} \
    --secret-key ${S3_ADMIN_SECRET_KEY}
}

function create_s3_user () {
  radosgw-admin user create \
    --uid=${S3_USERNAME} \
    --display-name=${S3_USERNAME}

  radosgw-admin key create \
    --uid=${S3_USERNAME} \
    --key-type=s3 \
    --access-key ${S3_ACCESS_KEY} \
    --secret-key ${S3_SECRET_KEY}
}

radosgw-admin user stats --uid=${S3_ADMIN_USERNAME} || \
  create_admin_user

radosgw-admin user stats --uid=${S3_USERNAME} || \
  create_s3_user
{{- end }}
