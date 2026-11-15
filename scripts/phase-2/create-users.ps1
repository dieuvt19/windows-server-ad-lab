$users = @(
    @{Name="IT Admin"; Username="it.admin"; OU="IT"},
    @{Name="IT User"; Username="it.user"; OU="IT"},
    @{Name="HR Admin"; Username="hr.admin"; OU="HR"},
    @{Name="HR User"; Username="hr.user"; OU="HR"},
    @{Name="Accounting Admin"; Username="acc.admin"; OU="Accounting"},
    @{Name="Accounting User"; Username="acc.user"; OU="Accounting"},
    @{Name="Manager 01"; Username="manager01"; OU="Management"},
    @{Name="Manager 02"; Username="manager02"; OU="Management"}
)

$password = Read-Host "Enter initial password" -AsSecureString

foreach ($user in $users) {

    $path = "OU=$($user.OU),OU=Departments,DC=company,DC=local"

    New-ADUser `
        -Name $user.Name `
        -SamAccountName $user.Username `
        -UserPrincipalName "$($user.Username)@company.local" `
        -Path $path `
        -AccountPassword $password `
        -Enabled $true `
        -ChangePasswordAtLogon $true

    $groupName = switch ($user.OU) {
        "IT" { "GG_IT" }
        "HR" { "GG_HR" }
        "Accounting" { "GG_Accounting" }
        "Management" { "GG_Management" }
    }

    Add-ADGroupMember -Identity $groupName -Members $user.Username
}