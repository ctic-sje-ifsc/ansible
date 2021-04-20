#!/bin/bash

# Enconta onde estão os arquivos db
PERFIS=$(dirname $(find ~/ -name "cert9.db"))
if [[ -z "$PERFIS" ]]; then 
    echo "Nenhum perfil encontrado para este usuario."
    exit
fi

# Gera csv
CADEIASCSV=/tmp/cadeias.csv
for CADEIA in $(ls -x1 /home/certificados); do
    CADEIAPATH=$(readlink -f /home/certificados/$CADEIA)
    openssl x509 -in /home/certificados/$CADEIA -noout -text >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        CADEIANOME=$(openssl x509 -in /home/certificados/$CADEIA -inform der -noout -text | grep Subject: | grep -o CN=.* | cut -d= -f2)
        echo $CADEIANOME","$CADEIAPATH >> $CADEIASCSV
    else
        CADEIANOME=$(openssl x509 -in /home/certificados/$CADEIA -noout -text | grep Subject: | grep -o "CN = .*" | cut -d= -f2)
        echo $CADEIANOME","$CADEIAPATH >> $CADEIASCSV
    fi
done

# Importa Certificados 
for CERTDIR in $PERFIS; do
    IFS=","
    while read NOME ARQ
    do
        certutil -A -n "$NOME" -t "CT,C,C" -i $ARQ -d $CERTDIR
        echo "Autoridade Certificado $NOME importada!"
    done < $CADEIASCSV
done

rm -f $CADEIASCSV
