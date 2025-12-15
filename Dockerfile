FROM registry.access.redhat.com/ubi9/ubi-minimal
LABEL maintainer Taku Izumi <admin@orz-style.com>

ENV CLI53_BASE_URL="https://github.com/barnybug/cli53/releases/download"
ENV CLI53_VERSION='0.8.22'
ENV CLI53_NAME="cli53-linux-amd64"
ENV CLI53_URL="${CLI53_BASE_URL}/${CLI53_VERSION}/${CLI53_NAME}"

WORKDIR /opt/ddns-update
RUN microdnf install -y jq && \
    curl -L "${CLI53_URL}" -o cli53 && \
    chmod 755 cli53 && \
    mv cli53 /bin && \
    microdnf clean all
COPY ./source .

CMD ["/opt/ddns-update/ddns-update.sh"]
