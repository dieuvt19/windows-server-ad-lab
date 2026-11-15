
# ==========================================
# Project: Windows Server Lab
# Phase 2: Active Directory
# Script: create-ou.ps1
# Domain: company.local
# ==========================================

Import-Module ActiveDirectory

# Get current domain information
$domain = Get-ADDomain
$domainDN = $domain.DistinguishedName

# Parent OU
$parentOU = "Departments"

# Department OUs
$departments = @(
    "IT",
    "HR",
    "Accounting",
    "Management"
)

# Function: Create OU if it does not exist
function New-OUIfNotExists {
    param (
        [string]$Name,
        [string]$Path
    )

    $existingOU = Get-ADOrganizationalUnit `
        -LDAPFilter "(ou=$Name)" `
        -SearchBase $Path `
        -SearchScope OneLevel `
        -ErrorAction SilentlyContinue

    if ($existingOU) {
        Write-Host "[SKIP] OU already exists: $Name" -ForegroundColor Yellow
    }
    else {
        New-ADOrganizationalUnit `
            -Name $Name `
            -Path $Path `
            -ProtectedFromAccidentalDeletion $true

        Write-Host "[CREATED] OU: $Name" -ForegroundColor Green
    }
}

# Step 1: Create parent OU
New-OUIfNotExists `
    -Name $parentOU `
    -Path $domainDN

# Step 2: Create department OUs
$parentDN = "OU=$parentOU,$domainDN"

foreach ($department in $departments) {

    New-OUIfNotExists `
        -Name $department `
        -Path $parentDN
}

Write-Host ""
Write-Host "===================================="
Write-Host "Active Directory OU setup completed"
Write-Host "Domain: $($domain.DNSRoot)"
Write-Host "====================================" -ForegroundColor Cyan
