# Ansible

[Getting started with Ansible](https://docs.ansible.com/ansible/latest/getting_started/index.html#getting-started-with-ansible)

[Start automating with Ansible](https://docs.ansible.com/ansible/latest/getting_started/get_started_ansible.html#start-automating-with-ansible)

## Install Ansible (Control Node)

`# apt install python3-pip python3-winrm sshpass`

`# pip3 install ansible argcomplete --break-system-packages`

`$ activate-global-python-argcomplete --user`

## Configurar IPs

Control node                10.10.10.1/24  
Managed node Debian 12      10.10.10.10/24  
Managed node Windows 11     10.10.10.11/24  

## Inventory

[Building Ansible inventories](https://docs.ansible.com/ansible/latest/inventory_guide/index.html)


### Criar arquivo hosts.ini como inventário:
``` ini
[Linux]  
debian12 ansible_host=10.10.10.10

[Windows]  
win11 ansible_host=10.10.10.11
```
### Linux - Teste com módulo ping
`ansible -i setic25/hosts.ini -u setic25 -k -m ping debian12`

### Windows - Teste com módulo win_ping

#### Instalação do WinRM

Executar no powershell como administrador:
``` pwsh
$url = "https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"  
$file = "\ConfigureRemotingForAnsible.ps1"  
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)  
powershell.exe -ExecutionPolicy ByPass -File $file  
```
Verificar se o WinRM está em execução:

`winrm enumerate winrm/config/listener`

#### Configurar senha para usuário setic25

Pesquisar por <strong>Alterar sua senha</strong> e definir a senha <strong>setic25</strong>

Teste de conexão:

`ansible -i setic25/hosts.ini -e ansible_winrm_server_cert_validation=ignore -c winrm -u setic25 -k -m win_ping win11`

### Definir variáveis no inventário

### Alterar arquivo hosts.ini como inventário:
``` ini
[Linux]  
debian12 ansible_host=10.10.10.10

[Windows]  
win11 ansible_host=10.10.10.11

[Linux:vars]  
ansible_user=setic25  
ansible_password=setic25  
ansible_python_interpreter=/usr/bin/python3  

[Windows:vars]  
ansible_user=setic25  
ansible_password=setic25  
ansible_connection=winrm  
ansible_winrm_server_cert_validation=ignore  
```

### Linux - Teste com módulo ping
`ansible -i setic25/hosts.ini -m ping debian12`

### Windows - Teste com módulo win_ping
`ansible -i setic25/hosts.ini -m win_ping win11`


## Módulos do ansible

[Index of all Modules](https://docs.ansible.com/ansible/latest/collections/index_module.html)

### Linux

[Comandos ad hoc](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html)

#### Comandos ad hoc para tarefas não repetitivas:

`ansible -i setic25/hosts.ini -m setup debian12`

`ansible -i setic25/hosts.ini -m shell -b -a 'apt install nginx -y' debian12`

`ansible -i setic25/hosts.ini -m apt -a 'pkg=nginx' debian12`

#### Playbook

[ansible.builtin.apt module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html#ansible-collections-ansible-builtin-apt-module)

Usar o playbook nginx.yml. Testar o notify.

## Roles

[Documentação](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#roles)

Transformar playbook nginx numa role


ansible-lint
extensões para vscode

estrutura do role - transformar o módulo numa role.


Links sugeridos:

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html#desired-state-and-idempotency
