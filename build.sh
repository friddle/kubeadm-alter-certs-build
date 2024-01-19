#!/bin/bash
git_tag=$(git rev-parse --abbrev-ref HEAD)
docker build --build-arg kubeadm_version=${git_tag} -t alert_kube:${git_tag} .
docker run --rm --name=alert_kube -v $(pwd)/dist:/dists/ alert_kube:{git_tag} "cp /root/dist /dists/"
