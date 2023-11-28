#!/bin/bash

_usage() {
    BUILD_ENV=Nonprod/Prod bash -x updateLaunchTemplate.sh
}

current_time=$(date "+%Y-%m-%d %H:%M:%S")
LT_DESC="Jenkins Bake - $current_time"

LT_NAME="GEMINIJENKINS${BUILD_ENV}Stack"
echo "Launch Template Name : $LT_NAME"

Account_ID=$(aws sts get-caller-identity --query Account --output text)
echo "Account ID is : $Account_ID"

JENKINS_AMI=$(aws ec2 describe-images --owners ${Account_ID} --filters "Name=name, Values=GEMINI-JENKINS-*" --query 'sort_by(Images, &CreationDate)[-1].[ImageId]' --output text)
echo "Jenkins - Latest Baked AMI ID : $JENKINS_AMI"

LT_ID=$(aws ec2 describe-launch-templates --launch-template-names ${LT_NAME} --query 'sort_by(LaunchTemplates, &CreateTime)[-1].[LaunchTemplateId]' --output text )
echo "Jenkins - Launch Template ID : $LT_ID"

LT_DEF_VERSION=$(aws ec2 describe-launch-templates --launch-template-id ${LT_ID} | jq -r .LaunchTemplates[].DefaultVersionNumber)
echo "Launch Template Default Version # : $LT_DEF_VERSION"

LT_AMI=$(aws ec2 describe-launch-template-versions --launch-template-id ${LT_ID} --versions ${LT_DEF_VERSION} | jq -r .LaunchTemplateVersions[].LaunchTemplateData.ImageId)
echo "Current Launch Template AMI : $LT_AMI"

if [[ "$LT_AMI" != $JENKINS_AMI ]]; then
   LT_DATA=$(cat <<EOF
{
  "ImageId":"$JENKINS_AMI"
}
EOF
)

   NEW_LT_VERSION=$(aws ec2 create-launch-template-version --launch-template-id ${LT_ID} --source-version ${LT_DEF_VERSION}  --version-description "${LT_DESC}" --launch-template-data "$LT_DATA" --output json)
   echo "Created new Launch Template Version"
   NEW_LT_VERSION_NUM=$(echo $NEW_LT_VERSION | jq .LaunchTemplateVersion.VersionNumber)
   aws ec2 modify-launch-template --launch-template-id ${LT_ID} --default-version $NEW_LT_VERSION_NUM
   echo "Set new default version # : $NEW_LT_VERSION_NUM"

else
   echo "Launch Template AMI is the same as the latest Jenkins AMI. No update required"
fi
