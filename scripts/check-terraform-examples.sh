#!/bin/bash
set -xe

pushd examples

function cleanup {
  rm -rf tmp_tf_dir
}

NO_MAIN_FILE_EXAMPLES="create_module.tf"

# TODO script currently assumes it is being run from the top of the repo - fix
for filename in *.tf; do
    mkdir tmp_tf_dir
    trap cleanup EXIT

    if ! [[ $NO_MAIN_FILE_EXAMPLES =~ .*${filename}.* ]]; then
        cp terraform/main.tf tmp_tf_dir/
    fi
    cp $filename tmp_tf_dir/
    terraform -chdir=tmp_tf_dir init
    terraform -chdir=tmp_tf_dir fmt -check
    terraform -chdir=tmp_tf_dir validate
    terraform -chdir=tmp_tf_dir apply -auto-approve
    # Cleanup
    cleanup
done

popd
