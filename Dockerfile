FROM alpine:latest as src
ARG kubeadm_version v1.25.0
WORKDIR /src/
RUN mkdir /src/kubernetes
ENV kubeadm_version $kubeadm_version
ENV https_proxy ${https_proxy}
RUN apk add --no-cache curl
RUN wget https://github.com/kubernetes/kubernetes/archive/${kubeadm_version}.tar.gz -O kubernetes.tar.gz
RUN tar -zxvf kubernetes.tar.gz --strip-components=1 -C ./kubernetes/
RUN sed -i 's#duration365d*10#duration365d*100#g' ./kubernetes/staging/src/k8s.io/client-go/util/cert/cert.go
RUN sed -i 's#time.Hour*24*365#time.Hour*24*365*100#g' ./kubernetes/cmd/kubeadm/app/constants/constants.go

FROM  almalinux:9.3-20231124 as builder
COPY --from=src /src/kubernetes /root/kubernetes/
ARG go_version 1.19
WORKDIR /root/
RUN  yum groupinstall "Development Tools" -y #gcc, make etc.
RUN  yum install rsync jq wget -y
ENV https_proxy ${https_proxy}
RUN  wget https://dl.google.com/go/go1.19.linux-amd64.tar.gz -O  go.tar.gz && tar xzvf go.tar.gz -C /usr/local
ENV GOROOT /usr/local/go
ENV GOPATH /usr/local/gopath
ENV PATH  "$PATH:$GOROOT/bin"

WORKDIR /root/kubernetes/
RUN make all WHAT=cmd/kubeadm GOFLAGS=-v
RUN make all WHAT=cmd/kubelet GOFLAGS=-v
RUN make all WHAT=cmd/kubectl GOFLAGS=-v
RUN mkdir /dist/
RUN cp _output/local/bin/linux/amd64/* /dist/

FROM alpine
RUN mkdir /root/dist/
COPY --from=builder /dist/ /root/dist/
RUN chmod +x /root/dist/
RUN /root/dist/kubeadm version
ENTRYPOINT /bin/sh

