#!/usr/bin/env bash

[ "$MOCK" == true ] && return

validate_vars \
  ad_parent_domain \
  asset_name_uc \
  envgroup_first_uc

ad_common_names="$ad_parent_domain-Delegated-SRVGEMBATCH-SudoRoot" 
nopasswd_users=''
sudo_cn="$ad_parent_domain-Delegated-SRVGEMBATCH-SudoRoot" 
