FROM ubuntu:22.04

# Atualiza a lista de pacotes e faz upgrade do sistema
RUN apt-get update -y && apt-get dist-upgrade -y && \
    apt-get install -y joe wget p7zip-full curl openssh-server build-essential \
                       zlib1g-dev libcurl4-gnutls-dev libncurses5 && \
    rm -rf /var/lib/apt/lists/*

# Define a porta que será utilizada
ENV PORT=64211

# Expõe a porta para comunicação externa
EXPOSE 64211

# Copia e extrai o pacote necessário
COPY ./pkg/LinuxPAServer23.0.tar.gz ./
RUN tar -xvf ./LinuxPAServer23.0.tar.gz

# Define o ponto de entrada de forma segura
ENTRYPOINT ["/PAServer-23.0/paserver", "-password=hitman47"]

#CONSTRUIR IMAGEM DOCKER
#docker build --pull --rm -f 'src\containers\paserver\Dockerfile' -t 'foruppaserver:latest' 'src\containers\paserver'