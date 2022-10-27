#!/bin/bash

##Este arquivo eh gerado automaticamente pelo Ansible, nao adianta editar.

#Restaurar o usuario aluno quando manda desligar a maquina ou reiniciar.
rm -rf /var/spool/cron/crontabs/aluno
rm -rf /home/aluno
tar -zxvf /opt/backup/aluno.tgz -C / --exclude=home/aluno/.ssh/known_hosts
