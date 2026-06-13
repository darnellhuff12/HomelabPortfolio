# Project 15: Detection-as-Code Rule Development

## Overview

This project demonstrates a detection-as-code workflow inside the homelab. Instead of creating security detections as one-off searches inside a SIEM, this project documents detections as structured rule files that can be reviewed, tested, tuned, and version-controlled.

The project focuses on two controlled attacker behaviors generated in the lab: SSH brute force activity and network reconnaissance. Each behavior is mapped to MITRE ATT&CK, translated into detection logic, validated against lab telemetry, and documented with false-positive and tuning considerations.

## Project Goals

- Create a structured detection-as-code workflow.
- Write reusable detection files for common attacker behaviors.
- Validate detections using controlled lab-generated activity.
- Map detections to MITRE ATT&CK techniques.
- Document expected telemetry, false positives, and tuning recommendations.
- Show how Security Onion and endpoint logs can support detection engineering.
- Build a foundation for future detections involving Caldera, Active Directory, honeypots, and automated response logic.

## Lab Environment


| Component      | Role                                                               |
| -------------- | ------------------------------------------------------------------ |
| Kali Linux     | Generates SSH brute force and reconnaissance activity              |
| Ubuntu Victim  | Receives SSH login attempts and produces authentication logs       |
| Security Onion | Provides network visibility, event search, and validation evidence |
| pfSense        | Segments lab VLANs and controls traffic between systems            |
| Proxmox        | Hosts core lab infrastructure and virtual machines                 |
| GitHub         | Stores detection files, notes, screenshots, and documentation      |


## Skills Demonstrated

- Detection engineering
- Detection-as-code documentation
- SIEM validation and event analysis
- Linux authentication log review
- Network traffic analysis using Security Onion
- MITRE ATT&CK mapping
- False-positive analysis and rule tuning
- GitHub-based version control and technical documentation

## Detection-as-Code Concept

Detection-as-code means security detections are managed like code. A detection should have a clear purpose, defined logic, known data sources, test steps, expected results, and tuning notes.

This makes detections easier to review, improve, reuse, and explain. It also creates stronger documentation because the rule is not only represented as a SIEM search or alert; it is tied to a repeatable engineering process.

## Project Scope

This project focuses on two detections:


| Detection                        | Behavior                                                      | Data Sources                            | MITRE ATT&CK Mapping              |
| -------------------------------- | ------------------------------------------------------------- | --------------------------------------- | --------------------------------- |
| SSH Brute Force Detection        | Multiple failed SSH login attempts from Kali to Ubuntu Victim | Ubuntu auth logs, Security Onion events | T1110 - Brute Force               |
| Network Reconnaissance Detection | Nmap scan activity from Kali against a lab target             | Zeek/Suricata/Security Onion events     | T1046 - Network Service Discovery |


Additional detection ideas such as OWASP ZAP scanning, Nessus scan activity, Caldera agent behavior, and honeynet alerts can be added in future projects.

## Detection Workflow

1. Identify a behavior to detect.
2. Map the behavior to MITRE ATT&CK.
3. Identify the data sources needed for validation.
4. Write the detection logic in a structured YAML file.
5. Generate controlled activity from Kali Linux.
6. Validate endpoint and network telemetry.
7. Review Security Onion events for source, destination, protocol, timestamp, and event details.
8. Document false-positive considerations and tuning recommendations.
9. Store the detection files, notes, and evidence in GitHub.

## Detection 1: SSH Brute Force

### Objective

Detect repeated failed SSH authentication attempts from a single source host against a Linux victim system.

### ATT&CK Mapping


| Field        | Value             |
| ------------ | ----------------- |
| Tactic       | Credential Access |
| Technique    | Brute Force       |
| Technique ID | T1110             |


### Detection Logic Summary

The detection looks for multiple failed SSH authentication attempts from the same source IP within a short time window. A threshold is used to avoid alerting on normal user mistakes, such as one or two incorrect password attempts.

### Validation Method

1. Confirm SSH is running on the Ubuntu victim.
2. Generate repeated failed SSH login attempts from Kali Linux.
3. Review Ubuntu authentication logs for failed login messages.
4. Search Security Onion for SSH traffic between Kali and the Ubuntu victim.
5. Confirm that the activity matches the detection logic.

### Expected Result

The Ubuntu victim should show failed SSH authentication attempts in its logs, and Security Onion should show SSH traffic between the Kali attacker and Ubuntu victim.

### False Positive Considerations

- A legitimate user mistyping a password multiple times.
- Administrator troubleshooting SSH access.
- Misconfigured scripts or automation.
- Monitoring tools using outdated credentials.

### Tuning Recommendations

- Increase severity if multiple usernames are attempted.
- Increase severity if failed logins are followed by a successful login.
- Exclude approved administrator jump boxes if needed.
- Adjust thresholds based on normal authentication behavior.

## Detection 2: Network Reconnaissance

### Objective

Detect network scanning activity from a single source host against a lab target.

### ATT&CK Mapping


| Field        | Value                     |
| ------------ | ------------------------- |
| Tactic       | Discovery                 |
| Technique    | Network Service Discovery |
| Technique ID | T1046                     |


### Detection Logic Summary

The detection looks for one source host attempting connections to multiple ports or services on a destination system within a short time window. This behavior is commonly associated with scanning or service discovery.

### Validation Method

1. Run an Nmap scan from Kali Linux against a lab target.
2. Search Security Onion for network events between the Kali host and target system.
3. Review event details for source IP, destination IP, protocol, ports, and timestamps.
4. Confirm that the observed behavior matches the detection logic.

### Expected Result

Security Onion should show multiple connection attempts from Kali to the scanned target. Depending on the scan type and available telemetry, the activity may appear in Zeek connection logs, Suricata alerts, or general Security Onion event data.

### False Positive Considerations

- Approved vulnerability scanners.
- Asset inventory tools.
- Administrator troubleshooting.
- Internal monitoring or discovery tools.

### Tuning Recommendations

- Exclude known approved scanner IP addresses.
- Increase severity for scanning from non-administrative VLANs.
- Increase severity if scanning is followed by authentication attempts.
- Tune thresholds based on normal network behavior.

## Evidence


| Evidence                                                                                        | Description                                                                                                                              |
| ----------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| [01-ssh-brute-force-rule-file.png](evidence/01-ssh-brute-force-rule-file.png)                   | Shows the SSH brute force detection rule file, including MITRE mapping, detection logic, threshold, false positives, and tuning notes    |
| [02-ssh-brute-force-validation-notes.png](evidence/02-ssh-brute-force-validation-notes.png)     | Shows the SSH brute force validation notes documenting the test summary, expected evidence, validation result, and tuning considerations |
| [03-ubuntu-victim-ssh-service.png](evidence/03-ubuntu-victim-ssh-service.png)                   | Confirms the Ubuntu victim IP address and verifies that the SSH service was active and listening                                         |
| [04-kali-failed-ssh-attempts.png](evidence/04-kali-failed-ssh-attempts.png)                     | Shows failed SSH login attempts generated from Kali against the Ubuntu victim                                                            |
| [05-ubuntu-auth-log-failures.png](evidence/05-ubuntu-auth-log-failures.png)                     | Shows Ubuntu authentication logs recording failed login attempts from the Kali source IP                                                 |
| [06-security-onion-ssh-events.png](evidence/06-security-onion-ssh-events.png)                   | Shows Security Onion Hunt results for SSH activity between Kali and the Ubuntu victim                                                    |
| [07-security-onion-ssh-event-details.png](evidence/07-security-onion-ssh-event-details.png)     | Shows detailed Zeek SSH event fields, including source IP, destination IP, destination port, and SSH metadata                            |
| [08-network-reconnaissance-rule-file.png](evidence/08-network-reconnaissance-rule-file.png)     | Shows the network reconnaissance detection rule file with MITRE T1046 mapping and detection logic                                        |
| [09-kali-nmap-scan.png](evidence/09-kali-nmap-scan.png)                                         | Shows an Nmap service scan from Kali against the Ubuntu victim                                                                           |
| [10-security-onion-recon-events.png](evidence/10-security-onion-recon-events.png)               | Shows Security Onion Hunt results containing high-volume Zeek connection activity from Kali to the victim after the scan                 |
| [11-security-onion-recon-event-details.png](evidence/11-security-onion-recon-event-details.png) | Shows detailed Security Onion event fields for reconnaissance-related network telemetry                                                  |


## Embedded Evidence

### SSH Brute Force Detection Rule

SSH brute force detection rule

### SSH Brute Force Validation Notes

SSH brute force validation notes

### Ubuntu Victim SSH Service

Ubuntu victim SSH service

### Kali Failed SSH Attempts

Kali failed SSH attempts

### Ubuntu Authentication Log Failures

Ubuntu authentication log failures

### Security Onion SSH Events

Security Onion SSH events

### Security Onion SSH Event Details

Security Onion SSH event details

### Network Reconnaissance Detection Rule

Network reconnaissance detection rule

### Kali Nmap Scan

Kali Nmap scan

### Security Onion Reconnaissance Events

Security Onion reconnaissance events

### Security Onion Reconnaissance Event Details

Security Onion reconnaissance event details

## Key Findings

- Controlled SSH brute force activity was successfully generated from Kali against the Ubuntu victim.
- Ubuntu authentication logs confirmed failed login attempts from the Kali source IP.
- Security Onion showed SSH-related Zeek telemetry between Kali and the Ubuntu victim.
- Nmap reconnaissance generated high-volume connection telemetry visible in Security Onion.
- Endpoint logs and network telemetry provided complementary evidence for detection validation.
- Structured rule files made it easier to define detection logic, thresholds, false positives, and tuning recommendations.
- MITRE ATT&CK mapping helped connect lab activity to real attacker behavior.

## Lessons Learned

This project reinforced that detection engineering is more than writing an alert. A strong detection requires a clear objective, reliable data sources, validation evidence, false-positive awareness, and documented tuning recommendations.

The SSH brute force detection demonstrated how endpoint authentication logs and Security Onion network telemetry can be used together to validate repeated failed login activity. The network reconnaissance detection demonstrated how scanning behavior can produce a large number of observable connection events even when only a small number of services are open on the target. Together, the two detections created a reusable foundation for future detection-as-code work in the homelab.

## Future Improvements

- Convert the YAML documentation into Sigma-style detection rules.
- Add a Caldera-based detection for command execution or system discovery.
- Add detection logic for OWASP ZAP or Nessus scan activity.
- Build detections for Active Directory authentication attacks.
- Add honeypot or honeytoken alerts in a future honeynet project.
- Explore automated blocking or alert enrichment using pfSense and SIEM data.

## Portfolio Summary

This project demonstrates a detection engineering workflow using controlled attacker activity, structured detection files, and SIEM validation. SSH brute force and Nmap reconnaissance activity were generated from Kali Linux, validated through Ubuntu authentication logs and Security Onion telemetry, and documented as reusable detection-as-code rules with MITRE ATT&CK mapping, false-positive considerations, and tuning recommendations.

## Project Status

**Status:** Complete