

# Project 4: Security Onion Visibility Baseline

## Objective

This project establishes a baseline for network visibility inside the homelab by validating that Security Onion can observe and investigate traffic generated between the attacker and victim environments.

The goal is not to create advanced detections yet. The goal is to prove that the monitoring architecture works, that traffic from the lab VLANs reaches the Security Onion sensor, and that basic network activity can be reviewed from the Security Onion interface.

## Business & Security Value

Security tools are only useful when they have reliable visibility into the systems they are expected to monitor. In enterprise environments, poor sensor placement, missing endpoint telemetry, incorrect SPAN/mirror configuration, or firewall segmentation gaps can leave defenders blind to attacker activity.

This project demonstrates the ability to:

- Validate Security Onion sensor visibility
- Confirm that attacker-to-victim traffic is observable
- Use packet capture evidence to troubleshoot monitoring gaps
- Document a repeatable visibility baseline before building detections
- Separate visibility validation from later alert tuning and detection engineering work

## Lab Environment

| Component | Purpose |
|---|---|
| pfSense | Firewall, VLAN routing, segmentation, and DHCP services |
| Netgear GS108T | Managed switch used for VLANs and port mirroring |
| Proxmox | Hypervisor hosting lab VMs |
| Kali Linux | Attacker system used to generate test traffic |
| Victim System | Target system used to validate observed traffic |
| Security Onion | Network security monitoring platform and investigation interface |
| Raspberry Pi 5 | Admin jump host used for secure remote access and SSH tunneling |

## Relevant VLANs

| VLAN | Name | Purpose |
|---|---|---|
| 20 | Attacker | Kali / offensive testing network |
| 30 | SIEM | Security Onion management network |
| 40 | Victim | Victim system network |
| 50 | Admin | Management and jump-host access |

## Scope

This project focuses on validating Security Onion visibility across the lab environment.

In scope:

- Confirming Security Onion management access
- Confirming Security Onion sensor health
- Validating that attacker-to-victim traffic is observable
- Capturing packet-level evidence with `tcpdump`
- Reviewing Security Onion dashboards or hunt views for network activity
- Documenting known limitations and troubleshooting results

Out of scope:

- Advanced detection engineering
- Custom Sigma/YARA/Suricata rule writing
- Full incident response workflow
- Endpoint telemetry tuning
- Active Directory attack simulations
- Malware execution

## Rules of Engagement

All testing is performed inside an isolated homelab environment owned and controlled by the project author.

Traffic generation is limited to internal lab systems, including the attacker VLAN, victim VLAN, and Security Onion monitoring environment. No testing is performed against public systems or third-party networks.

## Architecture Summary

Security Onion receives management access through the SIEM VLAN and monitoring traffic through the configured sensor/sniffing interface. The managed switch is used to mirror traffic from selected lab ports toward the Security Onion monitoring interface.

For baseline validation, ports `g1`, `g2`, and `g4` were mirrored to destination port `g3`. This provided broad visibility across the pfSense trunk/uplink, Proxmox-hosted lab systems, and the victim-side connection. Multiple mirror sources may create duplicate packet observations, but this was acceptable for the initial visibility baseline because the goal was to prove that Security Onion could observe controlled attacker-to-victim traffic.

The expected visibility path is:

```text
Kali / Attacker VLAN 20
        |
        |  test traffic
        v
Victim VLAN 40
        |
        |  mirrored traffic from switch
        v
Security Onion sensor interface
        |
        v
Security Onion dashboards / hunt interface
```

## Validation Plan

### 1. Confirm Security Onion Access

Verify that the Security Onion web interface is reachable through the approved management path.

Evidence to capture:

- Security Onion login page or dashboard after successful login
- Browser URL or tunnel context scrubbed as needed
- Screenshot showing the Security Onion interface is reachable from the admin workflow

### 2. Confirm Sensor Health

Verify that Security Onion services and sensor components are running as expected.

Suggested commands:

```bash
sudo so-status
```

Optional supporting checks:

```bash
ip addr
ip route
```

Evidence to capture:

- Security Onion service/status output
- Interface list showing management and monitoring interfaces
- Any relevant sensor or node health page from the Security Onion UI

### 3. Confirm Network Interface Placement

Document the difference between the Security Onion management interface and the monitoring/sniffing interface.

Evidence to capture:

- Proxmox VM hardware view for the Security Onion VM
- Security Onion network/interface configuration evidence
- Switch VLAN or mirror configuration showing the monitored traffic path

### 4. Generate Test Traffic

Generate simple, controlled traffic from Kali to the victim system.

Suggested examples:

```bash
ping <victim-ip>
```

```bash
nmap -sV <victim-ip>
```

Use safe internal testing only. The goal is to create enough activity for Security Onion visibility validation.

Evidence to capture:

- Kali terminal showing ping or scan command
- Victim IP visible only if it is part of the lab addressing scheme
- Timestamp or terminal context showing when traffic was generated

### 5. Validate Packet Visibility with tcpdump

Use packet capture from the Security Onion side to confirm that mirrored traffic is arriving before relying only on dashboards.

Example:

```bash
sudo tcpdump -ni <sensor-interface> host <victim-ip>
```

Evidence to capture:

- `tcpdump` output showing Kali-to-victim or victim-to-Kali traffic
- Interface name used for the capture
- Matching source and destination lab IP addresses

### 6. Validate Security Onion Investigation Visibility

Use Security Onion to confirm that traffic appears in the investigation interface, dashboards, alerts, or hunt results.

Evidence to capture:

- Security Onion dashboard showing observed traffic
- Hunt/query view filtered around the victim IP, attacker IP, protocol, or time window
- Any Suricata/Zeek/network metadata events related to the test traffic

### 7. Document Findings

Summarize whether Security Onion visibility is working as expected.

Include:

- What traffic was generated
- Whether `tcpdump` saw the traffic
- Whether Security Onion UI reflected the activity
- Any issues discovered
- Any corrective action taken

## Evidence Checklist

| ID | Evidence Item | Status |
|---|---|---|
| E01 | Security Onion dashboard showing populated network telemetry | Captured |
| E02 | Security Onion service/status output showing healthy containers | Captured |
| E03 | Security Onion VM network interface layout in Proxmox | Captured |
| E04 | Switch mirror/SPAN configuration showing `g1`, `g2`, and `g4` mirrored to `g3` | Captured |
| E05 | Kali attacker test traffic to victim system | Captured |
| E06 | `tcpdump` showing mirrored VLAN traffic on Security Onion | Captured |
| E07 | Security Onion Hunt results showing Suricata ICMP events | Captured |

## Screenshots

The following screenshots were added to the `evidence/` folder:

```text
E01-security-onion-dashboard.png
E02-so-status-output.png
E03-security-onion-proxmox-interfaces.png
E04-switch-mirror-configuration.png
E05-kali-test-traffic.png
E06-security-onion-tcpdump-traffic.png
E07-security-onion-hunt-results.png
```

## Findings

The visibility baseline was successful. Security Onion was reachable through the approved management workflow, core Security Onion containers were running, and the VM had separate interfaces for management and monitoring.

The switch mirror configuration sent traffic from `g1`, `g2`, and `g4` to destination port `g3`, where the Security Onion sniffing interface could observe mirrored traffic. Kali generated controlled ICMP traffic from the attacker VLAN to the victim system on the victim VLAN. Security Onion confirmed this traffic at two levels:

1. `tcpdump` showed mirrored VLAN 20 and VLAN 40 traffic arriving on the Security Onion sensor interface.
2. Security Onion Hunt displayed Suricata ICMP events from the attacker IP to the victim IP.

This confirms that the lab has a working network visibility baseline and is ready for future detection-focused projects.

## Troubleshooting Notes

If Security Onion does not show traffic in the UI, validate visibility in this order:

1. Confirm the attacker and victim can communicate.
2. Confirm the correct switch ports are mirrored.
3. Confirm the Security Onion sniffing interface is connected to the mirror destination.
4. Confirm the Security Onion sniffing interface is not being used as the management interface.
5. Confirm `tcpdump` sees the traffic on the sensor interface.
6. Confirm Security Onion services are healthy.
7. Confirm the Security Onion UI query uses the correct time range, IP address, protocol, or event type.

## Current Status

Project 4 baseline validation is complete.

Security Onion successfully observed controlled attacker-to-victim traffic through both packet-level validation and the Security Onion Hunt interface.

## Skills Demonstrated

- Network security monitoring validation
- VLAN-aware lab architecture
- Sensor placement troubleshooting
- Packet capture analysis
- Security Onion investigation workflow
- Documentation of defensive visibility controls
- Evidence-based troubleshooting

## Next Steps

The next phase is to move from visibility validation into detection-focused work, including custom alert validation, attack simulation mapping, and MITRE ATT&CK-aligned detection engineering.