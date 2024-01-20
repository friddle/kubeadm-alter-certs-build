#!/bin/bash
git_tag=$(git rev-parse --abbrev-ref HEAD)
docker build --build-arg kubeadm_version=${git_tag} --network=host -t kubeadm_with_validate_100:${git_tag} .
docker run --rm --name=kubeadm_with_validate_100 -v $(pwd)/dist:/dists/ alert_kube:{git_tag} "cp /root/dist /dists/"
docker tag kubeadm_with_validate_100:${git_tag} friddle/kubeadm_with_validate_100y:${git_tag}
