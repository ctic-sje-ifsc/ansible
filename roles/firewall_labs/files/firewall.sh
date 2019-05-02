#!/bin/bash

exec_cmd(){
  while true; do
    for line in ${maquinas[@]}; do
      target=sj-lin-${lab}-${line}.maquinas.sj.ifsc.edu.br
      timeout 0.1 nc -z -w5 ${target} 22  > /dev/null 2>&1
      if [ ${?} = "0" ] ; then
        ssh -o StrictHostKeyChecking=no -q root@${target} "iptables-restore < /var/${comando4} && ip6tables-restore < /var/${comando6}"&
        echo "Máquina ${target} OK."
      elif [ ${?} = "1" ] ; then
        echo "Máquina ${target}: falhou na aplicação da regra. Computador desligado ou sem rede."
      elif [ ${?} = "124" ] ; then
        echo "Máquina ${target}: falhou na aplicação da regra. Ligado no Windows???."
      else
        echo "Máquina ${target}: falhou na aplicação da regra."
      fi
    done
    echo "Executado regra ${comando}"
    if ${repeticao} ; then
      sleep ${tempo}
    else
      exit 0
    fi
  done
}

##### Ajustes do script #####
lab=$(hostname |cut -d'-' -f3) #Definindo qual o laboratório
maquinas=$(cat /var/pat |grep ${lab}|cut -d'=' -f2)

# Inicio do script
comando=${1}
repeticao=${2}
tempo=60
if [ $# -eq 0 ] || [ $# -gt 3 ] ;
    then
        echo "Sintaxe errada. Exemplo:"
        echo ".$0 libera (Para limpar todas as regras)"
        echo ".$0 bloqueia (Para bloquear o acesso a internet mas liberar o servidor de licenças)"
        echo ".$0 wiki (Para permitir acesso somente a página da wiki mas liberar o servidor de licenças)"
        echo ".$0 ajuda (Abrir manual de uso desse script)"
        exit
fi

# Se não for informado repeticao
if [ -z ${repeticao} ]; then
	repeticao=true
fi

case ${comando} in
  "libera")
    comando4=${comando}
    comando6=${comando}
    exec_cmd
    exit 0
    ;;
  "bloqueia")
    comando4=block4
    comando6=block6
    exec_cmd
    ;;
  "wiki")
    comando4=wiki4
    comando6=wiki6
    exec_cmd
    ;;
  "ajuda")
    echo "Nome
    firewall.sh

Synopse
bash ${0} [regra] [repeticao (opcional)]

Descrição
Esse script foi feito para bloquear a internet nos computadores dos alunos quando o professor assim o
desejar. A máquina do professor envia um comando através de ssh com chave compartilhada em todas as máquinas
que estiverem ligadas para o iptables aplicando assim a regra, por padrão o tempo de atualização das regras
é de 60 segundos.
OBS: Para alterar a regra deve-se finalizar o script 'a força' com as teclas CTRL + C e executá-lo novamente

Regras:
libera    Apaga todas regras
bloqueia  Realiza o bloquear do acesso a todos os sites, se mantém liberado o servidor de licenças, o SSH e o ICMP
wiki      Mantém o acesso somente a página da wiki, se mantém liberado o servidor de licenças, o SSH e o ICMP
ajuda     Exibe esta ajuda.

Repetição: (Essa opção é opcional, se não for especificado será adotado 'true')
true      Executa o script com a regra definida a cada 60 segundos.
false     Executa o script com a regra definida apenas 1 vez."
    ;;
  *)
    echo "Comando ${comando} não reconhecido."
    exit 0
    ;;
esac
