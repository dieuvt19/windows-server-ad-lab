# windows-server-ad-lab

# Windows Server & Active Directory Lab

A hands-on IT infrastructure project focused on Windows Server administration, Active Directory, network services, virtualization, and enterprise IT management.

This project simulates the IT infrastructure of a small company with multiple departments, centralized user management, network configuration, security policies, and shared resources.

**Project Status:** In Progress
**Level:** Beginner → Intermediate
**Focus:** System Administration / IT Infrastructure
**Target Career:** Fachinformatiker für Systemintegration (FISI)

---

## 1. Project Objectives

The main goal is to build and manage a small business IT infrastructure in a virtualized environment.

Through this project, I aim to gain practical experience in:

- Installing and configuring Windows Server.
- Managing users and computers with Active Directory.
- Configuring DNS and DHCP services.
- Creating and managing Group Policy Objects (GPO).
- Managing file sharing and access permissions.
- Understanding virtualization and virtual networking.
- Troubleshooting common IT infrastructure problems.
- Automating administrative tasks with PowerShell.

## 2. Lab Environment

### Physical Hardware

| Device         | Specifications                                     | Role                                  |
| -------------- | -------------------------------------------------- | ------------------------------------- |
| Windows PC     | Intel Core i7 / AMD Ryzen 7, 16 GB RAM, 512 GB SSD | Virtualization Host                   |
| MacBook Air M4 | Apple Silicon                                      | Remote Administration & Documentation |

### Software and Technologies

| Technology                       | Purpose                            |
| -------------------------------- | ---------------------------------- |
| Windows 10                       | Host Operating System              |
| Oracle VirtualBox                | Virtualization Platform            |
| Windows Server 2022              | Server Operating System            |
| Windows 11 Pro                   | Client Operating System            |
| Active Directory Domain Services | Centralized Identity Management    |
| DNS Server                       | Name Resolution                    |
| DHCP Server                      | Automatic IP Address Assignment    |
| Group Policy                     | Centralized Security Configuration |
| PowerShell                       | System Administration Automation   |

## 3. Network Architecture

The lab uses an isolated virtual network to simulate a small company's internal IT infrastructure.

### Network Diagram

```text
                 PHYSICAL HARDWARE
                 Windows 10 Host
                        |
                    VirtualBox
                        |
             +----------+----------+
             |                     |
       Windows Server          Windows 11
          VM 01                  VM 02
             |                     |
       Domain Controller       Domain Client
             |                     |
       +-----+------+              |
       |            |              |
      DNS          AD DS           |
       |            |              |
       +------------+--------------+
                    |
             Internal Network
                  AD-LAB
              192.168.50.0/24
```

### Network Configuration

| Component       | Configuration               |
| --------------- | --------------------------- |
| Network Name    | AD-LAB                      |
| Network Type    | VirtualBox Internal Network |
| Network Address | 192.168.50.0/24             |
| Domain Name     | company.local               |

### IP Address Plan

| Device            | Hostname       | IP Address    |
| ----------------- | -------------- | ------------- |
| Domain Controller | WS2022-DC01    | 192.168.50.10 |
| Windows Client    | WIN11-CLIENT01 | 192.168.50.20 |

Subnet Mask: `255.255.255.0`

The virtual machines will use two network adapters:

- Adapter 1: NAT for Internet access.
- Adapter 2: Internal Network (AD-LAB) for communication within the lab.

## 4. Virtual Machine Configuration

### VM 01 – Windows Server 2022

| Configuration     | Value                                   |
| ----------------- | --------------------------------------- |
| VM Name           | WS2022-DC01                             |
| Operating System  | Windows Server 2022 Standard Evaluation |
| Installation Type | Desktop Experience                      |
| RAM               | 4 GB                                    |
| CPU               | 2 vCPU                                  |
| Virtual Disk      | 80 GB                                   |
| Network           | NAT + AD-LAB                            |
| Main Role         | Domain Controller                       |

Planned server roles:

- Active Directory Domain Services (AD DS)
- DNS Server
- DHCP Server
- File and Storage Services
- Group Policy Management

### VM 02 – Windows 11 Pro

| Configuration    | Value          |
| ---------------- | -------------- |
| VM Name          | WIN11-CLIENT01 |
| Operating System | Windows 11 Pro |
| RAM              | 4 GB           |
| CPU              | 2 vCPU         |
| Virtual Disk     | 80 GB          |
| Network          | NAT + AD-LAB   |
| Main Role        | Domain Client  |

The client machine will be joined to the `company.local` domain.

## 5. Simulated Company Structure

The lab simulates a company with four departments.

| Department      | Organizational Unit |
| --------------- | ------------------- |
| IT              | OU=IT               |
| Human Resources | OU=HR               |
| Accounting      | OU=Accounting       |
| Management      | OU=Management       |

Each department will have its own users, security groups, and access permissions.

Example Active Directory structure:

```text
company.local
|
+-- OU=Company
    |
    +-- OU=IT
    |   +-- Users
    |   +-- Computers
    |
    +-- OU=HR
    |   +-- Users
    |   +-- Computers
    |
    +-- OU=Accounting
    |   +-- Users
    |   +-- Computers
    |
    +-- OU=Management
        +-- Users
        +-- Computers
```

## 6. Implementation Roadmap

### Phase 1 – Virtualization & Network Setup

**Status:** In Progress

- [x] Install Oracle VirtualBox.
- [x] Download Windows Server 2022 Evaluation ISO.
- [x] Download Windows 11 Pro ISO.
- [x] Create Windows Server virtual machine.
- [x] Create Windows 11 client virtual machine.
- [x] Configure NAT and Internal Network.
- [x] Configure static IP addresses.
- [x] Test connectivity between virtual machines.

### Phase 2 – Active Directory Domain Services

**Status:** Planned

- [x] Install Active Directory Domain Services.
- [x] Promote Windows Server to Domain Controller.
- [x] Create the `company.local` domain.
- [x] Create Organizational Units (OUs).
- [x] Create users and security groups.
- [x] Join Windows 11 client to the domain.
- [x] Test domain authentication.

### Phase 3 – DNS & DHCP Configuration

**Status:** Planned

- [x] Configure DNS Server.
- [x] Create and configure DNS records.
- [x] Install DHCP Server.
- [x] Configure DHCP scopes.
- [x] Configure automatic IP assignment.
- [x] Test DNS resolution and DHCP functionality.

### Phase 4 – Group Policy Management

**Status:** Planned

- [ ] Configure password policies.
- [ ] Configure account lockout policies.
- [ ] Configure automatic screen locking.
- [ ] Apply policies to specific Organizational Units.
- [ ] Test policy application using `gpupdate` and `gpresult`.

### Phase 5 – File Server & Access Control

**Status:** Planned

- [ ] Create shared folders for each department.
- [ ] Configure NTFS permissions.
- [ ] Configure SMB shared folder permissions.
- [ ] Assign access permissions using security groups.
- [ ] Test access restrictions between departments.

### Phase 6 – Troubleshooting & Documentation

**Status:** Planned

- [ ] Troubleshoot DNS issues.
- [ ] Troubleshoot domain authentication.
- [ ] Troubleshoot Group Policy issues.
- [ ] Analyze Windows Event Viewer logs.
- [ ] Document common infrastructure problems.
- [ ] Create system administration documentation.

## 7. PowerShell Automation

PowerShell will be used to automate repetitive administrative tasks.

Planned scripts:

| Script                   | Description                   |
| ------------------------ | ----------------------------- |
| `create-users.ps1`       | Create Active Directory users |
| `create-ou.ps1`          | Create Organizational Units   |
| `create-groups.ps1`      | Create security groups        |
| `assign-permissions.ps1` | Configure folder permissions  |
| `export-users.ps1`       | Export user information       |

## 8. Repository Structure

```text
windows-server-ad-lab/
│
├── README.md
│
├── docs/
│   ├── network-topology.md
│   ├── server-installation.md
│   ├── active-directory.md
│   ├── dns-dhcp.md
│   ├── group-policy.md
│   ├── file-server.md
│   └── troubleshooting.md
│
├── diagrams/
│   └── network-architecture.png
│
├── scripts/
│   ├── create-users.ps1
│   ├── create-ou.ps1
│   ├── create-groups.ps1
│   ├── assign-permissions.ps1
│   └── export-users.ps1
│
└── screenshots/
    ├── virtualbox/
    ├── windows-server/
    ├── active-directory/
    └── network/
```

## 9. Learning Outcomes

After completing this project, I expect to be able to:

- Understand the fundamentals of virtualization.
- Install and configure Windows Server.
- Deploy and manage an Active Directory domain.
- Manage users, groups, and computers.
- Configure DNS and DHCP services.
- Implement centralized security policies.
- Manage file sharing and access control.
- Use PowerShell for basic IT automation.
- Troubleshoot common Windows infrastructure issues.

## 10. Security Considerations

This project is designed for an isolated learning environment.

- Use test accounts instead of personal accounts.
- Do not store real company credentials.
- Keep the lab network isolated from production networks.
- Use strong passwords for administrative accounts.
- Do not expose Domain Controller services directly to the Internet.
- Keep VM snapshots and backups for recovery.

## 11. License & Evaluation

Windows Server 2022 is installed using Microsoft's Evaluation edition for educational and testing purposes.

This project does not include commercial Windows Server licensing.

Refer to Microsoft's official documentation for evaluation terms and licensing requirements.

---

**Author:** Personal IT Infrastructure Lab
**Project:** Windows Server & Active Directory Lab
**Career Focus:** Fachinformatiker für Systemintegration (FISI)

_Learning by building, testing, troubleshooting, and documenting real-world IT infrastructure._
