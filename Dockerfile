# syntax=docker/dockerfile:1.6

ARG N8N_VERSION=2.7.5
FROM n8nio/n8n:${N8N_VERSION}

# MCP community node
ARG COMMUNITY_NODES="n8n-nodes-mcp"

# Włącza community nodes w runtime
ENV N8N_ENABLE_COMMUNITY_NODES=true
# Jeśli chcesz używać community nodes jako TOOLS w AI Agent:
ENV N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true

USER root

RUN mkdir -p /home/node/.n8n \
 && chown -R node:node /home/node/.n8n

USER node
WORKDIR /home/node/.n8n

# Dodatkowo: pokaż czytelny błąd, jeśli npm nie znajdzie paczki
RUN set -eux; \
    if [ -n "${COMMUNITY_NODES}" ]; then \
      npm config set fund false; \
      npm config set audit false; \
      npm install --omit=dev ${COMMUNITY_NODES}; \
    fi

WORKDIR /home/node
