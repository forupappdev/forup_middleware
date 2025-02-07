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

RUN mkdir -p ./forup/middleware
COPY ../../applications/middleware/release ./forup/middleware

# Define o ponto de entrada de forma segura
ENTRYPOINT ["/PAServer-23.0/paserver", "-password=hitman47"]