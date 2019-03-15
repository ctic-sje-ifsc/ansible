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
    echo "Executado regra ${comando}"
    sleep ${tempo}
  done
}

##### Ajustes do script #####
# Colocar aqui todos os patrimonios da maquina do laboratório
maquinas=(38103 38106 38107 38109 38110 38114 38115 38116 38117 38118 38119 38120 38123 38126 38127 38128 38130 38131 38132 38135 38136 613025 710812)
lab=redes #Especificar qual o laboratório
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
