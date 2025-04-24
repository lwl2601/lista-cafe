# Estágio de build
FROM ubuntu:20.04 as builder

# Configurar variáveis de ambiente para evitar prompts interativos
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

# Instalar dependências
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-8-jdk \
    wget \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Configurar o fuso horário
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Criar usuário não-root
RUN useradd -ms /bin/bash flutter
RUN mkdir -p /home/flutter/flutter
RUN chown -R flutter:flutter /home/flutter

# Instalar Flutter
RUN git clone https://github.com/flutter/flutter.git /home/flutter/flutter
ENV PATH="/home/flutter/flutter/bin:${PATH}"

# Corrigir permissões
RUN chown -R flutter:flutter /home/flutter/flutter
RUN chmod -R 755 /home/flutter/flutter

# Configurar diretório de trabalho
WORKDIR /home/flutter/app
RUN chown -R flutter:flutter /home/flutter/app

# Mudar para o usuário flutter
USER flutter

# Verificar instalação do Flutter
RUN flutter doctor

# Copiar arquivos de dependência primeiro para aproveitar o cache
COPY --chown=flutter:flutter pubspec.yaml .
RUN flutter pub get

# Copiar o resto do código
COPY --chown=flutter:flutter . .

# Construir aplicação web em modo release
RUN flutter build web --release

# Estágio de produção
FROM nginx:stable-alpine

# Copiar os arquivos construídos do estágio anterior
COPY --from=builder /home/flutter/app/build/web /usr/share/nginx/html

# Configuração do nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf.template
RUN chmod 644 /etc/nginx/conf.d/default.conf.template

# Script para substituir a variável PORT
COPY <<EOF /docker-entrypoint.d/40-replace-port.sh
#!/bin/sh
envsubst '\${PORT}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
EOF

RUN chmod +x /docker-entrypoint.d/40-replace-port.sh

# Comando para iniciar o nginx
CMD ["nginx", "-g", "daemon off;"]
