
# ==========================================
# Project: Windows Server Lab
# Phase 2: Active Directory
# Script: add-users-to-groups.ps1
# Domain: company.local
# ==========================================

[CmdletBinding(SupportsShouldProcess = $true)]
param()

Import-Module ActiveDirectory -ErrorAction Stop

$domainDN = (Get-ADDomain).DistinguishedName

# User and Group mapping
$memberships = @(
    @{ User = "it.admin"; Group = "GG_IT" }
    @{ User = "it.user"; Group = "GG_IT" }

    @{ User = "hr.admin"; Group = "GG_HR" }
    @{ User = "hr.user"; Group = "GG_HR" }

    @{ User = "acc.admin"; Group = "GG_Accounting" }
    @{ User = "acc.user"; Group = "GG_Accounting" }

    @{ User = "manager01"; Group = "GG_Management" }
    @{ User = "manager02"; Group = "GG_Management" }
)

foreach ($item in $memberships) {

    $username = $item.User
    $groupName = $item.Group

    try {
        # Check user
        $user = Get-ADUser `
            -Identity $username `
            -ErrorAction Stop

        # Check group
        $group = Get-ADGroup `
            -Identity $groupName `
            -ErrorAction Stop

        # Check existing membership
        $existingMember = Get-ADGroupMember `
            -Identity $group `
            -ErrorAction Stop |
            Where-Object { $_.SID -eq $user.SID }

        if ($existingMember) {

            Write-Host "[SKIP] $username already belongs to $groupName" `
                -ForegroundColor Yellow
        }
        else {

            if ($PSCmdlet.ShouldProcess(
                "$username",
                "Add to group $groupName"
            )) {

                Add-ADGroupMember `
                    -Identity $group `
                    -Members $user `
                    -ErrorAction Stop

                Write-Host "[SUCCESS] Added $username to $groupName" `
                    -ForegroundColor Green
            }
        }
    }
    catch {
        Write-Host "[ERROR] $username -> $groupName : $_" `
            -ForegroundColor Red
    }
}

Write-Host "`nGroup membership operation completed." `
    -ForegroundColor Cyan
