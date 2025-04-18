FROM ubuntu:20.04

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
    && rm -rf /var/lib/apt/lists/*

# Instalar Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Verificar instalação do Flutter
RUN flutter doctor

# Configurar diretório de trabalho
WORKDIR /app

# Copiar arquivos do projeto
COPY . .

# Instalar dependências
RUN flutter pub get

# Construir aplicação web
RUN flutter build web

# Expor porta
EXPOSE 8080

# Comando para iniciar o servidor
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]
