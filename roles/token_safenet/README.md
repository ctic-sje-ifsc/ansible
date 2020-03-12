# Token Safenet 5110

Esta role é utilizada para instalar o pacote SafenetAuthenticationClient versão 9.1.7 no Debian Buster.
Esse pacote é necessário para o funcionamento do [Token Safenet 5110](https://safenet.gemalto.com/multi-factor-authentication/authenticators/pki-usb-authentication/etoken-5110-usb-token/).


## Firefox

Após a instalação é necessário adicionar ao Mozilla Firefox (68.6.0esr-1) é preciso carregar o módulo:

Menu > Preferências > Privacidade e Segurança > Dispositivos de segurança... > Carregar

Nome do módulo: safenet (ou outro de sua escolha)
Nome do arquivo do módulo: /usr/lib/libeTPkcs11.so

## Chrome ou Chromium

Para carregar o módulo no Chrome ou Chromium execute com o usuário (não como root):

    modutil -dbdir sql:.pki/nssdb/ -add "safenet" -libfile /usr/lib/libeTPkcs11.so


Para listar os dispositivos e módulos de segurança:

    modutil -dbdir sql:.pki/nssdb/ -list


## Libreoffice

O Libreoffice pode ser utulizado para assinar documentos. A versão atual do repositório stable (6.1.5-3+10u3) não funcionou. Foi preciso instalar a versão do repositório buster-backports (6.4.1-1~bpo10+1).

O Libreoffice utiliza o mesmo módulo do dispositivo de segurança do Firefox, porém é necessário realizar a seguinte configuração:

###Utilizar a configuração do Firefox
Ferramentas > Opções > LibreOffice > Segurança > Certificado... e selecionar o Perfil firefox:default-esr.

###Utilizar a configuração do Chrome ou Chromium
Ferramentas > Opções > LibreOffice > Segurança > Certificado... Selecionar caminho do NSS... e selecionar o diretório ~/.pki/nssdb

Dentro dos dois diretórios o arquivo pkcs11.txt aponta para a biblioteca correta.

Obs: Ao apagar o outro perfil não foi mais possível selecionar o certificado para assinar.