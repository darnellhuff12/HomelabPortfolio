# Project 6: Service Enumeration and Exposure Review

## Objective

This project documents a controlled service enumeration and exposure review inside the homelab environment. The goal is to identify reachable hosts, enumerate exposed services, validate expected network segmentation behavior, and document whether the observed exposure matches the intended design of the lab.

This project builds on the earlier segmentation, monitoring, Proxmox, and Security Onion projects by shifting from infrastructure setup into active validation. Instead of assuming that firewall rules, VLANs, and services are configured correctly, this project uses attacker-style discovery from the Kali VM to confirm what is actually visible on the network.

## Business and Security Value

Service enumeration is a common early step in both legitimate security assessments and real-world attacks. From a defender's perspective, reviewing exposed services helps answer several important questions:

- Which systems are reachable from a given network segment?
- Which ports and services are exposed?
- Are management interfaces restricted to the correct VLAN?
- Are unnecessary services running?
- Do firewall rules prevent access where expected?
- Does Security Onion capture and log the scanning activity?

This type of review supports vulnerability management, attack surface reduction, firewall validation, and blue-team monitoring. It also demonstrates the ability to think like both an attacker and defender while staying within a controlled lab scope.

## Lab Environment

| Component | Role | Notes |
| --- | --- | --- |
| Kali Linux VM | Enumeration host | Used to run discovery and service enumeration commands |
| Victim VLAN | Target network | Contains intentionally monitored lab systems |
| Admin VLAN | Management network | Used for restricted access to administrative interfaces |
| Security Onion | Monitoring platform | Used to observe scan traffic and validate network visibility |
| pfSense | Firewall/router | Enforces VLAN segmentation and access control rules |
| Netgear GS108T | Managed switch | Provides VLAN tagging and traffic mirroring |
| Proxmox | Virtualization host | Hosts core lab VMs including Kali and Security Onion |

## Scope and Rules of Engagement

This project was performed only inside the local homelab environment.

### In Scope

- Lab-owned VLANs and systems
- Kali VM enumeration activity
- Internal IP ranges assigned to the homelab
- Service discovery against approved lab targets
- Security Onion monitoring and evidence review
- Firewall rule validation between lab segments

### Out of Scope

- Public IP scanning
- Third-party systems
- ISP-owned infrastructure
- Employer systems
- Internet-wide enumeration
- Unauthorized exploitation

## Validation and Evidence

Service enumeration was validated through attacker placement checks, host discovery, service enumeration, restricted management testing, Security Onion log review, and retained Nmap output.

| Validation Area | Result | Evidence |
| --- | --- | --- |
| Kali network placement | Passed - Kali was confirmed on the attacker VLAN with IP `192.168.20.100`, default route through `192.168.20.1`, and reachability to the approved victim host | [01-kali-network-placement.png](evidence/01-kali-network-placement.png) |
| Victim VLAN host discovery | Passed - Nmap host discovery identified three live hosts on `192.168.40.0/24` | [02-host-discovery-scan.png](evidence/02-host-discovery-scan.png) |
| Victim service enumeration | Passed - The victim host `192.168.40.102` was reachable, but common TCP services were filtered | [03-service-enumeration-filtered-results.png](evidence/03-service-enumeration-filtered-results.png) |
| Security Onion visibility | Passed - Security Onion Hunt showed Zeek connection logs for Kali attacker activity | [04-security-onion-scan-visibility.png](evidence/04-security-onion-scan-visibility.png) |
| Restricted management access | Passed - pfSense, Proxmox, iDRAC, and Security Onion management interfaces were filtered or unreachable from the attacker VLAN | [05-restricted-management-test.png](evidence/05-restricted-management-test.png) |
| Scan output evidence | Passed - A screenshot documented saved Nmap output files in `.nmap`, `.gnmap`, and `.xml` formats | [06-nmap-output-files.png](evidence/06-nmap-output-files.png) |
| ATTACK VLAN firewall rule review | Passed - pfSense rules supported controlled victim access while restricting unauthorized private/internal network access | [07-rules-vlan20-attacker-final.png](evidence/07-rules-vlan20-attacker-final.png) |

## Outcome Summary

The goal of this project was not to find as many open ports as possible. The goal was to validate whether the network behaved as designed from the perspective of the attacker VLAN. The completed review demonstrated that:

- Kali can reach approved victim systems.
- Kali cannot reach restricted management interfaces unless explicitly allowed.
- Administrative services are not broadly exposed to attacker or victim networks.
- Security Onion can observe scan traffic from mirrored ports or monitored interfaces.
- Firewall rules block traffic that should not cross VLAN boundaries.
- Any discovered services are documented and reviewed.

## Key Findings

| Target | IP Address | Open Ports / Result | Service Notes | Expected? | Action Needed |
| --- | --- | --- | --- | --- | --- |
| Kali Attacker VM | 192.168.20.100 | N/A | Confirmed attacker VLAN placement with default route through 192.168.20.1 | Yes | None |
| Victim VLAN Discovery | 192.168.40.0/24 | 3 hosts discovered | Host discovery identified 192.168.40.1, 192.168.40.100, and 192.168.40.102 as live hosts | Yes | None |
| Victim Host | 192.168.40.102 | 1000 filtered TCP ports | Host reachable from Kali, but no common TCP services exposed during service enumeration | Yes | None |
| pfSense/Admin Gateway | 192.168.50.1 | 443/tcp filtered; ICMP blocked | Admin interface was not directly reachable from the attacker VLAN | Yes | None |
| Proxmox Management | 192.168.50.10 | 8006/tcp filtered; ICMP blocked | Proxmox web management interface was restricted from the attacker VLAN | Yes | None |
| iDRAC/Management Host | 192.168.50.20 | 443/tcp filtered; ICMP blocked | Management interface was restricted from the attacker VLAN | Yes | None |
| Security Onion Management | 192.168.30.10 | 443/tcp filtered; ICMP blocked | Security Onion management interface was not directly reachable from the attacker VLAN | Yes | None |
| Security Onion Monitoring | N/A | Zeek connection logs observed | Hunt results confirmed activity from Kali was visible in Security Onion | Yes | None |

## Evidence Summary

The following evidence documents attacker placement, service enumeration results, firewall behavior, Security Onion visibility, and saved Nmap output evidence.

| ID | Evidence | What It Demonstrates |
| --- | --- | --- |
| 01 | [`01-kali-network-placement.png`](evidence/01-kali-network-placement.png) | Shows Kali on the attacker VLAN with IP address 192.168.20.100, default route through 192.168.20.1, and successful ping to the victim host |
| 02 | [`02-host-discovery-scan.png`](evidence/02-host-discovery-scan.png) | Shows Nmap host discovery against 192.168.40.0/24 identifying three live hosts on the victim VLAN |
| 03 | [`03-service-enumeration-filtered-results.png`](evidence/03-service-enumeration-filtered-results.png) | Shows Nmap service enumeration against 192.168.40.102 with the host up and 1000 TCP ports filtered |
| 04 | [`04-security-onion-scan-visibility.png`](evidence/04-security-onion-scan-visibility.png) | Shows Security Onion Hunt results confirming Zeek connection logs for activity from the Kali attacker VM |
| 05 | [`05-restricted-management-test.png`](evidence/05-restricted-management-test.png) | Shows management systems returning ICMP failures and filtered management ports from the attacker VLAN |
| 06 | [`06-nmap-output-files.png`](evidence/06-nmap-output-files.png) | Shows a terminal listing of saved Nmap output files in `.nmap`, `.gnmap`, and `.xml` formats |
| 07 | [`07-rules-vlan20-attacker-final.png`](evidence/07-rules-vlan20-attacker-final.png) | Shows ATTACK VLAN firewall rules allowing victim lab testing while blocking unauthorized private/internal network access |

## Key Evidence

The screenshots below highlight the most important service enumeration and exposure review evidence while the table above preserves links to the full evidence set.

**Kali Network Placement**

![Kali network placement showing attacker VLAN IP, route, and victim reachability](evidence/01-kali-network-placement.png)

**Host Discovery Scan**

![Nmap host discovery scan against the victim VLAN](evidence/02-host-discovery-scan.png)

**Service Enumeration Filtered Results**

![Nmap service enumeration showing the victim host up with filtered TCP ports](evidence/03-service-enumeration-filtered-results.png)

**Security Onion Scan Visibility**

![Security Onion Hunt results showing Zeek logs for Kali attacker activity](evidence/04-security-onion-scan-visibility.png)

**Restricted Management Test**

![Nmap and ping tests showing management interfaces filtered or unreachable from the attacker VLAN](evidence/05-restricted-management-test.png)

**Saved Nmap Output Files**

![Saved Nmap output files in the evidence directory](evidence/06-nmap-output-files.png)

**ATTACK VLAN Firewall Rules**

![pfSense ATTACK VLAN firewall rules supporting controlled victim access and restricted management access](evidence/07-rules-vlan20-attacker-final.png)

## Security Onion Validation

Security Onion Hunt confirmed visibility into traffic from the Kali attacker VM (`192.168.20.100`). Zeek connection logs showed activity from the attacker VLAN, including attempted connections to management and lab infrastructure systems. This validated that the monitoring stack was receiving and indexing relevant scan and connection metadata.

## Defensive Review

After enumeration, each exposed service should be reviewed using the following questions:

- Is this service required?
- Is the service exposed only to the correct VLAN?
- Is authentication required?
- Is the service patched?
- Should access be limited to the Admin VLAN?
- Should the service be disabled, firewalled, or monitored more closely?
- Would this exposure make sense in a real enterprise environment?

The review confirmed that the victim host was reachable from the attacker VLAN for lab testing, but common TCP services were filtered. Management interfaces for pfSense, Proxmox, iDRAC, and Security Onion were not directly accessible from the attacker VLAN. This matches the intended design: attacker systems can interact with approved victim lab targets, while administrative services remain restricted.

## Remediation and Hardening Notes

Potential future remediation or hardening actions include:

- Disabling unnecessary services
- Restricting management ports to the Admin VLAN
- Adding or tightening pfSense firewall rules
- Moving systems to the correct VLAN
- Updating vulnerable or outdated services
- Adding detection logic for repeated scan behavior
- Documenting accepted risk for intentionally exposed lab services

No immediate remediation was required based on the observed results. The filtered management ports and blocked ICMP responses indicate that segmentation controls are working as intended. Future hardening could include periodic re-testing after firewall changes, adding alert logic for repeated scan behavior, and reviewing any newly introduced services before allowing access from the attacker VLAN.

## Lessons Learned

This project reinforces that network diagrams and firewall rules should be validated with real testing. Enumeration provides a practical way to confirm what an attacker could see from a specific network position, while Security Onion provides visibility into whether that behavior is being monitored.

Key takeaways:

- Segmentation must be tested, not assumed.
- Management interfaces should not be reachable from attacker or victim networks.
- Nmap output provides useful technical evidence for exposure review.
- Security Onion can help validate monitoring coverage during active testing.
- A good homelab portfolio should show both offensive validation and defensive analysis.

## Project Status

| Area | Status |
| --- | --- |
| Kali network placement validated | Complete |
| Approved target subnet identified | Complete |
| Host discovery completed | Complete |
| Service enumeration completed | Complete |
| Nmap output file evidence documented | Complete |
| Restricted management access tested | Complete |
| Security Onion logs reviewed | Complete |
| Evidence screenshots captured and linked | Complete |
| Findings documented | Complete |
| Remediation notes added | Complete |

## Portfolio Summary

Project 6 demonstrates practical exposure review using controlled service enumeration inside a segmented cybersecurity homelab. Kali was used from the attacker VLAN to discover approved victim VLAN hosts, enumerate exposed services, and test access to restricted management systems. The results showed that the victim host was reachable for lab testing while common TCP services and management interfaces remained filtered or blocked. Security Onion Hunt confirmed visibility into attacker VLAN activity through Zeek connection logs, connecting offensive reconnaissance techniques with defensive monitoring and hardening validation.