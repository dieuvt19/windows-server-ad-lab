# Phase 2 – Active Directory

## 1. Overview

This phase focuses on deploying and configuring Active Directory Domain Services (AD DS) on Windows Server 2022.

The goal is to establish a centralized identity and access management system for a simulated company environment.

### Objectives

- Install Active Directory Domain Services.
- Promote Windows Server to a Domain Controller.
- Create a new Active Directory forest and domain.
- Configure Organizational Units (OUs) for departments.
- Create domain users and security groups.
- Manage Active Directory using GUI and PowerShell.
- Verify domain services and directory structure.

## 2. Lab Environment

| Component    | Configuration                           |
| ------------ | --------------------------------------- |
| Server OS    | Windows Server 2022 Standard Evaluation |
| Server Name  | WS2022-DC01                             |
| Server Role  | Domain Controller                       |
| Domain Name  | company.local                           |
| NetBIOS Name | COMPANY                                 |
| Server IP    | 192.168.50.10                           |
| Subnet Mask  | 255.255.255.0                           |
| DNS Server   | 192.168.50.10                           |
| Network      | AD-LAB                                  |

### Domain Architecture

```text
company.local
│
├── Builtin
├── Computers
├── Domain Controllers
├── ForeignSecurityPrincipals
├── Managed Service Accounts
├── Users
│
└── Departments
    │
    ├── IT
    │   ├── GG_IT
    │   ├── IT Admin
    │   └── IT User
    │
    ├── HR
    │
    ├── Accounting
    │
    └── Management
```

Note: Builtin, Computers, Domain Controllers, ForeignSecurityPrincipals, Managed Service Accounts, and Users are default Active Directory containers or system-created objects.

## 3. Install Active Directory Domain Services

### Step 1: Open Server Manager

Navigate to:

`Server Manager → Manage → Add Roles and Features`

### Step 2: Select Installation Type

Choose:

`Role-based or feature-based installation`

### Step 3: Select Destination Server

Select:

`WS2022-DC01`

### Step 4: Install Server Roles

Select:

`Active Directory Domain Services`

Click **Add Features** when prompted.

Continue through the wizard and click **Install**.

## 4. Promote Server to Domain Controller

After installing AD DS, configure the server as a Domain Controller.

### Step 1: Start Promotion Wizard

In Server Manager, click the notification flag.

Select:

`Promote this server to a domain controller`

### Step 2: Deployment Configuration

Select:

`Add a new forest`

Root domain name:

```text
company.local
```

### Step 3: Domain Controller Options

Configure:

| Setting                     | Value                                    |
| --------------------------- | ---------------------------------------- |
| Domain Functional Level     | Windows Server 2016 or highest supported |
| Forest Functional Level     | Windows Server 2016 or highest supported |
| DNS Server                  | Enabled                                  |
| Global Catalog              | Enabled                                  |
| Read Only Domain Controller | Disabled                                 |

Configure a Directory Services Restore Mode (DSRM) password.

### Step 4: Additional Options

NetBIOS domain name:

```text
COMPANY
```

### Step 5: Database and SYSVOL Paths

Keep the default paths:

- Database folder
- Log files folder
- SYSVOL folder

### Step 6: Prerequisites Check

Review the configuration and run the prerequisites check.

If no blocking errors are found, click **Install**.

The server will automatically restart after promotion.

## 5. Verify Domain Controller

After restarting, log in using:

```text
COMPANY\Administrator
```

Open PowerShell as Administrator.

### Check Domain Information

```powershell
Get-ADDomain
```

Expected information:

```text
DNSRoot     : company.local
NetBIOSName : COMPANY
```

### Check Domain Controller

```powershell
Get-ADDomainController
```

### Check DNS Resolution

```powershell
nslookup company.local
```

Expected DNS resolution:

```text
192.168.50.10
```

### Check Active Directory Services

```powershell
Get-Service NTDS, DNS, Netlogon
```

The services should be running.

## 6. Create Organizational Units

Organizational Units (OUs) provide a logical structure for organizing users, groups, computers, and applying Group Policies.

### Department Structure

The following OUs are created under `Departments`:

| Organizational Unit | Description            |
| ------------------- | ---------------------- |
| IT                  | Information Technology |
| HR                  | Human Resources        |
| Accounting          | Finance and Accounting |
| Management          | Management Team        |

### Create OUs Using GUI

Open:

`Server Manager → Tools → Active Directory Users and Computers`

Or run:

```powershell
dsa.msc
```

Steps:

1. Right-click `company.local`.
2. Select `New → Organizational Unit`.
3. Enter `Departments`.
4. Right-click `Departments`.
5. Create IT, HR, Accounting, and Management.

### Create OUs Using PowerShell

Script location:

```text
scripts/phase-2/create-ou.ps1
```

The script:

- Retrieves the current domain Distinguished Name.
- Creates the parent OU `Departments`.
- Creates department OUs.
- Checks whether an OU already exists before creating it.
- Enables accidental deletion protection.

Run the script:

```powershell
Set-ExecutionPolicy -Scope Process Bypass

.\create-ou.ps1
```

Verify:

```powershell
Get-ADOrganizationalUnit -Filter * |
    Select-Object Name, DistinguishedName
```

## 7. Create Users and Security Groups

Active Directory uses users and security groups to manage identity and access permissions.

### Department Groups

| Department | Security Group |
| ---------- | -------------- |
| IT         | GG_IT          |
| HR         | GG_HR          |
| Accounting | GG_Accounting  |
| Management | GG_Management  |

### Planned User Accounts

| Department | Username  | Display Name     |
| ---------- | --------- | ---------------- |
| IT         | it.admin  | IT Admin         |
| IT         | it.user   | IT User          |
| HR         | hr.admin  | HR Admin         |
| HR         | hr.user   | HR User          |
| Accounting | acc.admin | Accounting Admin |
| Accounting | acc.user  | Accounting User  |
| Management | manager01 | Manager 01       |
| Management | manager02 | Manager 02       |

### Create Users Using GUI

1. Open Active Directory Users and Computers.
2. Navigate to the appropriate department OU.
3. Right-click and select `New → User`.
4. Enter the user's first name, last name, and logon name.
5. Configure an initial password.
6. Complete the wizard.

### Create Security Groups Using GUI

1. Navigate to the department OU.
2. Right-click and select `New → Group`.
3. Enter the group name.
4. Select `Global` as Group Scope.
5. Select `Security` as Group Type.
6. Click OK.

### Add Users to Groups

1. Open the department Security Group.
2. Select the Members tab.
3. Click Add.
4. Enter the appropriate username.
5. Click Check Names and OK.

### PowerShell Management

Planned scripts:

```text
scripts/phase-2/
│
├── create-ou.ps1
├── create-groups.ps1
├── create-users.ps1
├── add-users-to-groups.ps1
├── reset-password.ps1
└── disable-user.ps1
```

These scripts will automate repetitive Active Directory administration tasks.

Scripts should check whether objects already exist before creating them to avoid duplicate-object errors.

## 8. Verify Active Directory Objects

### List Organizational Units

```powershell
Get-ADOrganizationalUnit -Filter * |
    Select-Object Name, DistinguishedName
```

### List Domain Users

```powershell
Get-ADUser -Filter * |
    Select-Object Name, SamAccountName
```

### List Security Groups

```powershell
Get-ADGroup -Filter * |
    Select-Object Name, GroupScope, GroupCategory
```

### Check Group Members

```powershell
Get-ADGroupMember -Identity GG_IT
```

### Check a Specific User

```powershell
Get-ADUser -Identity it.user
```

## 9. Current Implementation Status

The following items have been implemented and verified in the lab.

| Task                                | Status               |
| ----------------------------------- | -------------------- |
| Install Windows Server 2022         | Completed in Phase 1 |
| Configure server network            | Completed in Phase 1 |
| Install AD DS role                  | Completed            |
| Promote server to Domain Controller | Completed            |
| Create domain company.local         | Completed            |
| Create Departments OU               | Completed            |
| Create IT OU                        | Completed            |
| Create HR OU                        | Completed            |
| Create Accounting OU                | Completed            |
| Create Management OU                | Completed            |
| Create GG_IT security group         | Completed            |
| Create IT Admin user                | Completed            |
| Create IT User account              | Completed            |
| Create remaining department groups  | Pending              |
| Create remaining department users   | Pending              |
| Verify all group memberships        | Pending              |

## 10. Troubleshooting

### Issue 1: Active Directory Module Not Found

Error:

```text
Get-ADDomain : The term is not recognized
```

Solution:

```powershell
Import-Module ActiveDirectory
```

### Issue 2: OU Already Exists

When running a script multiple times, PowerShell may report that an OU already exists.

Solution:

Use `Get-ADOrganizationalUnit` to check for existing objects before running `New-ADOrganizationalUnit`.

### Issue 3: DNS Resolution Failed

Check the DNS configuration:

```powershell
ipconfig /all
```

Verify that the DNS server points to:

```text
192.168.50.10
```

Test DNS:

```powershell
nslookup company.local
```

## 11. Git Commit

After completing Phase 2, commit the changes:

```bash
git add .
git commit -m "feat(ad): configure Active Directory domain services"
git push origin main
```

## 12. Next Phase

### Phase 3 – Domain Client Integration

The next phase will focus on joining a Windows 11 client to the Active Directory domain.

Planned tasks:

- Configure Windows 11 client network settings.
- Set the client DNS server to the Domain Controller.
- Join Windows 11 to `company.local`.
- Log in using domain user accounts.
- Verify domain authentication.
- Test centralized user management.

---

**Project:** Windows Server Infrastructure Lab  
**Phase:** 2 – Active Directory  
**Domain:** company.local  
**Server:** WS2022-DC01  
**Status:** In Progress
