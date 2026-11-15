$groups = @(
    @{Name="GG_IT"; OU="IT"},
    @{Name="GG_HR"; OU="HR"},
    @{Name="GG_Accounting"; OU="Accounting"},
    @{Name="GG_Management"; OU="Management"}
)

foreach ($group in $groups) {
    New-ADGroup `
        -Name $group.Name `
        -GroupScope Global `
        -GroupCategory Security `
        -Path "OU=$($group.OU),OU=Departments,DC=company,DC=local"
}