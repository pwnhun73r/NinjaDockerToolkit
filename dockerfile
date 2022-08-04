# Base
FROM kalilinux/kali-rolling:latest

# Autor
LABEL maintainer="Dario Escarlon(@pwnhun73r)"

# Variables de entorno
ENV HOME /root

# Directorio de trabajo
WORKDIR /root
RUN mkdir ${HOME}/tools && \
    mkdir ${HOME}/work && \ 
    mkdir -p ${HOME}/tools/wordlists && \
# Actualizar sistema
    apt-get -y update && \
# Aplicaciones varias y fuente iconos
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    fonts-noto-color-emoji \
    zsh \
    gcc \
    iputils-ping \
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
    python3-pip \
    python3-impacket \
    impacket-scripts \
    net-tools \
    btop \
    xclip \
    rlwrap \
    lsof \
    tar \
    fcrackzip \
    cifs-utils \ 
    ftp \
    smbclient \
    php \
    telnet \
    tcpdump \
    whois \
    host \
    dnsutils \
    scrub \
    gzip \
    pipx \
    ssh \
    p7zip-full \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
# Dependencias Python2
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
    mecab-ipadic-utf8 \
# Tools
    john \
    hashcat \
    nmap \
    whatweb \
    nikto \
    smbmap \
    exploitdb \
    evil-winrm \
    metasploit-framework \
    cewl \
    && rm -rf /var/lib/apt/lists/*

# Instalacion LSD y BAT
RUN wget https://github.com/Peltoche/lsd/releases/download/0.22.0/lsd_0.22.0_amd64.deb && \
    wget https://github.com/sharkdp/bat/releases/download/v0.21.0/bat_0.21.0_amd64.deb && \
    dpkg -i lsd_0.22.0_amd64.deb bat_0.21.0_amd64.deb && \
    rm lsd_0.22.0_amd64.deb bat_0.21.0_amd64.deb && \
# Plugin sudo zsh
    mkdir -p /usr/share/zsh-plugins && \
    cd /usr/share/zsh-plugins && \
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh && \
# Instalar Powerlevel10k
    cd ${HOME} && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k && \
# Instalar GO
    cd /opt && \
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

# Env para PyEnv
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT:$PYENV_ROOT/bin:$PATH

# Instalar pyenv
RUN set -ex && \
    curl https://pyenv.run | bash && \
    pyenv update && \
    pyenv install 2.7.18 && \
# Instalar AWS-CLI
    cd ${HOME}/tools && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm ${HOME}/tools/awscliv2.zip && \
# Diccionarios
    cd ${HOME}/tools/wordlists && \
    wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt && \
    wget https://github.com/daviddias/node-dirbuster/raw/master/lists/directory-list-2.3-medium.txt && \
    git clone https://github.com/danielmiessler/SecLists.git && \
# ffuf
    cd ${HOME} && \
    go install github.com/ffuf/ffuf@latest && \
# Gobuster
    go install github.com/OJ/gobuster/v3@latest && \
# Nuclei
    go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest && \
    nuclei -update-templates && \
# Chisel
    go install github.com/jpillora/chisel@latest && \
# Crackmapexec
    pipx install crackmapexec && \
# Hashid
    pipx install hashid && \
# Virtualenv
    pipx install virtualenv
