#!/bin/bash

if [ $# -ne 1 ]; then
    echo $0: usage: timer-aws-kinesis-it-test.sh camel-version
    exit 1
fi

camel_version=$1

cd terraform/
terraform init
terraform apply -auto-approve
cd ../

jbang run -Dcamel.jbang.version=$camel_version camel@apache/camel run timer-aws-kinesis.yaml &

sleep 10

variable=`jbang run -Dcamel.jbang.version=$camel_version camel@apache/camel get | tail -n +2` 
success=`echo $variable | cut -d' ' -f11`
fail=`echo $variable | cut -d' ' -f12`
echo $success $fail
if [[ $success == 5 && $fail == 0 ]] 
then 
    echo "Test Successful";
else
    echo "Test failed";
fi

jbang run -Dcamel.jbang.version=$camel_version camel@apache/camel stop timer-aws-kinesis

cd terraform/
terraform destroy -auto-approve
cd ../
