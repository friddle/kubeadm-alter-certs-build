#!/bin/bash
set -x
echo $pwd

git_tag=$(git rev-parse --abbrev-ref HEAD)
#docker build --build-arg kubeadm_version=${git_tag} --build-arg https_proxy=${https_proxy} --network=host -t kubeadm_with_cert_100y:${git_tag} .
touch dist/dist/kubeadm
#docker run --rm --name=kubeadm_with_certs_100y -v $(pwd)/dist:/dists/ --entrypoint=/bin/cp kubeadm_with_cert_100y:${git_tag} -r /root/dist/ /dists/
# docker tag kubeadm_with_cert_100y:${git_tag} friddle/kubeadm_with_certs:${git_tag}
# docker push friddle/kubeadm_with_certs:${git_tag}
