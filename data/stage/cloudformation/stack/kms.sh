#!/usr/bin/env bash

[ "$MOCK" == true ] && return

stack_name='GEMINIKMSStack'
technical_service='GEMINIKMS'

# Automated tests require parameters and tags to be sorted. To sort them in vim use:
#   SHIFT-V, select the JSON, ! jq 'sort_by(.ParameterKey)'

parameters() {
  cat <<EOF
[
  {
    "ParameterKey": "Envgroup",
    "ParameterValue": "$ENVGROUP"
  },
  {
    "ParameterKey": "IAMAppServerInstanceProfileARN",
    "ParameterValue": "$iam_app_server_instance_profile_arn"
  },
  {
    "ParameterKey": "IAMAutoScalingServiceRoleARN",
    "ParameterValue": "$iam_autoscaling_service_role_arn"
  },
  {
    "ParameterKey": "IAMDevOpsAppStackRoleARN",
    "ParameterValue": "$iam_devops_appstack_role_arn"
  },
  {
    "ParameterKey": "IAMElasticLoadBalancingServiceRoleARN",
    "ParameterValue": "$iam_elasticloadbalancing_service_role_arn"
  },
  {
    "ParameterKey": "IAMHIPMFAAdminRoleARN",
    "ParameterValue": "$iam_hip_mfa_admin_role_arn"
  },
  {
    "ParameterKey": "IAMInstanceProfileARN",
    "ParameterValue": "$iam_instance_profile_arn"
  },
  {
    "ParameterKey": "IAMProdAccountARN",
    "ParameterValue": "$iam_prod_account_arn"
  },
  {
    "ParameterKey": "IAMProvisioningRoleARN",
    "ParameterValue": "$iam_provisioning_role_arn"
  },
  {
    "ParameterKey": "KMSKeyAliasName",
    "ParameterValue": "$kms_key_alias_name"
  },
  {
    "ParameterKey": "KMSKeyPolicyId",
    "ParameterValue": "$kms_key_policy_id"
  }
]
EOF
}

validate_vars ENVGROUP

tags() {
  cat <<EOF
[
  {
    "Key": "Account",
    "Value": "$asset_name_uc"
  },
  {
    "Key": "ApplicationID",
    "Value": "$application_id"
  },
  {
    "Key": "CostCentre",
    "Value": "$cost_centre"
  },
  {
    "Key": "Environment",
    "Value": "$ENVGROUP"
  },
  {
    "Key": "Name",
    "Value": "$technical_service"
  },
  {
    "Key": "Owner",
    "Value": "$asset_name_uc"
  },
  {
    "Key": "TechnicalService",
    "Value": "$technical_service"
  }
]
EOF
}
