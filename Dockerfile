FROM ubuntu:latest
ADD https://storage.googleapis.com/kubernetes-release/release/v1.12.1/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN apt update && apt install -y vim vim-gocomplete make git openssl openssh-client bash curl ca-certificates
ENV GIMME_OS=linux GIMME_ARCH=amd64
ENV GIMME_GO_VERSION=1.11.1
ENV GOROOT=/root/.gimme/versions/go1.11.1.linux.amd64
ENV PATH=/root/.gimme/versions/go1.11.1.linux.amd64/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/go/bin
ENV GIMME_ENV=/root/.gimme/envs/go1.11.1.env
ENV GOPATH=/root/go


RUN set -x && \
    chmod +x /usr/local/bin/kubectl && \
    # Basic check it works.
    kubectl version --client && \
    eval "$(curl -sL https://raw.githubusercontent.com/travis-ci/gimme/master/gimme | bash)" && \
    go get -d -u github.com/golang/dep && \
    go get sigs.k8s.io/cluster-api sigs.k8s.io/cluster-api-provider-openstack || true && \
    cd $GOPATH/src/sigs.k8s.io/cluster-api-provider-openstack && make depend && make clusterctl
CMD ["sleep", "86500"]
