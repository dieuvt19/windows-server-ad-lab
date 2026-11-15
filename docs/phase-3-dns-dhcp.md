# Phase 3 – DNS & DHCP Configuration

## 1. Overview

This phase focuses on configuring DNS (Domain Name System) and DHCP (Dynamic Host Configuration Protocol) services on Windows Server 2022.

The objective is to provide centralized name resolution and automatic IP address assignment for client machines within the Active Directory lab environment.

### Objectives

- Configure and verify the DNS Server role.
- Create and manage DNS records.
- Configure Forward and Reverse Lookup Zones.
- Configure DNS Forwarders.
- Install and authorize the DHCP Server role.
- Create and configure DHCP scopes.
- Enable automatic IP assignment for Windows 11 clients.
- Test DNS resolution and DHCP functionality.

---

## 2. Network Configuration

### Lab Environment

| Component         | Configuration                   |
| ----------------- | ------------------------------- |
| Domain Controller | WS2022-DC01                     |
| Operating System  | Windows Server 2022             |
| Client Machine    | WIN11-CLIENT01                  |
| Client OS         | Windows 11                      |
| Domain Name       | company.local                   |
| Network           | 192.168.50.0/24                 |
| Subnet Mask       | 255.255.255.0                   |
| Server IP         | 192.168.50.10                   |
| DHCP Range        | 192.168.50.100 – 192.168.50.200 |
| DNS Server        | 192.168.50.10                   |

### Network Topology

```text
                  Internet
                     |
               VirtualBox NAT
                     |
          +----------------------+
          |    WS2022-DC01       |
          |    Windows Server    |
          |                      |
          |  AD DS               |
          |  DNS Server          |
          |  DHCP Server         |
          |                      |
          |  192.168.50.10       |
          +----------------------+
                     |
                AD-LAB Network
                192.168.50.0/24
                     |
          +----------------------+
          |    WIN11-CLIENT01    |
          |    Windows 11        |
          |                      |
          |  DHCP Client         |
          |  DNS Client          |
          |                      |
          |  Dynamic IP          |
          +----------------------+
```

### VirtualBox Network Adapters

| Machine        | Adapter   | Network Mode              |
| -------------- | --------- | ------------------------- |
| WS2022-DC01    | Adapter 1 | NAT                       |
| WS2022-DC01    | Adapter 2 | Internal Network (AD-LAB) |
| WIN11-CLIENT01 | Adapter 1 | NAT                       |
| WIN11-CLIENT01 | Adapter 2 | Internal Network (AD-LAB) |

**Note:** The internal network is used for communication between the Domain Controller and Windows 11 client. DHCP should be bound only to the internal network adapter.

---

## 3. DNS Server Configuration

### 3.1. Verify DNS Server Role

Open Server Manager and navigate to:

```text
Manage → Add Roles and Features
```

Verify that the DNS Server role is installed.

Alternatively, use PowerShell:

```powershell
Get-WindowsFeature DNS
Get-Service DNS
```

If DNS is already installed during Active Directory Domain Services promotion, reinstalling it is unnecessary.

### 3.2. Open DNS Manager

Open DNS Manager:

```powershell
dnsmgmt.msc
```

Navigate to:

```text
DNS
 └── WS2022-DC01
      ├── Forward Lookup Zones
      └── Reverse Lookup Zones
```

### 3.3. Configure Forward Lookup Zone

Verify that the Active Directory-integrated DNS zone exists:

```text
company.local
```

If the zone does not exist, create it:

1. Right-click Forward Lookup Zones.
2. Select New Zone.
3. Choose Primary Zone.
4. Select Store the zone in Active Directory, if available.
5. Enter the zone name: `company.local`.
6. Configure secure dynamic updates.
7. Complete the wizard.

### 3.4. Create DNS A Record

Create an A Record for the Domain Controller.

Navigate to:

```text
Forward Lookup Zones
 └── company.local
```

Right-click and select New Host (A or AAAA).

Configure:

| Field      | Value         |
| ---------- | ------------- |
| Name       | WS2022-DC01   |
| IP Address | 192.168.50.10 |

Expected DNS record:

```text
WS2022-DC01.company.local → 192.168.50.10
```

### 3.5. Configure Reverse Lookup Zone

Create a Reverse Lookup Zone to resolve IP addresses to hostnames.

Steps:

1. Right-click Reverse Lookup Zones.
2. Select New Zone.
3. Choose Primary Zone.
4. Select IPv4 Reverse Lookup Zone.
5. Enter Network ID: `192.168.50`.
6. Configure the appropriate dynamic update settings.
7. Complete the wizard.

Expected PTR record:

```text
192.168.50.10 → WS2022-DC01.company.local
```

### 3.6. Configure DNS Forwarders

DNS Forwarders allow the internal DNS Server to resolve external domain names.

Navigate to:

```text
DNS Manager
 └── WS2022-DC01
      └── Properties
           └── Forwarders
```

Configure:

| DNS Provider   | IP Address |
| -------------- | ---------- |
| Google DNS     | 8.8.8.8    |
| Cloudflare DNS | 1.1.1.1    |

**Note:** DNS Forwarders are used for external DNS queries. Internal domain queries for `company.local` are resolved by the internal DNS Server.

---

## 4. DHCP Server Installation

### 4.1. Install DHCP Server Role

Open Server Manager.

Navigate to:

```text
Manage → Add Roles and Features
```

Steps:

1. Select Role-based or feature-based installation.
2. Select WS2022-DC01.
3. Select DHCP Server.
4. Add required features.
5. Complete the installation wizard.

### 4.2. Complete DHCP Configuration

After installation, select Complete DHCP Configuration in Server Manager if prompted.

Use an account with appropriate Active Directory permissions to authorize the DHCP Server.

### 4.3. Open DHCP Manager

Run:

```powershell
dhcpmgmt.msc
```

Expected structure:

```text
DHCP
 └── WS2022-DC01.company.local
      └── IPv4
```

### 4.4. Authorize DHCP Server

In DHCP Manager:

1. Right-click the DHCP Server.
2. Select Authorize.
3. Wait for authorization.
4. Refresh the DHCP console.

Verify authorization using PowerShell:

```powershell
Get-DhcpServerInDC
```

---

## 5. DHCP Scope Configuration

### 5.1. Create a New Scope

In DHCP Manager:

1. Expand the DHCP Server.
2. Right-click IPv4.
3. Select New Scope.
4. Enter the following information.

| Field       | Value                                                |
| ----------- | ---------------------------------------------------- |
| Scope Name  | AD-LAB-Scope                                         |
| Description | DHCP scope for internal Active Directory lab network |

### 5.2. Configure IP Address Range

| Configuration    | Value          |
| ---------------- | -------------- |
| Start IP Address | 192.168.50.100 |
| End IP Address   | 192.168.50.200 |
| Subnet Mask      | 255.255.255.0  |
| Prefix Length    | /24            |
| Lease Duration   | 8 days         |

The DHCP Server will assign IP addresses within this range.

### 5.3. Configure Exclusions

No exclusions are required for the initial configuration because the DHCP range does not overlap with the Domain Controller's static IP address.

Additional exclusions can be configured when necessary.

### 5.4. Configure DHCP Options

Configure the following DHCP options:

**Option 003 – Router**

Leave blank because the lab's internal network does not currently have a dedicated router or gateway.

**Option 006 – DNS Servers**

```text
192.168.50.10
```

**Option 015 – DNS Domain Name**

```text
company.local
```

Expected DHCP configuration:

```text
AD-LAB-Scope
 ├── Address Pool
 │    └── 192.168.50.100 - 192.168.50.200
 │
 ├── Address Leases
 │
 └── Scope Options
      ├── 006 DNS Servers
      │    └── 192.168.50.10
      │
      └── 015 DNS Domain Name
           └── company.local
```

### 5.5. Activate DHCP Scope

Select:

```text
Yes, I want to activate this scope now.
```

Complete the wizard.

Verify that the scope is active.

### 5.6. Configure DHCP Bindings

Because the Domain Controller has two network adapters, configure DHCP to listen only on the internal network adapter.

Navigate to:

```text
DHCP Manager
 └── Server Properties
      └── Advanced
           └── Bindings
```

Enable the adapter associated with:

```text
AD-LAB
192.168.50.10
```

Do not enable DHCP binding on the NAT adapter.

---

## 6. Windows 11 DHCP Client Configuration

### 6.1. Verify VirtualBox Network Settings

Ensure that WIN11-CLIENT01 has the following network configuration:

| Adapter   | Network                   |
| --------- | ------------------------- |
| Adapter 1 | NAT                       |
| Adapter 2 | Internal Network – AD-LAB |

### 6.2. Configure Automatic IP Assignment

On Windows 11:

1. Open Network Connections using `ncpa.cpl`.
2. Right-click the Ethernet adapter associated with AD-LAB.
3. Select Properties.
4. Select Internet Protocol Version 4 (TCP/IPv4).
5. Select Obtain an IP address automatically.
6. Select Obtain DNS server address automatically.
7. Save the configuration.

Alternatively, use PowerShell as Administrator.

Identify the correct network adapter:

```powershell
Get-NetAdapter
```

Enable DHCP on the internal adapter:

```powershell
Set-NetIPInterface -InterfaceAlias "Ethernet 2" -Dhcp Enabled

Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ResetServerAddresses
```

Replace `Ethernet 2` with the actual adapter name.

### 6.3. Renew DHCP Lease

Run the following commands:

```powershell
ipconfig /release
ipconfig /renew
```

Verify the configuration:

```powershell
ipconfig /all
```

Expected configuration:

```text
IPv4 Address:       192.168.50.100 - 192.168.50.200
Subnet Mask:        255.255.255.0
DHCP Server:        192.168.50.10
DNS Server:         192.168.50.10
DNS Suffix:         company.local
```

The actual IP address depends on DHCP availability.

---

## 7. Testing and Verification

### 7.1. Verify DNS Service

On Windows Server:

```powershell
Get-Service DNS
```

Expected status:

```text
Status: Running
```

### 7.2. Verify DNS Zones

```powershell
Get-DnsServerZone
```

Verify that `company.local` exists.

### 7.3. Verify DNS Records

```powershell
Get-DnsServerResourceRecord -ZoneName "company.local"
```

### 7.4. Verify DHCP Service

```powershell
Get-Service DHCPServer
```

Expected status:

```text
Status: Running
```

### 7.5. Verify DHCP Scope

```powershell
Get-DhcpServerv4Scope
```

### 7.6. Verify DHCP Leases

```powershell
Get-DhcpServerv4Lease -ScopeId 192.168.50.0
```

Verify that WIN11-CLIENT01 has received an IP address.

### 7.7. Test DNS Resolution

On Windows 11:

```powershell
nslookup WS2022-DC01.company.local
```

Expected result:

```text
Name:    WS2022-DC01.company.local
Address: 192.168.50.10
```

Test the internal domain:

```powershell
nslookup company.local
```

Test external DNS resolution:

```powershell
nslookup google.com
```

### 7.8. Test Network Connectivity

Test connectivity to the Domain Controller:

```powershell
ping 192.168.50.10
```

Test hostname resolution and connectivity:

```powershell
ping WS2022-DC01.company.local
```

**Note:** Ping may be blocked by Windows Firewall. A failed ping does not necessarily mean DNS or DHCP is misconfigured.

---

## 8. Troubleshooting

| Issue                                     | Possible Cause                            | Solution                                        |
| ----------------------------------------- | ----------------------------------------- | ----------------------------------------------- |
| Client receives 169.254.x.x               | DHCP unavailable                          | Check DHCP service, scope and network adapter   |
| DHCP does not assign an IP                | Server not authorized                     | Authorize DHCP Server in Active Directory       |
| Client receives incorrect DNS             | DHCP Option 006 misconfigured             | Set DNS Server to 192.168.50.10                 |
| Internal domain cannot resolve            | DNS zone or records missing               | Verify Forward Lookup Zone and A Records        |
| Reverse lookup fails                      | PTR record missing                        | Create or verify Reverse Lookup Zone            |
| DHCP does not respond on internal network | Incorrect adapter binding                 | Enable the AD-LAB adapter binding               |
| External DNS resolution fails             | Forwarders or Internet connectivity issue | Verify DNS Forwarders and NAT connectivity      |
| Ethernet Properties access denied         | Insufficient administrative privileges    | Use an authorized local or domain administrator |

Useful diagnostic commands:

```powershell
# Check network adapters
Get-NetAdapter

# Check IP configuration
Get-NetIPConfiguration

# Check DNS service
Get-Service DNS

# Check DHCP service
Get-Service DHCPServer

# Check DNS zones
Get-DnsServerZone

# Check DHCP scopes
Get-DhcpServerv4Scope

# Check DHCP authorization
Get-DhcpServerInDC
```

---

## 9. Security Considerations

- Use static IP addresses for infrastructure servers.
- Keep DHCP restricted to the internal lab network.
- Use secure dynamic DNS updates for Active Directory-integrated zones.
- Avoid granting Domain Admin privileges to regular users.
- Use least-privilege access for administrative tasks.
- Keep DNS and DHCP services restricted to authorized network interfaces.

---

## 10. Phase 3 Completion Checklist

- [ ] Verify DNS Server Role installation.
- [ ] Verify company.local Forward Lookup Zone.
- [ ] Create or verify Domain Controller A Record.
- [ ] Configure Reverse Lookup Zone.
- [ ] Create or verify PTR Record.
- [ ] Configure DNS Forwarders.
- [ ] Install DHCP Server Role.
- [ ] Authorize DHCP Server.
- [ ] Create AD-LAB-Scope.
- [ ] Configure DHCP IP address range.
- [ ] Configure DHCP Option 006 – DNS Server.
- [ ] Configure DHCP Option 015 – DNS Domain Name.
- [ ] Activate DHCP Scope.
- [ ] Configure DHCP adapter bindings.
- [ ] Configure Windows 11 for automatic IP assignment.
- [ ] Verify DHCP Lease.
- [ ] Test internal DNS resolution.
- [ ] Test external DNS resolution.
- [ ] Test network connectivity.

---

## 11. Expected Outcome

After completing Phase 3:

- Windows Server 2022 provides DNS resolution for the Active Directory domain.
- DHCP automatically assigns IP addresses to Windows 11 clients.
- Clients receive the correct internal DNS Server address.
- Internal hostnames can be resolved through DNS.
- External DNS queries can be forwarded to public DNS providers, provided Internet connectivity is available.

The lab environment is now ready for the next phase of Windows Server infrastructure configuration.

---

**Project:** Windows Server 2022 – Active Directory Infrastructure Lab

**Phase:** 3 – DNS & DHCP Configuration

**Status:** Planned / In Progress / Completed
