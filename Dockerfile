FROM alpine as src
ARG kubeadm_version 1.25.0
WORKDIR /src/
RUN mkdir /src/kubernetes
RUN wget https://github.com/kubernetes/kubernetes/archive/v$kubeadm_version.tar.gz -O kubernetes.tar.gz
RUN tar -zxvf kubernetes.tar.gz --strip-components=1 -C ./kubernetes/
RUN sed -i 's#duration365d.*10#duration365d*100#g' ./kubernetes/staging/src/k8s.io/client-go/util/cert/cert.go
RUN sed -i 's#time.Hour.*365#time.Hour*24*365*100#g' ./kubernetes/cmd/kubeadm/app/constants/constants.go

FROM  registry.aliyuncs.com/google_containers/kube-cross:v1.19-1 as builder
COPY --from=/src/kubernetes /root/kubernetes/
WORKDIR /root/kubernetes
RUN make all WHAT=cmd/kubeadm GOFLAGS=-v
RUN make all WHAT=cmd/kubelet GOFLAGS=-v
RUN make all WHAT=cmd/kubectl GOFLAGS=-v
RUN mkdir /dist/
RUN cp _output/local/bin/linux/amd64/* /dist/

FROM alpline
RUN mkdir /root/dist/
COPY --from=/dist/ /root/dist/
RUN chmod +x /root/dist/
RUN /root/dist/kubeadm version
ENTRYPOINT /bin/sh
