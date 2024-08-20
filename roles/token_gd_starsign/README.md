# TOKEN GD STARSIGN

Após a instalação desse role haverá um aplicativo chamado TokenAdmin. A partir dele é possível fazer a integração com o Firefox.

## Firefox

Abrir Menu > Preferências > Privacidade e Segurança > Dispositivos de segurança… > Carregar >

Nome do módulo = “ESCOLHA UM NOME PARA O TOKEN”

Nome do arquivo do módulo = /usr/lib/libaetpkss.so

## Chrome ou Chromium

Para carregar o módulo no Chrome ou Chromium execute com o usuário (não como root):

    modutil -dbdir sql:.pki/nssdb/ -add "starsign" -libfile /usr/lib/libaetpkss.so


Para listar os dispositivos e módulos de segurança:

    modutil -dbdir sql:.pki/nssdb/ -list