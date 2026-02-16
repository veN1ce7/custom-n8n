# syntax=docker/dockerfile:1.6

# Pinuj wersję dla powtarzalnych buildów (możesz zmienić na konkretną, np. 1.90.0)
ARG N8N_VERSION=2.7.5
FROM n8nio/n8n:${N8N_VERSION}

# Lista community nodes do instalacji (oddzielone spacją)
# Przykład: n8n-nodes-fastmcp (jeśli tak nazywa się paczka w npm)
ARG COMMUNITY_NODES="n8n-nodes-fastmcp"

# Włącz obsługę community nodes w runtime
ENV N8N_ENABLE_COMMUNITY_NODES=true

USER root

# Przygotuj katalog ~/.n8n i prawa
RUN mkdir -p /home/node/.n8n \
 && chown -R node:node /home/node/.n8n

USER node

# Instalacja community nodes do ~/.n8n (bez dev deps)
WORKDIR /home/node/.n8n
RUN if [ -n "${COMMUNITY_NODES}" ]; then \
      npm install --omit=dev ${COMMUNITY_NODES}; \
    fi

# Powrót do domyślnego workdir n8n
WORKDIR /home/node
