FROM jetbrains/teamcity-agent:latest

#install node
ENV HELM_VERSION v2.11.0
ENV NVM_DIR "$HOME/.nvm"
ENV NODE_VERSION 8.11.3
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && ln -s $(which node) /usr/bin/node \
    && ln -s $(which npm) /usr/bin/npm

#install yarn and helm client
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget \
    && apt-get install -y --no-install-recommends gnupg2 apt-transport-https \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends yarn \
    \
    && mkdir - /helm \
    && cd /helm \ 
    && wget https://storage.googleapis.com/kubernetes-helm/helm-$HELM_VERSION-linux-amd64.tar.gz \
    && tar -zxvf helm-$HELM_VERSION-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/bin/helm \
    && rm -rf /var/lib/apt/lists/*