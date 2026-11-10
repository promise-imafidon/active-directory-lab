# Active Directory Lab with Automated User Provisioning

**Goal:** Build a simulated corporate Active Directory environment and automate new-hire onboarding with PowerShell.

This project models the identity and access management setup of a small company: a Windows Server domain controller, departmental structure, Group Policy, a domain-joined client, and (in progress) a PowerShell script that creates user accounts from a CSV of new hires.

> All names, accounts and passwords in this repository are fictional and used for lab purposes only.

---

## Lab Environment

| Component | Details |
|---|---|
| Hypervisor | Oracle VirtualBox |
| Domain controller | `DC01`, Windows Server 2025 (Evaluation), `192.168.10.10` |
| Client | `CL01`, Windows 11 Enterprise (Evaluation) |
| Domain | `corp.local` |
| Network | VirtualBox Internal Network `corpnet`, `192.168.10.0/24` |
| DHCP scope | `192.168.10.100` to `192.168.10.200` |

## Tools Used

- Windows Server 2025 (Evaluation)
- Windows 10/11 client VM
- Oracle VirtualBox
- PowerShell
- Active Directory, DNS, DHCP, Group Policy

## Skills Demonstrated

- Installing and promoting a Windows Server domain controller
- Configuring DNS and DHCP, and verifying them with `ipconfig`, `nslookup` and `dcdiag`
- Designing an OU structure and security groups by department
- Joining and managing a domain client
- Planned: Group Policy baselines and PowerShell-based user provisioning

---

## Project Status

**Current phase:** Phase 5, Group Policy (up next)

| Phase | Description | Status |
|---|---|---|
| 1 | Repository and documentation setup | ✅ Complete |
| 2 | Windows Server 2025 VM build and static IP | ✅ Complete |
| 3 | Domain Controller, DNS and DHCP | ✅ Complete |
| 4 | OUs, security groups and domain-joined client | ✅ Complete |
| 5 | Group Policy (wallpaper, security baseline, software restriction) | ⏳ Planned |
| 6 | PowerShell fundamentals | ⏳ Planned |
| 7 | CSV-driven user provisioning script | ⏳ Planned |
| 8 | Final polish and publishing | ⏳ Planned |

*Last updated: November 2026*

---

## Documentation

| Phase | Write-up |
|---|---|
| 2 | [VM build and static IP](docs/02-vm-build.md) |
| 3 | [Domain controller, DNS and DHCP](docs/03-domain-controller.md) |
| 4 | [OUs, groups and domain-joined client](docs/04-ous-groups-client.md) |

Each write-up covers the goal, the steps taken, the reasoning behind design choices, verification evidence and troubleshooting notes.

## Repository Structure

```
active-directory-lab/
├── docs/          Phase-by-phase write-ups
├── screenshots/   Evidence for each phase
├── scripts/       PowerShell scripts and sample CSV (fake data only)
├── configs/       Configuration notes and exports
├── LICENSE
└── README.md
```

## License

Released under the MIT License. See [LICENSE](LICENSE) for details.
