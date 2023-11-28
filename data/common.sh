#!/usr/bin/env bash

if [ "$MOCK" == "true" ] ; then
  case "$ARGS" in
    "curl --silent $meta_data/network/interfaces/macs/") echo '00:11:22:aa:bb:cc' ;;
    "curl --silent $meta_data/network/interfaces/macs/$mac/subnet-id") echo 'subnet-111111111111111111' ;;
    "curl --silent $meta_data/network/interfaces/macs/$mac/security-group-ids") echo 'sg-111111111111111111' ;;
    'aws ssm get-parameter --name /asset/artifactory_api_key --with-decryption --query Parameter.Value --output text') echo 'myartifactorykey' ;;
    *) return ;;
  esac
  mock_found='true'
  return
fi

valid_ami_stacks='buildbox|jenkins' # stacks with pre-baked AMIs.
valid_stacks='batch|batch_efs|fileserver|cw|kms|s3|buildbox|jenkins' # all stacks.
#valid_stacks='kms|s3|buildbox|jenkins' # all stacks.
valid_envgroups='nonprod|prod'
#valid_nonprods='dev'
valid_nonprods='dev|sit'
valid_prods='prod'
#valid_environments='dev|prod' # always use ENVGROUP == prod for prod environment.
valid_environments='dev|prod|sit' # always use ENVGROUP == prod for prod environment.
#valid_stages='tdm|packer|cloudformation'
valid_stages='packer|cloudformation'

PATH="/usr/local/bin:$PATH"
AWS_DEFAULT_REGION='ap-southeast-2'
export PATH AWS_DEFAULT_REGION

asset_name_lc='gemini' # Asset name identifier lower case
asset_name_uc='GEMINI' # Asset name identifier upper case
asset_name_short_lc='gem'
host_name_assetname="$asset_name_short_lc"

application_id='ML0095' # Application Id Tag
app_category='D'
#support_group='mlcau_mlc.bet.wealth.work.management@mlc.com.au'
support_group='WorkManagementProductionSupport'

tag_power_mgt="MBH"
tag_backup_optout="Yes"
tag_app_category='D'

envgroup_first_uc=$(sed -E 's/(.)/\u\1/' <<< "$ENVGROUP")
environment_first_uc=$(sed -E 's/(.)/\u\1/' <<< "$ENVIRONMENT")

meta_data="http://169.254.169.254/latest/meta-data"
mac=$(curl --silent "$meta_data/network/interfaces/macs/")
instance_subnet_id=$(curl --silent "$meta_data/network/interfaces/macs/$mac/subnet-id")
instance_security_group_ids=$(curl --silent "$meta_data/network/interfaces/macs/$mac/security-group-ids")

remote_access_cidr='10.0.0.0/8'

cost_centre='V_Gemini'

#kms_key_policy_id="/$asset_name_lc"
#kms_key_alias_name="alias/$asset_name_lc"
kms_stack_name="${asset_name_uc}KMSStack"
export_name="$asset_name_lc"

stack_lc="$STACK"
stack_uc=$(sed 's/.*/\U&/; s/_//g' <<< "$STACK")

technical_service="$stack_uc"
key_pair_name="${asset_name_uc}${stack_uc}${envgroup_first_uc}"

s3_bucket_name="$asset_name_lc-$ENVGROUP-3118" # 3118 a random string to ensure global uniqueness.
s3_log_bucket_name="$asset_name_lc-$ENVGROUP-3867"

#iam_prod_account_arn='638918978875' # ARN of Production root account - should be arn:aws:iam:: + AWS Account ID of Prod + :root
iam_prod_account_arn='arn:aws:iam::937709052626:root'

date=$(date +%Y%m%d%H%M%S)

# Extra.
image_name="$asset_name_uc-$stack_uc"

performance_mode='generalPurpose' # can also be set to maxIO
throughput_mode='bursting' # can also be set to provisioned additional paramater ProvisionedThroughputInMibps optional in CF
