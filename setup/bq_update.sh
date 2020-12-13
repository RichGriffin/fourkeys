#!/bin/bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#!/bin/bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


schedule_bq_queries(){
  export PARENT_PROJECT=$(gcloud config get-value project)
  echo "Check BigQueryDataTransfer is enabled" 
  enabled=$(gcloud services list --enabled --filter name:bigquerydatatransfer.googleapis.com)

  while [[ "${enabled}" != *"bigquerydatatransfer.googleapis.com"* ]]
  do gcloud services enable bigquerydatatransfer.googleapis.com
  # Keep checking if it's enabled
  enabled=$(gcloud services list --enabled --filter name:bigquerydatatransfer.googleapis.com)
  done

  cd ../queries/
  # grpcio fails on local ok in cloud shell using these extra commands help with the install
  pip3 install --no-cache-dir --force-reinstall -Iv -r requirements.txt -q
  token=$(gcloud auth print-access-token)

  echo "Creating BigQuery scheduled queries for derived tables.."; set -x

    #refactored how auth is used nolonger need the auth token
    python3 schedule.py --query_file=changes.sql --table=changes
    python3 schedule.py --query_file=deployments.sql --table=deployments
    python3 schedule.py --query_file=incidents.sql --table=incidents

  set +x; echo
  cd ${DIR}
}

schedule_bq_queries
