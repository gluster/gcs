#!/bin/bash

## This script sets up the environment to allow GCS deployments using kubespray and ansible

DEP_NOT_FOUND=()
function check_dep() {
  if ! which $1 &>/dev/null; then
    echo $1 not found
    DEP_NOT_FOUND+=($2)
    return 1
  fi
  return 0
}

check_dep ansible ansible
check_dep virtualenv python-virtualenv
if check_dep vagrant vagrant; then
  if ! (vagrant plugin list | grep -q vagrant-libvirt); then
    echo vagrant-libvirt not found
    DEP_NOT_FOUND+=(vagrant-libvirt)
  else
    cat <<EOF
vagrant and vagrant-libvirt were found.
For easier operation, ensure that libvirt has been configured to work without passwords.
Ref: https://developer.fedoraproject.org/tools/vagrant/vagrant-libvirt.html

EOF
  fi
fi

if [[ "${DEP_NOT_FOUND[@]}" != "" ]]; then
  echo -e "Please install the following packages before proceeding \t" ${DEP_NOT_FOUND[@]}
  exit 1
fi

## Ensure kubespray submodule is present
echo "Ensuring kubespray is present"
git submodule --quiet init
git submodule --quiet update

## Create a python virtualenv for kubespray requirements
### REQUIRES: python-virtualenv installed for you system
VENV="gcs-venv"
echo "Creating a python virtualenv $VENV"
virtualenv -q $VENV
. $VENV/bin/activate
echo "Installing requirements into $VENV"
pip install -q -r ./kubespray/requirements.txt
pip install -q jmespath
echo

cat <<EOF
Virtualenv $VENV has been created
The virtualenv needs to be activated before doing any operations. Operations may fail if virtualenv is not activated.

To activate the virutalenv, run:
\$ source $VENV/bin/activate
($VENV) \$

To deactivate an activated virtualenv, run:
($VENV) \$ deactivate
\$ 

Note: The virtualenv should be activated for each shell session individually.
EOF

