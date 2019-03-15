#!/bin/bash

exec_cmd(){
  while true; do
    for line in ${maquinas[@]}; do
      target=sj-lin-${lab}-${line}.maquinas.sj.ifsc.edu.br
      timeout 1 ping -q -i 0.2 -c2 ${target} > /dev/null 2>&1
      teste="$?"
      if [ ${teste} = "0" ] ; then
        ssh -q root@${target} "iptables-restore < /var/${comando4} && ip6tables-restore < /var/${comando6}"
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
maquinas=(703873 703874 703875 703876 703877 703878 703879 703880 703881 703882 703883 703884 703885 744600 744603 744604 744605 744606 744609 756046 756047 756048 756049 756050)
lab=sidi #Especificar qual o laboratório
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

case ${1} in
  "libera")
    comando=${1}
    exec_cmd
    ;;
  "bloqueia")
    comando=${1}
    exec_cmd
    ;;
  "wiki")
    comando=${1}
    exec_cmd
    ;;
  *)
    echo "Sintaxe errada. Exemplo:"
    echo ".$0 (libera|bloqueia|wiki)"
    exit
esac
