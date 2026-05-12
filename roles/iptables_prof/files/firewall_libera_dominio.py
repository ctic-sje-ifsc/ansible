#!/usr/bin/env python3
"""
firewall_libera_dominio.py — run ansible iptables/ip6tables ad-hoc for one or more domains
Usage:
  firewall_libera_dominio.py domain1 [domain2 ...]
"""
import sys
import os
import socket
import subprocess

if len(sys.argv) <= 1:
    print("Uso: firewall_libera_dominio.py domain1 [domain2 ...]", file=sys.stderr)
    sys.exit(2)

domains = sys.argv[1:]
exit_code = 0

def resolve_addresses(domain):
    """Return a list of (family, ip) tuples for the domain (A and AAAA)."""
    results = []
    try:
        infos = socket.getaddrinfo(domain, None, 0, socket.SOCK_STREAM)
    except socket.gaierror as e:
        print(f"Erro ao resolver {domain}: {e}", file=sys.stderr)
        return results
    seen = set()
    for fam, _, _, _, sockaddr in infos:
        ip = sockaddr[0]
        if ip in seen:
            continue
        seen.add(ip)
        results.append((fam, ip))
    return results

for domain in domains:
    addrs = resolve_addresses(domain)
    if not addrs:
        print(f"Nenhum endereço encontrado para {domain}", file=sys.stderr)
        exit_code = exit_code or 1
        continue

    # Ensure both IPv4 and IPv6 are handled if present
    for fam, ip in addrs:
        ip_version = 'ipv6' if fam == socket.AF_INET6 else 'ipv4'
        module_args = (
            f"chain=OUTPUT protocol=tcp destination={ip} table=filter jump=ACCEPT action=insert ip_version={ip_version}"
        )
        cmd = [
            "ansible",
            "-u", "root",
            "-f", "50",
            "--private-key", "/etc/ansible/id_rsa",
            "all",
            "-m", "ansible.builtin.iptables",
            "-a", module_args,
            "-b",
        ]

        proc = subprocess.run(cmd)
        if proc.returncode != 0:
            print(f"Comando falhou para {domain} ({ip}), código {proc.returncode}", file=sys.stderr)
            exit_code = proc.returncode if exit_code == 0 else exit_code

sys.exit(exit_code)
