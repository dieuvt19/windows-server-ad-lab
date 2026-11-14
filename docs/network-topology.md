# Network Topology

## 1. Overview

This document describes the network architecture and IP addressing plan used in the Windows Server and Active Directory lab.

The lab uses Oracle VirtualBox with NAT and Internal Network adapters.

## 2. Network Architecture

The lab consists of two virtual machines:

- `WS2022-DC01` – Windows Server 2022, planned Domain Controller.
- `WIN11-CLIENT01` – Windows 11 Pro client.

Each VM has two network adapters:

| Adapter   | Network Mode     | Purpose                       |
| --------- | ---------------- | ----------------------------- |
| Adapter 1 | NAT              | Internet access               |
| Adapter 2 | Internal Network | Communication between lab VMs |

The Internal Network is named `AD-LAB`.

## 3. Network Diagram

The planned network architecture is shown below:

![Network Architecture](../diagrams/network-architecture.png)

## 4. IP Addressing Plan

The lab uses the private network `192.168.50.0/24`.

| Device         | Hostname       | IP Address    | Subnet Mask   |
| -------------- | -------------- | ------------- | ------------- |
| Windows Server | WS2022-DC01    | 192.168.50.10 | 255.255.255.0 |
| Windows Client | WIN11-CLIENT01 | 192.168.50.20 | 255.255.255.0 |

### Network Details

| Property        | Value                       |
| --------------- | --------------------------- |
| Network Name    | AD-LAB                      |
| Network Type    | VirtualBox Internal Network |
| Network Address | 192.168.50.0/24             |
| Subnet Mask     | 255.255.255.0               |
| Planned Domain  | company.local               |

The IP addresses above are configured on the Internal Network adapters only.

## 5. DNS Configuration

The planned DNS server for the lab is:

| Device         | DNS Server    |
| -------------- | ------------- |
| WIN11-CLIENT01 | 192.168.50.10 |

After Active Directory Domain Services and DNS are installed, the client will use the Domain Controller as its DNS server to locate domain services.

Do not configure the client to use a public DNS server as its primary DNS server on the domain-connected network adapter.

## 6. Default Gateway

The Internal Network adapter is an isolated lab network.

No default gateway is required on this adapter for the initial lab setup.

The NAT adapter is kept separate to provide Internet access.

## 7. Connectivity Verification

From the Windows Client VM, run:

```powershell
ping 192.168.50.10
```

To inspect network configuration:

```powershell
ipconfig /all
```

To test DNS resolution after DNS has been configured:

```powershell
nslookup company.local 192.168.50.10
```

## 8. Design Considerations

- NAT provides Internet access without exposing the lab machines directly to the physical network.
- Internal Network isolates lab communication from the physical LAN.
- Static IP addresses make server and client configurations predictable.
- The Domain Controller will provide DNS services for the Active Directory domain.

**Note:** `company.local` is used for this isolated learning lab. For production environments, an organization should generally use an appropriate subdomain of a domain it owns.
