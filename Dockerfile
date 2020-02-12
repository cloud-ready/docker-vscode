# see: https://github.com/cdr/code-server/blob/master/Dockerfile
FROM codercom/code-server:v2

RUN set -ex \
  && sudo apt -qy update \
  && sudo apt -qy upgrade \
  && sudo apt -qy install build-essential libssl-dev \
  && sudo apt-get -q -y autoremove \
  && sudo apt-get -q -y clean && sudo rm -rf /var/lib/apt/lists/* && sudo rm -f /var/cache/apt/*.bin

RUN set -ex \
  && curl https://sh.rustup.rs -sSf | sh -s -- -y \
  && . $HOME/.cargo/env \
  && rustc --version

RUN set -ex \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash \
  && export NVM_DIR="$HOME/.nvm" \
  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
  && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
  && nvm install 13.8.0 \
  && node -v \
  && npm -v

RUN set -ex \
  && curl -sSL https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz | sudo tar fxz - -C /usr/local \
  && export PATH=$PATH:/usr/local/go/bin \
  && go version

# see: https://marketplace.visualstudio.com/vscode
# no panicbit.cargo
# no Path Intellisense (christian-kohler.path-intellisense)
# no Visual Studio IntelliCode (VisualStudioExptTeam.vscodeintellicode)
# no wellaby.vscode-rust-test-adapter
# no codezombiech.gitignore
# no stringham.move-ts
# no quicktype.quicktype
# no pucelle.vscode-css-navigation
RUN set -ex \
  && mkdir -p /home/coder/bin /home/coder/.cargo/bin /home/coder/.local/bin \
  && sudo chown -R coder /home/coder \
  && code-server --install-extension ms-vscode.go \
  && code-server --install-extension rust-lang.rust \
  && code-server --install-extension hdevalke.rust-test-lens \
  && code-server --install-extension serayuzgur.crates \
  && code-server --install-extension dbaeumer.vscode-eslint \
  && code-server --install-extension eg2.vscode-npm-script \
  && code-server --install-extension xabikos.JavaScriptSnippets \
  && code-server --install-extension christian-kohler.npm-intellisense \
  && code-server --install-extension jasonnutter.search-node-modules \
  && code-server --install-extension johnpapa.angular-essentials \
  && code-server --install-extension johnpapa.Angular2 \
  && code-server --install-extension Mikael.Angular-BeastCode \
  && code-server --install-extension ms-vscode.typescript-javascript-grammar \
  && code-server --install-extension MariusAlchimavicius.json-to-ts \
  && code-server --install-extension tgreen7.vs-code-node-require \
  && code-server --install-extension jhessin.node-module-intellisense \
  && code-server --install-extension wix.vscode-import-cost \
  && code-server --install-extension maty.vscode-mocha-sidebar \
  && code-server --install-extension kisstkondoros.vscode-codemetrics \
  && code-server --install-extension ecmel.vscode-html-css \
  && code-server --install-extension msjsdiag.debugger-for-chrome \
  && code-server --install-extension pflannery.vscode-versionlens \
  && code-server --install-extension donjayamanne.git-extension-pack \
  && code-server --install-extension ziyasal.vscode-open-in-github \
  && code-server --install-extension donjayamanne.githistory \
  && code-server --install-extension alefragnani.project-manager \
  && code-server --install-extension eamodio.gitlens \
  && code-server --install-extension GitHub.vscode-pull-request-github \
  && code-server --install-extension redhat.vscode-yaml \
  && code-server --install-extension DavidAnson.vscode-markdownlint \
  && code-server --list-extensions

ENV NVM_DIR=/home/coder/.nvm
ENV GOPATH=/home/coder/project
ENV PATH=$GOPATH/bin:/usr/local/go/bin:/home/coder/bin:/home/coder/.local/bin:$PATH

COPY docker /
RUN set -ex \
  && sudo chmod 755 /entrypoint.sh

#ENTRYPOINT ["dumb-init", "code-server", "--host", "0.0.0.0"]
ENTRYPOINT ["/entrypoint.sh"]
