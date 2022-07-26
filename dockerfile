# Base
FROM kalilinux/kali-rolling

# Autor
LABEL maintainer="Dario Escarlon(@pwnhun73r)"

# Variables de entorno
ENV HOME /root
ENV DEBIAN_FRONTEND=nointeractive

# Directorio de trabajo
WORKDIR /root
RUN mkdir ${HOME}/tools && \
    mkdir -p ${HOME}/tools/wordlists	

# Actualizar sistema
RUN apt update && \
    apt upgrade -y

# Aplicaciones varias y fuente iconos
RUN apt install -y fonts-noto-color-emoji \
    zsh \
    gcc \
    nano \
    tmux \
    netcat-traditional \
    openvpn \
    unzip \
    tree \
    vim \
    locate \
    git \
    wget \
    curl \
    python3 \
    net-tools \
    btop \
    xclip \
    rlwrap \
    lsof \
    tar \
    scrub \
    gzip \
    pipx \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# Instalacion LSD y BAT
RUN wget https://github.com/Peltoche/lsd/releases/download/0.22.0/lsd_0.22.0_amd64.deb && \
    wget https://github.com/sharkdp/bat/releases/download/v0.21.0/bat_0.21.0_amd64.deb && \
    dpkg -i lsd_0.22.0_amd64.deb bat_0.21.0_amd64.deb && \
    rm lsd_0.22.0_amd64.deb bat_0.21.0_amd64.deb

# Plugin sudo zsh
RUN mkdir -p /usr/share/zsh-plugins && \
    cd /usr/share/zsh-plugins && \
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

# Instalar Powerlevel10k
RUN cd ${HOME} && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# Instalar GO
RUN cd /opt && \
    wget https://go.dev/dl/go1.17.8.linux-amd64.tar.gz && \
    tar -xvf go1.17.8.linux-amd64.tar.gz -C /usr/local/ && \
    rm go1.17.8.linux-amd64.tar.gz

ENV GOROOT "/usr/local/go"
ENV GOPATH "/root/go"
ENV PATH "$PATH:$GOPATH/bin:$GOROOT/bin"

# Archivos de configuracion
COPY conf /tmp
RUN mv /tmp/.zshrc /root && \
    mv /tmp/.p10k.zsh /root && \
    mv /tmp/.tmux.conf /root && \
    mv /tmp/.tmux.conf.local /root

# Instalar python2
RUN apt update && \
    apt install -y --no-install-recommends \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    ca-certificates \
    llvm \ 
    libncurses5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    mecab-ipadic-utf8

# Env para PyEnv
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT:$PYENV_ROOT/bin:$PATH

# Instalar pyenv
RUN set -ex && \
    curl https://pyenv.run | bash && \
    pyenv update && \
    pyenv install 2.7.18

# Instalar AWS-CLI
RUN pipx install awscli

# Instalacion tools
RUN cd ${HOME} && \
    apt install -y john \
    hashcat \
    nmap \
    whatweb \
    nikto \
    exploitdb \
    evil-winrm \
    metasploit-framework \
    cewl

# Diccionarios
RUN cd ${HOME}/tools/wordlists && \
    wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt && \
    wget https://github.com/daviddias/node-dirbuster/raw/master/lists/directory-list-2.3-medium.txt && \
    git clone https://github.com/danielmiessler/SecLists.git

# ffuf
RUN go install github.com/ffuf/ffuf@latest

# Gobuster
RUN go install github.com/OJ/gobuster/v3@latest
    
# Nuclei
RUN go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest && \
    nuclei -update-templates

# Chisel
RUN go install github.com/jpillora/chisel@latest

# Crackmapexec
RUN pipx install crackmapexec

# Hashid
RUN pipx install hashid

# Virtualenv
RUN pipx install virtualenv

