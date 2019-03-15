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
maquinas=(38841 38842 38847 38851 38852 710789 710801 710804 710805 710806 710809 710811 710817 710819 710823)
lab=cad2 #Especificar qual o laboratório
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
