

# Project 15: Detection-as-Code Rule Development

## Overview

This project introduces a detection-as-code workflow for the homelab by documenting how security detections can be written, tested, version-controlled, and improved over time. Instead of treating detections as one-off rules created directly inside a SIEM, this project focuses on managing detections like code: clearly documented, repeatable, testable, and tied to specific attacker behavior.

The goal of this project is to create a small but realistic detection engineering workflow that can be expanded in future projects for Active Directory attacks, Caldera adversary emulation, honeynet activity, vulnerability scanning, and web application testing.

## Project Goals

- Create a structured detection-as-code project folder.
- Write detection logic in a repeatable, documented format.
- Map detections to realistic attacker behavior and MITRE ATT&CK techniques.
- Validate detections against lab-generated activity.
- Document the rule purpose, logic, test method, and expected alert behavior.
- Build a foundation for future rule tuning, alert enrichment, and automated response workflows.

## Lab Environment

| Component | Purpose |
|---|---|
| Kali Linux | Generates test activity and simulated attacker behavior |
| Ubuntu Victim | Produces authentication, system, and network telemetry |
| Security Onion | Collects, indexes, and analyzes security events |
| pfSense | Provides segmentation and firewall control between lab VLANs |
| Proxmox | Hosts core lab infrastructure and virtual machines |
| GitHub | Stores detection content, documentation, and version history |

## Skills Demonstrated

- Detection engineering fundamentals
- Security monitoring logic development
- MITRE ATT&CK mapping
- SIEM rule planning and validation
- Alert tuning and false-positive awareness
- GitHub-based documentation and version control
- Technical writing for repeatable security workflows

## Detection-as-Code Concept

Detection-as-code means security detections are treated similarly to software or infrastructure code. Each detection should have a clear purpose, defined logic, test conditions, known limitations, and documented validation results.

This approach helps make detections easier to review, update, reuse, and explain. It also creates a stronger portfolio artifact because the detection is not just an alert in a SIEM; it is a documented engineering process.

## Planned Detection Workflow

1. Identify suspicious or malicious behavior to detect.
2. Map the behavior to a MITRE ATT&CK technique.
3. Determine which logs or telemetry sources contain the needed evidence.
4. Write the detection logic.
5. Generate test activity in the lab.
6. Validate that the rule identifies the expected behavior.
7. Document screenshots, findings, and any limitations.
8. Tune the logic to reduce noise or false positives.

## Initial Detection Candidates

The first set of detection ideas will focus on behavior that already exists in the homelab portfolio and can be safely reproduced.

| Detection | Example Behavior | Possible Data Source | MITRE ATT&CK Mapping |
|---|---|---|---|
| SSH Brute Force Activity | Multiple failed SSH login attempts from Kali to Ubuntu Victim | Auth logs / Security Onion events | T1110 - Brute Force |
| Network Reconnaissance | Nmap scan from Kali against lab hosts | Zeek / Suricata / Security Onion | T1046 - Network Service Discovery |
| Suspicious Web Scanning | OWASP ZAP scan against vulnerable web target | Zeek / HTTP logs / Security Onion | T1595 - Active Scanning |
| Vulnerability Scanning | Nessus scan against lab target | Zeek / Suricata / Security Onion | T1046 - Network Service Discovery |
| Caldera Agent Activity | Caldera operation executing discovery commands | Endpoint logs / network logs | T1082 - System Information Discovery |

## Example Rule Documentation Format

Each rule should be documented using a consistent structure.

```yaml
rule_name: SSH Brute Force Detection
status: draft
severity: medium
technique: T1110 - Brute Force
data_source: Linux authentication logs / Security Onion events
objective: Detect repeated failed SSH login attempts from a single source host.
logic_summary: Identify multiple failed SSH authentication attempts from the same source within a short time window.
test_method: Generate failed SSH login attempts from Kali against the Ubuntu victim system.
expected_result: Security Onion should show repeated authentication failures from the Kali host to the Ubuntu victim.
known_limitations: A small number of failed logins may be normal and should not automatically trigger a high-severity alert.
```

## Repository Structure

The project can be expanded using the following structure:

```text
15-detection-as-code/
├── README.md
├── detections/
│   ├── ssh-brute-force.yml
│   ├── network-reconnaissance.yml
│   └── suspicious-web-scanning.yml
├── evidence/
│   ├── 01-rule-file.png
│   ├── 02-test-activity.png
│   ├── 03-security-onion-query.png
│   └── 04-alert-validation.png
└── notes/
    └── tuning-notes.md
```

## Evidence to Capture

The following screenshots should be collected once the project is tested:

| Screenshot | Description |
|---|---|
| Rule File | Detection logic written in a structured YAML or markdown format |
| Test Activity | Kali or lab system generating the activity being detected |
| Security Onion Query | Search results showing the relevant events |
| Alert Validation | Evidence that the detection logic successfully identified the behavior |
| Tuning Notes | Any adjustments made to improve accuracy or reduce noise |

## Detection Validation Plan

The initial validation process will use previously completed lab activity where possible. For example, SSH brute force testing and network reconnaissance are already repeatable in the lab and provide good starting points for detection-as-code rules.

For each detection, the validation should answer the following questions:

- Did the expected telemetry appear in Security Onion?
- Did the detection logic match the intended activity?
- Could the detection create false positives?
- What fields are most useful for investigation?
- What changes would make the detection more accurate?

## Expected Outcome

At the end of this project, the portfolio should include a documented detection-as-code workflow with at least one validated detection. The completed project should show that detections can be written, tested, tuned, and stored in a repeatable format instead of being created only inside a SIEM interface.

This project also creates a foundation for larger future lab work, including Active Directory attack simulations, Caldera adversary emulation, honeynet alerting, and automated firewall response rules.

## Lessons Learned

This section will be updated after testing is complete.

Expected learning areas include:

- How to translate attacker behavior into detection logic.
- How to identify the right log source for a specific behavior.
- How to validate detections using lab-generated activity.
- How to document detection rules so they can be reviewed and improved later.
- How detection-as-code supports repeatable security monitoring workflows.

## Project Status

**Status:** Planned / In Progress  
**Next Step:** Create the first detection file and validate it against repeatable lab activity.