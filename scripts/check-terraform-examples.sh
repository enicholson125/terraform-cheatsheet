#!/bin/bash
set -xe

pushd examples

function cleanup {
  rm -rf tmp_tf_dir
}

NO_MAIN_FILE_EXAMPLES="create_module.tf version_constraint_approx.tf version_constraint_combo.tf version_constraint_greater_than.tf version_constraint_strict.tf"

# TODO script currently has to be run from the top of the repo - fix
for filename in *.tf; do
    mkdir tmp_tf_dir
    trap cleanup EXIT

    if ! [[ ${NO_MAIN_FILE_EXAMPLES} =~ .*${filename}.* ]]; then
        cp terraform/main.tf tmp_tf_dir/
    fi
    mkdir tmp_tf_dir/example_module
    cp ../example_module/main.tf tmp_tf_dir/example_module/
    cp $filename tmp_tf_dir/
    pushd tmp_tf_dir
    tfswitch
    terraform init
    terraform fmt -check
    terraform validate
    terraform apply -auto-approve
    popd
    # Cleanup
    cleanup
done

popd
