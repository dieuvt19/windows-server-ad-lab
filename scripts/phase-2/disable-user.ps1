
# ==========================================
# Project: Windows Server Lab
# Phase 2: Active Directory
# Script: disable-user.ps1
# Domain: company.local
# ==========================================

[CmdletBinding(
    SupportsShouldProcess = $true,
    ConfirmImpact = "High"
)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Identity
)

Import-Module ActiveDirectory -ErrorAction Stop

try {
    # Step 1: Find user
    $user = Get-ADUser `
        -Identity $Identity `
        -Properties Enabled `
        -ErrorAction Stop

    Write-Host "`nUser information:" -ForegroundColor Cyan
    Write-Host "Name     : $($user.Name)"
    Write-Host "Username : $($user.SamAccountName)"
    Write-Host "Enabled  : $($user.Enabled)"

    # Step 2: Check account status
    if (-not $user.Enabled) {

        Write-Host "`n[SKIP] Account is already disabled." `
            -ForegroundColor Yellow

        return
    }

    # Step 3: Disable account
    if ($PSCmdlet.ShouldProcess(
        $user.SamAccountName,
        "Disable Active Directory account"
    )) {

        Disable-ADAccount `
            -Identity $user `
            -ErrorAction Stop

        Write-Host "`n[SUCCESS] User account disabled." `
            -ForegroundColor Green

        Write-Host "Username: $($user.SamAccountName)"
    }
}
catch {
    Write-Host "`n[ERROR] $_" -ForegroundColor Red
}

Write-Host "`nDisable user operation completed." `
    -ForegroundColor Cyan
