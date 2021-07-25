#!/bin/bash
set -e

pushd examples

function cleanup {
  rm -rf tmp_tf_dir
}

# TODO script currently assumes it is being run from the top of the repo - fix
for filename in *.tf; do
    mkdir tmp_tf_dir
    trap cleanup EXIT

    cp terraform/main.tf tmp_tf_dir/
    cp $filename tmp_tf_dir/
    terraform -chdir=tmp_tf_dir init
    terraform -chdir=tmp_tf_dir fmt -check
    terraform -chdir=tmp_tf_dir validate
    terraform -chdir=tmp_tf_dir apply -auto-approve
    # Cleanup
    cleanup
done

popd
