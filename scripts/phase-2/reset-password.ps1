
# ==========================================
# Project: Windows Server Lab
# Phase 2: Active Directory
# Script: reset-password.ps1
# Domain: company.local
# ==========================================

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter()]
    [string]$Identity
)

Import-Module ActiveDirectory -ErrorAction Stop

# Step 1: Get username
if ([string]::IsNullOrWhiteSpace($Identity)) {
    $Identity = Read-Host "Enter username to reset password"
}

try {
    # Step 2: Find user
    $user = Get-ADUser `
        -Identity $Identity `
        -ErrorAction Stop

    Write-Host "`nUser found:" -ForegroundColor Cyan
    Write-Host "Name     : $($user.Name)"
    Write-Host "Username : $($user.SamAccountName)"
    Write-Host "Enabled  : $($user.Enabled)"

    # Step 3: Enter new password securely
    $password = Read-Host `
        "Enter new password" `
        -AsSecureString

    if ($password.Length -eq 0) {
        throw "Password cannot be empty."
    }

    $confirmPassword = Read-Host `
        "Confirm new password" `
        -AsSecureString

    # Step 4: Compare passwords
    $ptr1 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
    $ptr2 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirmPassword)

    try {
        $plain1 = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr1)
        $plain2 = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr2)

        if ($plain1 -cne $plain2) {
            throw "Passwords do not match."
        }
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr1)
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr2)

        $plain1 = $null
        $plain2 = $null
    }

    # Step 5: Reset password
    if ($PSCmdlet.ShouldProcess(
        $user.SamAccountName,
        "Reset password and require password change at next logon"
    )) {

        Set-ADAccountPassword `
            -Identity $user `
            -Reset `
            -NewPassword $password `
            -ErrorAction Stop

        # Force user to change password at next logon
        Set-ADUser `
            -Identity $user `
            -ChangePasswordAtLogon $true `
            -ErrorAction Stop

        Write-Host "`n[SUCCESS] Password reset successfully." `
            -ForegroundColor Green

        Write-Host "User must change password at next logon." `
            -ForegroundColor Yellow
    }
}
catch {
    Write-Host "`n[ERROR] $_" -ForegroundColor Red
}

Write-Host "`nPassword reset operation completed." `
    -ForegroundColor Cyan
