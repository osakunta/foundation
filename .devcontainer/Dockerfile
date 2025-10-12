FROM hashicorp/terraform:1.13

USER root
RUN apk add fish shadow python3 curl && chsh -s $(which fish)


RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
RUN tar -xf google-cloud-cli-linux-x86_64.tar.gz
RUN ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=true --command-completion=true --rc-path=/root/.config/fish/config.fish