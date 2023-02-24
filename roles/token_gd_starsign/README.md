#Instalação do TOKEN STARSIGN



PACOTES NECESSÁRIOS

sudo apt install pcscd libccid libjbig0 libpcsclite1 opensc



INSTALAÇÃO DE CADEIA DE CERTIFICADOS SERPRO

https://certificados.serpro.gov.br/arserpro/pages/information/certificate_chain.jsf



INSTALAÇÃO DA CADEIA DE CERTIFICADOS

Configurações > privacidade e segurança > ver certificados > Autoridades > Importar  (dai então importar certificados baixados do SERPRO)




INSTALAÇÃO DO MÓDULO (DRIVER) NO FIREFOX EM:

Abrir Menu > Preferências > Privacidade e Segurança > Dispositivos de segurança… > Carregar >

Nome do módulo = “ESCOLHA UM NOME PARA O TOKEN”

Nome do arquivo do módulo = /usr/lib/libaetpkss.so