#!/usr/bin/env bash
set -e

echo "== Faveo Docker Setup =="

# Variables básicas
DOMAINNAME="$1"
EMAIL="$2"

if [[ -z "$DOMAINNAME" || -z "$EMAIL" ]]; then
  echo "Usage: $0 domain.com email@domain.com"
  exit 1
fi

# Dependencias
command -v docker >/dev/null || { echo "Docker missing"; exit 1; }
command -v docker compose >/dev/null || { echo "Docker Compose missing"; exit 1; }

# Descargar Faveo
if [[ ! -d faveo ]]; then
  git clone https://github.com/ladybirdweb/faveo-helpdesk.git faveo
fi

# Crear storage
mkdir -p storage ssl

# Generar passwords
DB_ROOT_PW=$(openssl rand -base64 16)
DB_USER_PW=$(openssl rand -base64 16)

cat > .env <<EOF
DOMAINNAME=$DOMAINNAME
HOST_ROOT_DIR=faveo
MYSQL_DATABASE=faveo
MYSQL_USER=faveo
MYSQL_PASSWORD=$DB_USER_PW
MYSQL_ROOT_PASSWORD=$DB_ROOT_PW
EOF

echo "Environment ready."

echo "Run docker compose up -d"
echo "DB Root Password: $DB_ROOT_PW"
echo "DB User Password: $DB_USER_PW"
