# REMOVER USUÁRIO + PASTA

# colocar termos em comum dos usuários
$parteComum = "_csa"

# -----------------------------------------------------------

Write-Host "BUSCANDO usuários com '$parteComum' no nome..." -ForegroundColor Cyan

# encontra os usuários locais que batem com o filtro
$usuariosParaRemover = Get-LocalUser | Where-Object { $_.Name -like "*$parteComum*" }

if ($usuariosParaRemover.Count -gt 0) {
    Write-Host "Encontrados $($usuariosParaRemover.Count) usuários." -ForegroundColor Yellow
    
    foreach ($usuario in $usuariosParaRemover) {
        $nome = $usuario.Name
        $sid  = $usuario.SID.Value # O ID único do usuário, acha a pasta correta
        
        Write-Host "--------------------------------------------"
        Write-Host "Processando: $nome"

        # bloco que tenta remover o perfil (pasta + registro)
        try {
            # procura o perfil associado ao SID do usuário
            $perfil = Get-CimInstance -Class Win32_UserProfile -Filter "SID = '$sid'" -ErrorAction SilentlyContinue
            
            if ($perfil) {
                Write-Host " -> Removendo perfil e pasta (C:\Users\$nome)..."
                $perfil | Remove-CimInstance -ErrorAction Stop
                Write-Host "    SUCESSO: Pasta e perfil removidos." -ForegroundColor Green
            } else {
                Write-Host "    AVISO: Nenhum perfil/pasta encontrado (o usuário talvez nunca tenha logado)." -ForegroundColor DarkGray
            }
        }
        catch {
            Write-Host "    ERRO ao remover perfil: $($_.Exception.Message)" -ForegroundColor Red
            # Se der erro aqui (ex: arquivo preso), o script tenta apagar o usuário mesmo assim no Passo 2
        }

        # remove a conta de usuário
        try {
            Write-Host " -> Removendo a conta do sistema..."
            Remove-LocalUser -Name $nome -ErrorAction Stop
            Write-Host "    SUCESSO: Conta '$nome' removida." -ForegroundColor Green
        }
        catch {
            Write-Host "    ERRO ao remover conta: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Write-Host "`nLimpeza concluída." -ForegroundColor Cyan

} else {
    Write-Host "Nenhum usuário encontrado com o termo '$parteComum'." -ForegroundColor Red
}
