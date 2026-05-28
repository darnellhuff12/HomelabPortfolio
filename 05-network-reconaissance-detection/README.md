

# Project 5: Network Reconnaissance Detection

## Objective

This project documents the detection of network reconnaissance activity inside the segmented homelab environment. The goal is to generate controlled scan traffic from the attacker VLAN, observe the activity from the Security Onion sensor, and validate that reconnaissance behavior can be detected using packet inspection, Security Onion dashboards, and supporting evidence captures.

This project builds on the previous homelab projects by moving from infrastructure validation into active security monitoring. Instead of only proving that VLANs, firewall rules, and port mirroring are configured correctly, this project demonstrates how the lab can be used to simulate attacker behavior and investigate that behavior from a defender perspective.

## Business & Security Value

Network reconnaissance is one of the earliest phases of an intrusion attempt. Attackers commonly scan internal networks to discover live hosts, open ports, running services, and potential attack paths. Detecting this behavior early gives defenders an opportunity to investigate suspicious activity before exploitation occurs.

This project demonstrates the ability to:

- Generate controlled reconnaissance traffic in an isolated lab environment.
- Monitor attacker-to-victim traffic using Security Onion.
- Validate that mirrored network traffic is reaching the sensor.
- Identify scan activity using packet captures, Zeek logs, Suricata alerts, or Security Onion dashboards.
- Document findings in a way that supports incident response and portfolio presentation.

## Lab Environment

The project uses the segmented homelab architecture created in the earlier projects.

| Component | Role |
| --- | --- |
| pfSense / Protectli | Firewall, routing, VLAN enforcement, DHCP |
| Netgear GS108T | Managed switch, VLAN tagging, port mirroring |
| Proxmox / Dell R730xd | Virtualization host for lab VMs |
| Kali Linux | Attacker system used to generate reconnaissance traffic |
| Victim VM / Victim Host | Target system used to receive scan traffic |
| Security Onion | Network security monitoring platform |
| Raspberry Pi 5 | Admin jump host and remote access point |

## Network Segments

| VLAN | Purpose | Example Use |
| --- | --- | --- |
| VLAN 20 | Attacker | Kali Linux scan source |
| VLAN 30 | SIEM / Security Onion Management | Security Onion web interface and management |
| VLAN 40 | Victim | Windows/Linux victim systems |
| VLAN 50 | Admin / Management | Raspberry Pi jump host, Proxmox, pfSense, switch, iDRAC |

## Scope

This project focuses on safe, controlled reconnaissance activity within the homelab only.

In scope:

- ICMP discovery scans.
- TCP SYN scans.
- Basic service/version detection scans.
- Security Onion alert and log review.
- Packet capture validation on the monitoring interface.
- Documentation of scan source, destination, timestamps, and detection results.

Out of scope:

- Scanning public IP addresses.
- Scanning networks or systems that are not owned or authorized.
- Exploitation of discovered services.
- Credential attacks.
- Destructive testing.

## Rules of Engagement

All testing must remain inside the homelab environment.

- Only scan authorized lab systems.
- Confirm the victim IP address before running scans.
- Capture timestamps for each test so Security Onion logs can be searched accurately.
- Avoid running aggressive scans against production/home devices.
- Do not expose vulnerable systems to the internet.

## Planned Test Activity

The following scan and validation activity was used to generate detection evidence.

| Test ID | Activity | Command / Validation Method | Expected Result |
| --- | --- | --- | --- |
| T01 | Attacker IP validation | `ip a` on Kali Linux | Kali is confirmed on the attacker VLAN with IP `192.168.20.100` |
| T02 | Victim IP validation | `ipconfig` on Windows victim | Victim is confirmed on the victim VLAN with IP `192.168.40.102` |
| T03 | Sensor health validation | `sudo so-status` on Security Onion | Security Onion services are running and healthy |
| T04 | Proxmox mirror bridge validation | Review `/etc/network/interfaces` | `vmbr1` is configured as the dedicated sniffing bridge with `bridge-ageing 0` |
| T05 | Packet capture validation | `sudo tcpdump -i enp6s19 -nn host 192.168.20.100 or host 192.168.40.102` | Security Onion monitor interface sees mirrored traffic between attacker and victim |
| T06 | TCP SYN scan | `nmap -sS 192.168.40.102` | Kali generates reconnaissance traffic against the victim |
| T07 | Security Onion Hunt review | Hunt query for attacker/victim IPs | Security Onion records Zeek connection logs for scan activity |

## Detection Workflow

1. Confirm the Kali attacker VM is assigned to VLAN 20 and has IP `192.168.20.100`.
2. Confirm the Windows victim is assigned to VLAN 40 and has IP `192.168.40.102`.
3. Confirm Security Onion services are running with `sudo so-status`.
4. Confirm the Proxmox `vmbr1` sniffing bridge is configured with `bridge-ageing 0` so mirrored/SPAN traffic is forwarded into the Security Onion VM.
5. Validate the Security Onion monitor interface using `tcpdump` on `enp6s19`.
6. Generate reconnaissance traffic from Kali using an Nmap TCP SYN scan.
7. Search Security Onion Hunt for traffic involving `192.168.20.100` and `192.168.40.102`.
8. Capture evidence showing the attacker, victim, sensor health, packet visibility, scan execution, and Security Onion logs.

## Evidence Captured

The following screenshots were captured and added to the `evidence/` folder.

| Evidence ID | Filename | Description |
| --- | --- | --- |
| E01 | [`01-kali-attacker-ip.png`](evidence/01-kali-attacker-ip.png) | Kali attacker VM assigned to VLAN 20 with IP `192.168.20.100`. |
| E02 | [`02-victim-ip.png`](evidence/02-victim-ip.png) | Windows victim assigned to VLAN 40 with IP `192.168.40.102`. |
| E03 | [`03-security-onion-sensor-status.png`](evidence/03-security-onion-sensor-status.png) | Security Onion services running and sensor stack healthy. |
| E04 | [`04-proxmox-vmbr1-bridge-ageing-fix.png`](evidence/04-proxmox-vmbr1-bridge-ageing-fix.png) | Proxmox `vmbr1` sniffing bridge configured with `bridge-ageing 0` so mirrored/SPAN traffic reaches the Security Onion VM. |
| E05 | [`05-monitor-interface-tcpdump.png`](evidence/05-monitor-interface-tcpdump.png) | Security Onion monitor interface `enp6s19` capturing mirrored ICMP traffic between the Kali attacker and Windows victim. |
| E06 | [`06-nmap-syn-scan.png`](evidence/06-nmap-syn-scan.png) | Kali running a TCP SYN scan against the Windows victim at `192.168.40.102`. |
| E07 | [`07-security-onion-syn-scan-logs.png`](evidence/07-security-onion-syn-scan-logs.png) | Security Onion Hunt showing Zeek connection logs from `192.168.20.100` to `192.168.40.102` across multiple destination ports. |

## Findings

| Test ID | Source | Destination | Activity | Security Onion Result | Status |
| --- | --- | --- | --- | --- | --- |
| T01 | Kali / VLAN 20 | N/A | Attacker IP validation | Kali confirmed as `192.168.20.100` | Complete |
| T02 | Windows victim / VLAN 40 | N/A | Victim IP validation | Victim confirmed as `192.168.40.102` | Complete |
| T03 | Security Onion | N/A | Sensor health validation | Security Onion services confirmed running and healthy | Complete |
| T04 | Proxmox `vmbr1` | Security Onion monitor NIC | Mirror bridge validation | `bridge-ageing 0` configured to support mirrored traffic delivery into the sensor VM | Complete |
| T05 | Kali / VLAN 20 | Victim / VLAN 40 | Packet capture validation | `tcpdump` on `enp6s19` confirmed mirrored ICMP traffic between attacker and victim | Complete |
| T06 | Kali / VLAN 20 | Victim / VLAN 40 | TCP SYN scan | Nmap scan completed against `192.168.40.102`; ports were filtered, but scan behavior was generated successfully | Complete |
| T07 | Kali / VLAN 20 | Victim / VLAN 40 | Security Onion Hunt review | Zeek connection logs showed traffic from `192.168.20.100` to `192.168.40.102` across multiple destination ports | Complete |

## Troubleshooting Note

During validation, Security Onion initially stopped showing mirrored traffic after a reboot. Packet captures confirmed that traffic was reaching the Proxmox physical mirror interface and the `vmbr1` bridge, but not the Security Onion monitor interface inside the VM.

The issue was resolved by adding `bridge-ageing 0` to the dedicated Proxmox sniffing bridge:

```text
auto vmbr1
iface vmbr1 inet manual
    bridge-ports nic3
    bridge-stp off
    bridge-fd 0
    bridge-ageing 0
```

After rebooting the Proxmox host, Security Onion began receiving mirrored traffic again on `enp6s19`, and Hunt logs populated successfully. This configuration ensures the dedicated monitoring bridge forwards mirrored/SPAN traffic into the Security Onion VM instead of relying on normal bridge MAC learning behavior.

## Expected Outcomes

By the end of this project, the lab should demonstrate that:

- The Kali attacker VM can generate controlled reconnaissance traffic from VLAN 20.
- The Windows victim on VLAN 40 can be targeted by controlled lab scans.
- Security Onion services are healthy and ready to process sensor data.
- Proxmox `vmbr1` is configured to pass mirrored traffic into the Security Onion monitor interface.
- Security Onion can capture mirrored traffic on `enp6s19`.
- Security Onion Hunt can be used to investigate Zeek connection logs related to reconnaissance activity.
- Evidence can be collected and explained from both the attacker and defender perspectives.

## Skills Demonstrated

- Network reconnaissance fundamentals.
- Nmap usage for controlled security testing.
- VLAN-aware lab testing.
- Packet capture validation with tcpdump.
- Security Onion investigation workflow.
- Blue-team detection validation.
- Evidence-based technical documentation.
- Safe lab rules of engagement.

## Next Steps

After this project is complete, the next logical step is to expand from basic reconnaissance detection into vulnerability scanning and alert triage. That future project can use tools such as Nessus, OpenVAS, or authenticated scans to compare vulnerability scanner results against Security Onion network visibility.