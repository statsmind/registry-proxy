#!/bin/bash

proxy_host=${1:-"registry.statsmind.com"}
echo "proxy_host: ${proxy_host}"

microk8s_certs_path=/var/snap/microk8s/current/args/certs.d

registries=(docker.io gcr.io ghci.io k8s.gcr.io nvcr.io quay.io registry.k8s.io)

for reg in ${registries[@]}; do
  echo "setup ${reg} hosts file"
  sudo mkdir -p ${microk8s_certs_path}/${reg} && sudo cat > ${microk8s_certs_path}/${reg}/hosts.toml <<EOF
[host."${proxy_host}"]
  capabilities = ["pull", "resolve"]
  skip_verify = true
EOF
done

if [ -f ${microk8s_certs_path}/_default/hosts.toml ]; then
  echo "remove _default hosts file"
  sudo mv ${microk8s_certs_path}/_default /tmp
fi

if [ -f ${microk8s_certs_path}/localhost:32000/hosts.toml ]; then
  echo "remove localhost:32000 hosts file"
  sudo mv ${microk8s_certs_path}/localhost:32000 /tmp
fi
