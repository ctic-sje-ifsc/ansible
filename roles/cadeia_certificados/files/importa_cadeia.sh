#!/bin/bash
set -euo pipefail

CERT_DIR="/home/certificados"
CSV_TMP="$(mktemp /tmp/cadeias.XXXXXX.csv)"

cleanup() {
    rm -f "$CSV_TMP"
}
trap cleanup EXIT

# Encontra perfis NSS (diretórios que contêm cert9.db)
mapfile -t PERFIS < <(find "$HOME" -name cert9.db -printf '%h\n' 2>/dev/null | sort -u)

if [[ ${#PERFIS[@]} -eq 0 ]]; then
    echo "Nenhum perfil encontrado para este usuário."
    exit 1
fi

if [[ ! -d "$CERT_DIR" ]]; then
    echo "Diretório $CERT_DIR não existe."
    exit 1
fi

# Gera CSV com: nickname,arquivo
shopt -s nullglob
for ARQ in "$CERT_DIR"/*; do
    [[ -f "$ARQ" ]] || continue

    if openssl x509 -in "$ARQ" -noout >/dev/null 2>&1; then
        SUBJECT=$(openssl x509 -in "$ARQ" -noout -subject)
    elif openssl x509 -inform der -in "$ARQ" -noout >/dev/null 2>&1; then
        SUBJECT=$(openssl x509 -inform der -in "$ARQ" -noout -subject)
    else
        echo "Ignorando arquivo não reconhecido como certificado: $ARQ"
        continue
    fi

    NOME=$(printf '%s\n' "$SUBJECT" | sed -n 's/.*CN[[:space:]]*=[[:space:]]*//p' | head -n 1)
    [[ -n "$NOME" ]] || NOME="$(basename "$ARQ")"

    printf '%s,%s\n' "$NOME" "$ARQ" >> "$CSV_TMP"
done

if [[ ! -s "$CSV_TMP" ]]; then
    echo "Nenhum certificado válido encontrado em $CERT_DIR."
    exit 1
fi

# Importa certificados em cada perfil
for CERTDIR in "${PERFIS[@]}"; do
    while IFS=, read -r NOME ARQ; do
        if certutil -L -n "$NOME" -d "$CERTDIR" >/dev/null 2>&1; then
            echo "Já existe: $NOME em $CERTDIR, ignorando."
            continue
        fi

        if certutil -A -n "$NOME" -t "CT,C,C" -i "$ARQ" -d "$CERTDIR"; then
            echo "Autoridade certificadora '$NOME' importada em $CERTDIR!"
        else
            echo "Falha ao importar '$NOME' em $CERTDIR."
        fi
    done < "$CSV_TMP"
done

echo "Pressione <ENTER> para sair"
read -r _
