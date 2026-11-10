# Phase 4: Organizational Structure, Security Groups and Domain-Joined Client

> **Status:** Complete | **Domain:** `corp.local` | **Platform:** VirtualBox

| | |
|---|---|
| **Goal** | Model a small company in Active Directory (OUs, groups, users) and prove the domain works by joining a Windows 11 client. |
| **Servers / Clients** | `DC01` (Windows Server 2025, `192.168.10.10`) and `CL01` (Windows 11 Enterprise Evaluation) |
| **Network** | VirtualBox Internal Network `corpnet`, `192.168.10.0/24`, DHCP scope `192.168.10.100-200` |
| **Result** | Three departments, three security groups, three test users, and one client that receives DHCP, resolves DNS, and authenticates domain users. |

---

## 1. Design

The structure separates **users**, **computers** and **groups**, so that Group Policy (Phase 5) can target each department and device type independently.

```
corp.local
└── Corp
    ├── Users
    │   ├── HR
    │   ├── IT
    │   └── Sales
    ├── Computers
    │   ├── Workstations
    │   └── Servers
    └── Groups
```

| Test user | Logon name | Department OU | Security group |
|---|---|---|---|
| Amina Test | `atest` | HR | `GG-HR` |
| Ben Test | `btest` | IT | `GG-IT` |
| Chidi Test | `ctest` | Sales | `GG-Sales` |

**Naming convention:** the `GG-` prefix marks a **Global** security group, so a group's scope is clear from its name alone.

**Design decision:** OUs organize objects and receive policies; groups grant access to resources. Both are used so departments can be managed for policy *and* permissions.

---

## 2. Implementation: OUs, Groups and Users (DC01)

1. Opened **Active Directory Users and Computers** (Tools menu in Server Manager).
2. Created the `Corp` OU under `corp.local`, then the child OUs shown above, with **Protect from accidental deletion** left enabled.
3. Created three **Global** security groups in `Corp\Groups`: `GG-HR`, `GG-IT`, `GG-Sales`.
4. Created one test user per department OU (fake names and a lab-only password) and added each to the matching group.

<div align="center">
  <img src="../screenshots/04-ou-tree-and-groups.png" alt="OU hierarchy and security groups in Active Directory Users and Computers" width="700">
  <br>
  <sub><b>Figure 1.</b> OU hierarchy and the three Global security groups (<code>GG-HR</code>, <code>GG-IT</code>, <code>GG-Sales</code>) in Active Directory Users and Computers.</sub>
</div>

<br>

<div align="center">
  <img src="../screenshots/04-gg-hr-members.png" alt="GG-HR group Members tab" width="500">
  <br>
  <sub><b>Figure 2.</b> <code>GG-HR</code> Members tab showing the HR test user.</sub>
</div>

<br>

### Verification (PowerShell)

```powershell
Get-ADOrganizationalUnit -Filter * | Select Name
Get-ADGroupMember GG-HR
```

<div align="center">
  <img src="../screenshots/04-powershell-verification.png" alt="PowerShell verification output" width="700">
  <br>
  <sub><b>Figure 3.</b> PowerShell output listing the OUs and the members of <code>GG-HR</code>.</sub>
</div>

<br>

---

## 3. Implementation: Windows 11 Client (CL01)

1. Created the `CL01` VM (4 GB RAM, 2 CPUs, 64 GB disk) with a single network adapter on the Internal Network `corpnet`, so it can only communicate with `DC01`.
2. Installed Windows 11 Enterprise Evaluation (Home editions cannot join a domain) and the VirtualBox Guest Additions.
3. Confirmed that DHCP and DNS from Phase 3 work before joining the domain.
4. Joined the machine to `corp.local` using `sysdm.cpl` and restarted.
5. Signed in as a domain user, then moved the computer object into `Corp\Computers\Workstations`.

### Network verification

<div align="center">
  <img src="../screenshots/04-client-ipconfig.png" alt="ipconfig /all on CL01" width="700">
  <br>
  <sub><b>Figure 4.</b> <code>ipconfig /all</code> on <code>CL01</code>: DHCP address in the 192.168.10.100-200 range, DNS <code>192.168.10.10</code>, suffix <code>corp.local</code>.</sub>
</div>

<br>

<div align="center">
  <img src="../screenshots/04-client-connectivity.png" alt="ping and nslookup results on CL01" width="700">
  <br>
  <sub><b>Figure 5.</b> <code>ping</code> and <code>nslookup</code> from <code>CL01</code> reaching <code>DC01</code> and resolving <code>corp.local</code>.</sub>
</div>

<br>

### Domain join

<div align="center">
  <img src="../screenshots/04-client-domain-join-welcome.png" alt="Welcome to the corp.local domain message" width="500">
  <br>
  <sub><b>Figure 6.</b> Welcome message after joining <code>CL01</code> to <code>corp.local</code>.</sub>
</div>

<br>

<div align="center">
  <img src="../screenshots/04-whoami.png" alt="whoami and hostname output" width="600">
  <br>
  <sub><b>Figure 7.</b> <code>whoami</code> and <code>hostname</code> showing <code>CORP\atest</code> signed in on <code>CL01</code>.</sub>
</div>

<br>

<div align="center">
  <img src="../screenshots/04-device-name.png" alt="Settings About page showing CL01.corp.local" width="600">
  <br>
  <sub><b>Figure 8.</b> Device name <code>CL01.corp.local</code> in Settings &rarr; System &rarr; About.</sub>
</div>

<br>

### Computer placement

New computers land in the default `Computers` container, which cannot be targeted cleanly by Group Policy. `CL01` was moved into `Corp\Computers\Workstations` so Phase 5 policies can apply to it.

<div align="center">
  <img src="../screenshots/04-cl01-in-workstations.png" alt="CL01 inside the Workstations OU" width="700">
  <br>
  <sub><b>Figure 9.</b> <code>CL01</code> inside the <code>Workstations</code> OU, ready for Group Policy.</sub>
</div>

<br>

---

## 4. Results

| Check | Evidence | Result |
|---|---|---|
| OU hierarchy built as designed | Figures 1, 3 | Pass |
| Security groups created (Global) | Figure 1 | Pass |
| Users assigned to correct groups | Figure 2 | Pass |
| Client receives DHCP and DNS settings | Figures 4, 5 | Pass |
| Client joined to `corp.local` | Figures 6, 8 | Pass |
| Domain user can sign in | Figure 7 | Pass |
| Client placed in target OU | Figure 9 | Pass |

---

## 5. Key Concepts

- **OU (Organizational Unit):** a container used to organize objects and to link Group Policy.
- **Security group:** a collection of accounts used to grant access to resources.
- **Domain join:** the process that makes a computer trust the domain controller for authentication.
- **Why DNS matters:** a client finds the domain controller through DNS records, so a client with the wrong DNS server cannot join.

---

## 6. Troubleshooting Reference

| Symptom | Likely cause | Fix |
|---|---|---|
| Client has a `169.254.x.x` address | DHCP not reaching the client | Check both VMs use the same internal network name (`corpnet`), the scope is activated, and DHCP is bound to the Corpnet adapter. Then run `ipconfig /release` and `ipconfig /renew`. |
| "Domain could not be contacted" | Client cannot resolve the domain | Confirm DNS is `192.168.10.10` and that `nslookup corp.local` succeeds. |
| Domain sign-in rejected | Wrong username format or password | Use `CORP\username`, or reset the password in ADUC. |
| Windows 11 setup blocks the install | VM lacks TPM 2.0 or EFI | Enable EFI and TPM 2.0 in VM settings. |

---

## 7. Next Step

**Phase 5: Group Policy.** Apply a wallpaper policy, a password and security baseline, and a software restriction to the OUs built here, and verify them from `CL01`.
