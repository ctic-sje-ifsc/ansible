#!/bin/bash

exec_cmd(){
  while true; do
    for line in ${maquinas[@]}; do
      target=sj-lin-${lab}-${line}.maquinas.sj.ifsc.edu.br
      timeout 1 ping -q -i 0.2 -c2 ${target} > /dev/null 2>&1
      teste="$?"
      if [ ${teste} = "0" ] ; then
        ssh -q root@${target} "iptables-restore < /var/${comando4} && ip6tables-restore < /var/${comando6}"&
        echo "Máquina ${target} OK."
      else
        echo "Máquina ${target} falhou na aplicação da regra."
      fi
    done
    sleep ${tempo}
    echo "Executado"
  done
}

##### Ajustes do script #####
# Colocar aqui todos os patrimonios da maquina do laboratório
maquinas=(744528 38096 38098 38099 38100 38101 38102 744389 744390 744391 744392 744394 744395 744397 744402 744403 744536 756052 7vkdxp1 hskdxp1 jvkdxp1)
lab=cad3 #Especificar qual o laboratório
tempo=60 #Quandos segundos a aplicação da regra será repetida

# Inicio do script
comando=${1}
if [ $# -ne 1 ];
    then
        echo "Sintaxe errada. Exemplo:"
        echo ".$0 limpa (Para limpar todas as regras)"
        echo ".$0 bloqueia (Para bloquear o acesso a internet mas liberar o servidor de licenças)"
        echo ".$0 wiki (Para permitir acesso somente a página da wiki mas liberar o servidor de licenças)"
        exit
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
  "sair")
    exit 0
    ;;
  *)
    exit 0
esac
