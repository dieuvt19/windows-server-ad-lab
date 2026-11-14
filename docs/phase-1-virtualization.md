# Phase 1 – Virtualization & Network Setup

## 1. Overview

The goal of this phase is to prepare a virtualized environment for building a Windows Server and Active Directory lab.

Oracle VirtualBox is used to run Windows Server and Windows client virtual machines on a physical Windows computer.

## 2. Lab Environment

### Host Machine

| Component               | Specification               |
| ----------------------- | --------------------------- |
| Operating System        | Windows 10                  |
| Processor               | Intel Core i7 / AMD Ryzen 7 |
| RAM                     | 16 GB                       |
| Storage                 | 512 GB SSD                  |
| Virtualization Software | Oracle VirtualBox           |

### Virtual Machines

#### Windows Server

| Setting           | Value                                   |
| ----------------- | --------------------------------------- |
| VM Name           | WS2022-DC01                             |
| Operating System  | Windows Server 2022 Standard Evaluation |
| Installation Type | Desktop Experience                      |
| RAM               | 4 GB                                    |
| CPU               | 2 vCPUs                                 |
| Storage           | 80 GB                                   |
| Network Adapter 1 | NAT                                     |
| Network Adapter 2 | Internal Network (AD-LAB)               |

#### Windows Client

| Setting           | Value                     |
| ----------------- | ------------------------- |
| VM Name           | WIN11-CLIENT01            |
| Operating System  | Windows 11 Pro            |
| RAM               | 4 GB                      |
| CPU               | 2 vCPUs                   |
| Storage           | 80 GB                     |
| Network Adapter 1 | NAT                       |
| Network Adapter 2 | Internal Network (AD-LAB) |

## 3. Implementation Steps

### Step 1 – Enable Hardware Virtualization

Verify that Intel VT-x or AMD-V virtualization is enabled in the computer's BIOS/UEFI.

In Windows, open Task Manager → Performance → CPU and check the Virtualization status.

### Step 2 – Install Oracle VirtualBox

Download and install Oracle VirtualBox:

https://www.virtualbox.org/wiki/Downloads

### Step 3 – Download Operating System ISOs

- Windows Server 2022 Evaluation ISO
- Windows 11 ISO

Official download sources:

- https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022
- https://www.microsoft.com/software-download/windows11

### Step 4 – Create Virtual Machines

Create two virtual machines in VirtualBox:

- WS2022-DC01
- WIN11-CLIENT01

Allocate CPU, memory, and virtual disk according to the configuration described above.

### Step 5 – Configure Network Adapters

Configure two network adapters for each virtual machine:

- Adapter 1: NAT – provides Internet access.
- Adapter 2: Internal Network – allows communication between lab machines.

Set the Internal Network name to `AD-LAB` on both virtual machines.

### Step 6 – Install Operating Systems

Install Windows Server 2022 Standard Evaluation with Desktop Experience on the server VM.

Install Windows 11 Pro on the client VM.

### Step 7 – Configure Static IP Addresses

Configure static IP addresses on the Internal Network adapters.

Refer to [Network Topology](network-topology.md) for the IP addressing plan.

### Step 8 – Verify Network Connectivity

Test communication between the two virtual machines using the `ping` command.

Example:

```powershell
ping 192.168.50.10
```

A successful reply confirms basic IP connectivity between the machines.

## 4. Completion Checklist

- [ ] Oracle VirtualBox installed.
- [ ] Windows Server VM created.
- [ ] Windows Client VM created.
- [ ] Operating systems installed.
- [ ] NAT adapters configured.
- [ ] Internal Network adapters configured.
- [ ] Static IP addresses configured.
- [ ] Network connectivity tested successfully.

Mark each item as completed only after verifying it in the lab.

## 5. Evidence

Store screenshots in the repository:

- `screenshots/virtualbox/` – VM configuration.
- `screenshots/windows-server/` – Windows Server desktop and configuration.
- `screenshots/network/` – IP configuration and connectivity tests.

## 6. Next Phase

**Phase 2 – Active Directory Domain Services (AD DS)**

The next phase will focus on:

- Installing the AD DS role.
- Promoting the server to a Domain Controller.
- Creating the Active Directory domain.
- Creating Organizational Units (OUs) and user accounts.
