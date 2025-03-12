# Token Safenet 5110

Esta role é utilizada para instalar o pacote SafenetAuthenticationClient versão 10.7.77 no Debian 12 Bookworm.
Esse pacote é necessário para o funcionamento do [Token Safenet 5110](https://www.serpro.gov.br/links-fixos-superiores/pss-serpro/drivers_token/).

## Configuração automática

**Inicialmente é preciso abrir os navegadores para que os diretórios sejam criados e depois fechá-los.** <br>
Existem duas opções:

### 1 - Através do lançador de aplicações, procurar por: 
    Habilita módulo Safenet nos navegadores

Em caso de sucesso aparecerá a seguinte mensagem:

    Cadeias e modulo SafeSign instalados no Mozilla Firefox do usuario <USER>.
    Cadeias e modulo SafeSign instalados no Google Chrome do usuario <USER>.
    Pressione <ENTER> para sair


### 2 - Executar no terminal do usuário (NÃO USAR A CONTA ROOT):

    /usr/local/bin/habilita_token_safenet.sh

## Configuração manual

### Firefox

Após a instalação é preciso carregar o módulo:

Menu > Configurações > Privacidade e Segurança > Dispositivos de segurança... > Carregar

Nome do módulo: safenet (ou outro de sua escolha) <br>
Nome do arquivo do módulo: /usr/lib/libeTPkcs11.so

### Chrome ou Chromium

Para carregar o módulo no Chrome ou Chromium execute com o usuário (não como root):

    modutil -dbdir sql:.pki/nssdb/ -add "safenet" -libfile /usr/lib/libeTPkcs11.so


Para listar os dispositivos e módulos de segurança:

    modutil -dbdir sql:.pki/nssdb/ -list
