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

# Instalar Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Verificar instalação do Flutter
RUN flutter doctor

# Configurar diretório de trabalho
WORKDIR /app

# Copiar arquivos de dependência primeiro para aproveitar o cache
COPY pubspec.yaml .
RUN flutter pub get

# Copiar o resto do código
COPY . .

# Construir aplicação web em modo release
RUN flutter build web --release

# Estágio de produção
FROM nginx:stable-alpine

# Copiar os arquivos construídos do estágio anterior
COPY --from=builder /app/build/web /usr/share/nginx/html

# Configuração do nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expor porta
EXPOSE 80

# Comando para iniciar o nginx
CMD ["nginx", "-g", "daemon off;"]
