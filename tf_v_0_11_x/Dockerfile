FROM alpine:3.7

ENV GOPATH /go

ENV GOLANG_VERSION 1.9.4
ENV GOLANG_SRC_URL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
ENV GOLANG_SRC_SHA256 0573a8df33168977185aa44173305e5a0450f55213600e94541604b75d46dc06

ENV TERRAFORM_VERSION 0.11.8
ENV TERRAFORM_IBMCLOUD_VERSION v0.23.0

ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN set -ex \
    && apk update \
    && apk add --no-cache ca-certificates  \
    && apk add --no-cache --virtual .build-deps \
    && apk add bash gcc musl-dev openssl zip make bash git go curl \
    && apk add jq \
    && curl -s https://raw.githubusercontent.com/docker-library/golang/221ee92559f2963c1fe55646d3516f5b8f4c91a4/1.9/alpine3.7/no-pic.patch -o /no-pic.patch \
    && cat /no-pic.patch \
    && export GOROOT_BOOTSTRAP="$(go env GOROOT)" \
    && wget -q "$GOLANG_SRC_URL" -O golang.tar.gz \
    && echo "$GOLANG_SRC_SHA256  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz \
    && cd /usr/local/go/src \
    && patch -p2 -i /no-pic.patch \
    && ./make.bash \
    && rm -rf /*.patch \
    && apk del .build-deps \
    && apk add jq \
    && apk add openssh

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

WORKDIR $GOPATH/bin

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN chmod +x terraform

RUN rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

WORKDIR /root

RUN echo $' providers { \n \
    ibm = "/go/bin/terraform-provider-ibm_${TERRAFORM_IBMCLOUD_VERSION}" \n \
    }' > /root/.terraformrc

WORKDIR $GOPATH/bin

RUN wget https://github.com/IBM-Cloud/terraform-provider-ibm/releases/download/${TERRAFORM_IBMCLOUD_VERSION}/linux_amd64.zip
RUN unzip linux_amd64.zip
RUN chmod +x terraform-provider-ibm_${TERRAFORM_IBMCLOUD_VERSION}


################################################################################################
# Get Kubectl CLI
# Reference: https://kubernetes.io/docs/tasks/tools/install-kubectl/
################################################################################################
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
RUN curl -fsSL https://plugins.cloud.ibm.com/install/linux | sh

################################################################################################
# Get calicoctl CLI
# Reference: https://docs.projectcalico.org/v3.5/usage/calicoctl/install
################################################################################################
RUN curl -O -L  https://github.com/projectcalico/calicoctl/releases/download/v3.5.8/calicoctl
RUN chmod +x calicoctl
RUN mv ./calicoctl /usr/local/bin/calicoctl

COPY . $GOPATH/bin/infrastructure-code