#### Update-Date: 2025/11/24
########### LIMPEZA DA PASTA ALUNO
$basePath = "C:\Users"

# Localiza a pasta do usuário que é exatamente "aluno"
$userFolder = Get-ChildItem -Path $basePath -Directory |
    Where-Object { $_.Name -eq "aluno" } |
    Select-Object -First 1

if ($userFolder) {
    $userProfile = $userFolder.FullName

    # Lista de caminhos a serem limpos
    $pathsToDelete = @(
        # Pastas de navegadores
        Join-Path $userProfile "AppData\Local\Google\Chrome"
        Join-Path $userProfile "AppData\Roaming\Mozilla"
        Join-Path $userProfile "AppData\Local\Microsoft\Edge\"

        # Nuvens (Drive / OneDrive)
        Join-Path $userProfile "AppData\Local\Google\DriveFS\"
        Join-Path $userProfile "AppData\Local\Microsoft\OneDrive\"

        # Temp do usuário
        Join-Path $userProfile "AppData\Local\Temp"
        Join-Path $userProfile "AppData\Roaming\Microsoft\Windows\Recent"

        # Pastas do usuário
        Join-Path $userProfile "Desktop"
        Join-Path $userProfile "Music"
        Join-Path $userProfile "Downloads"
        Join-Path $userProfile "OneDrive"
        Join-Path $userProfile "Pictures"
        Join-Path $userProfile "Videos"
        Join-Path $userProfile "AppData\Local\Programs"
    )

    # Remove o conteúdo de todas as pastas sem verificar
    foreach ($path in $pathsToDelete) {
        try {
            Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
        } catch {
            # Se necessário, pode logar os erros aqui
        }
    }

} else {
    Write-Warning "Usuário 'aluno' não encontrado em C:\Users"
}

Clear-RecycleBin -Force
