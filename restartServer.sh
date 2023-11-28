#!/bin/bash

_usage() {
    BUILD_ENV=Nonprod/Prod bash -x restartServer.sh
}

LT_NAME="GEMINIJENKINS${BUILD_ENV}Stack"

LT_ID=$(aws ec2 describe-launch-templates --launch-template-names ${LT_NAME} --query 'sort_by(LaunchTemplates, &CreateTime)[-1].[LaunchTemplateId]' --output text )

# Iterate  through autoscaling groups
asg_list=$(aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*]' --output json)
echo $asg_list | jq -c '.[]' | while read asg; do
   INDX_LT_ID=$(echo $asg | jq -r .LaunchTemplate.LaunchTemplateId)
   if [[ "$LT_ID" == $INDX_LT_ID ]]; then
      lt_instance_id=$(echo $asg | jq -r .Instances[].InstanceId)

      echo "Termianting EC2 instance [$lt_instance_id]"
      aws ec2 terminate-instances --instance-ids $lt_instance_id
   fi
done
