# Project 16 - Security Onion Rule Tuning and Alert Validation

## Objective

This project demonstrates the process of reviewing a repeated Security Onion alert, identifying expected low-severity activity, and applying a controlled tuning change to reduce alert noise. The goal was to tune a specific known source without disabling the detection globally.

This project builds on earlier Security Onion monitoring, reconnaissance detection, SSH brute-force detection, and adversary emulation work by focusing on alert quality and analyst decision-making.

## Lab Environment

| Component | Purpose |
|---|---|
| Security Onion | SIEM and network security monitoring platform used for alert review, tuning, and validation |
| Raspberry Pi | Admin VLAN host generating expected STUN/NAT traversal traffic |
| pfSense | Firewall and routing layer for segmented lab traffic |
| Netgear Managed Switch | Provides VLAN separation and mirrored traffic visibility |
| Proxmox | Virtualization platform hosting core lab systems |
| Admin VLAN | Management network containing the Raspberry Pi and administrative services |

## Project Summary

Security Onion generated repeated low-severity Suricata alerts for STUN/NAT traversal traffic from the Raspberry Pi on the Admin VLAN. The alert was reviewed to confirm the source, destination, destination port, rule name, and rule UUID before making a tuning decision.

The selected alert was not disabled globally. Instead, a source-based suppression was applied only to the Admin VLAN Pi using `192.168.50.100/32`. This reduced repeated alert noise while preserving visibility into the underlying traffic in Security Onion Hunt.

## Alert Reviewed

| Field | Value |
|---|---|
| Alert Name | ET INFO Session Traversal Utilities for NAT (STUN Binding Request) |
| Rule UUID | 2016149 |
| Event Module | Suricata |
| Severity | Low |
| Source IP | 192.168.50.100 |
| Source Host | Raspberry Pi on Admin VLAN |
| Destination Port | 3478 |
| Tuning Type | Suppress |
| Tuning Scope | Source-based suppression for `192.168.50.100/32` |

## Implementation Steps

1. Reviewed Security Onion Alerts and identified a repeated low-severity STUN alert.
2. Opened the alert details to confirm the rule name, rule UUID, source IP, destination IP, and destination port.
3. Verified that the source IP belonged to the Raspberry Pi on the Admin VLAN.
4. Located the related Suricata detection in Security Onion Detections using rule UUID `2016149`.
5. Added a source-based suppression for `192.168.50.100/32` instead of disabling the rule globally.
6. Returned to the Alerts page to validate that the STUN alert no longer appeared in the recent 15-minute alert view.
7. Used Security Onion Hunt to confirm that STUN and connection records were still visible after the tuning change.

## Evidence

| Screenshot | Description |
|---|---|
| [01-security-onion-alert-baseline.png](evidence/01-security-onion-alert-baseline.png) | Baseline Alerts view showing repeated STUN Binding Request alerts before tuning |
| [02-alert-details-before-tuning.png](evidence/02-alert-details-before-tuning.png) | Alert details showing the selected Suricata detection and rule context |
| [03-traffic-source-review.png](evidence/03-traffic-source-review.png) | Source and destination review showing the Admin VLAN Pi, external destination, and STUN port 3478 |
| [04-rule-tuning-change.png](evidence/04-rule-tuning-change.png) | Source-based suppression applied for `192.168.50.100/32` |
| [05-alert-validation-after-tuning.png](evidence/05-alert-validation-after-tuning.png) | Alerts view after tuning showing the STUN alert no longer appearing in the recent 15-minute window |
| [06-final-alert-review.png](evidence/06-final-alert-review.png) | Hunt validation showing STUN and connection records remained searchable after alert tuning |

## Skills Demonstrated

| Skill | Description |
|---|---|
| SIEM Alert Review | Reviewed Security Onion alerts and selected a repeated low-severity detection for analysis |
| Detection Tuning | Applied a narrow source-based suppression instead of disabling the rule globally |
| Traffic Analysis | Reviewed source, destination, destination port, and event context before tuning |
| Validation Testing | Confirmed the alert behavior changed after the suppression was applied |
| Network Security Monitoring | Used Hunt to verify that traffic visibility remained available after alert tuning |
| Analyst Documentation | Documented the tuning decision, scope, and validation evidence |

## Portfolio Summary

This project demonstrates a practical alert tuning workflow inside a monitored homelab environment. A repeated low-severity STUN alert from the Admin VLAN Raspberry Pi was reviewed, scoped, and suppressed using a narrow source-based tuning entry.

The project shows that alert tuning should be intentional and validated. Rather than disabling the detection globally, the tuning was limited to a known internal host, and Security Onion Hunt was used to confirm that the underlying STUN and connection activity remained visible after the alert was suppressed.