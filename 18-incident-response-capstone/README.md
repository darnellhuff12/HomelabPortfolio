# Project 18: Vulnerability Discovery, Detection, and Remediation Capstone

## Overview

This project demonstrates a full vulnerability discovery, detection, and remediation workflow inside the segmented cybersecurity homelab. A legacy FTP service was intentionally deployed on a victim server to simulate an insecure business file transfer process. The service was discovered with Nessus, validated from Kali Linux, monitored with Security Onion, and confirmed through pfSense firewall logs.

After the risk and visibility of the insecure service were validated, FTP was removed from the victim system and replaced with SFTP over SSH. A post-remediation Nessus scan and connectivity validation confirmed that FTP was no longer exposed while encrypted file transfer remained available.

This project serves as the capstone for the portfolio by combining vulnerability discovery, business risk analysis, network monitoring, firewall validation, detection engineering, remediation, secure service replacement, and post-remediation verification.

## Lab Environment

| Component | Purpose |
|---|---|
| pfSense | Firewall, VLAN routing, segmentation, and traffic log validation |
| Proxmox | Virtualization platform hosting lab systems |
| Security Onion | Network security monitoring, Zeek and Suricata visibility, and custom detection validation |
| Kali Linux | Client system used to validate FTP and SFTP access |
| Nessus Scanner | Vulnerability scanner used to identify and validate exposed services |
| Ubuntu Victim Server | Target system configured with legacy FTP and later remediated with SFTP |
| Managed Switch | VLAN trunking and mirrored traffic delivery to Security Onion |
| Raspberry Pi Bastion | Remote administrative access through Tailscale and SSH tunneling |

## Objectives

- Intentionally configure a vulnerable legacy FTP service on a victim server.
- Use Nessus to discover and document the exposed FTP service.
- Explain the business purpose and security risk of the legacy file transfer workflow.
- Validate FTP usage from Kali Linux.
- Confirm Security Onion visibility into FTP activity using Zeek and Suricata data.
- Validate the traffic path with pfSense firewall logs.
- Create a custom Security Onion detection for FTP connections to the victim server.
- Remove the insecure FTP service from the victim server.
- Replace FTP with SFTP over SSH.
- Run a post-remediation Nessus scan to confirm the insecure service was removed.
- Validate that FTP is no longer reachable while SFTP remains functional.

## Network / System Scope

| Item | Details |
|---|---|
| Vulnerable Service | FTP on TCP/21 |
| FTP Service | `vsftpd 3.0.5` |
| Secure Replacement | SFTP over SSH |
| Attacker / Client System | Kali Linux |
| Victim System | Ubuntu victim server |
| Vulnerability Scanner | Nessus Essentials |
| Monitoring Platform | Security Onion Hunt, Zeek, and Suricata |
| Firewall Validation | pfSense firewall logs |
| Detection Logic | Custom policy-style detection for FTP connections to the victim server |
| Validation Method | Nessus scan, Kali FTP/SFTP testing, Security Onion Hunt, pfSense logs, service removal checks, and post-remediation rescan |

## Implementation Summary

The victim server was configured with `vsftpd` to simulate a legacy FTP workflow. A test user and file were created to validate that the service could be used for file transfer.

Nessus was then used to scan the victim server from the Admin VLAN. The scan identified the FTP service and confirmed the exposed service on TCP port `21`. Kali Linux was used to connect to the victim over FTP, authenticate with the lab test account, list available files, and retrieve the test file.

Security Onion was used to validate network visibility into the FTP activity. Hunt results showed Zeek FTP and connection logs containing FTP session metadata. A custom Security Onion detection was created to alert when FTP connections were observed against the victim server.

pfSense firewall logs were used to validate that the FTP testing occurred across the expected VLAN path between the attacker VLAN and the victim VLAN.

After validation, FTP was stopped, disabled, removed, and verified as no longer listening. SFTP over SSH was then used as the secure replacement. Post-remediation validation confirmed that FTP was no longer reachable while SFTP remained functional.

## Business Service Context

The victim server was configured to simulate a legacy internal file transfer server. In many organizations, FTP may remain in use because older applications, scripts, or operational workflows depend on simple file transfer methods.

Although FTP can support business operations, it introduces security risk because authentication and file transfer activity are not encrypted. This means usernames, commands, file names, and transferred data may be visible to network monitoring tools or attackers with access to the same network path.

The approved remediation for this project was to retire FTP and replace it with SFTP over SSH. SFTP supports the same general business need of transferring files while providing encrypted authentication and encrypted data transfer.

## Vulnerability and Risk Summary

Nessus identified that the victim server exposed FTP on TCP port `21`. The scan detected the FTP service and confirmed the FTP banner associated with `vsftpd 3.0.5`. While the Nessus finding was informational, the presence of FTP still represented an insecure protocol exposure because FTP does not encrypt authentication or file transfer activity.

The risk was validated by using Kali Linux to authenticate to the FTP service, list the remote directory, and retrieve a test file. Security Onion confirmed the concern by recording FTP metadata such as the source IP, destination IP, destination port, FTP username, FTP command, and file transfer argument.

In a production environment, this type of visibility could represent unnecessary exposure of operational details or sensitive file transfer activity. The appropriate remediation was to remove FTP and replace it with an encrypted file transfer method.

## Detection and Monitoring

Security Onion provided visibility into the FTP traffic generated during the test. Zeek records showed FTP activity from Kali to the victim server, including the FTP user, FTP command, destination port, and file transfer metadata.

A custom Suricata detection was created in Security Onion to alert when FTP connections were made to the victim server. The rule was designed as a policy-style detection to identify any future FTP usage against the host after FTP was no longer approved.

Detection objective:

```text
FTP is no longer an approved file transfer method for the victim server. Any future FTP connection to this host should generate a policy alert and be investigated.
```

Custom detection logic:

```text
Alert on TCP connections to the victim server over destination port 21.
```

This detection supports the post-remediation monitoring goal by helping identify whether the insecure legacy service or protocol returns in the environment.

## Remediation Workflow

The remediation workflow followed the full vulnerability management lifecycle:

```text
Legacy FTP service deployed
        |
        | Nessus discovery and Kali validation
        v
Security Onion and pfSense visibility confirmed
        |
        | custom FTP detection created
        v
FTP service stopped, disabled, and removed
        |
        | SFTP over SSH validated as secure replacement
        v
Post-remediation Nessus scan and connectivity validation
```

This workflow demonstrates the complete process from vulnerable service discovery through remediation and post-remediation verification.

## Evidence

| # | Evidence | Description |
|---|---|---|
| 01 | [Vulnerable FTP Service](evidence/01-vulnerable-ftp-service.png) | Shows `vsftpd` running on the victim server, TCP port `21` listening, and the legacy transfer test file created. |
| 02 | [Initial Nessus FTP Finding](evidence/02-nessus-initial-ftp-finding.png) | Shows the initial Nessus scan results identifying FTP-related findings on the victim server. |
| 03 | [Vulnerability Risk Details](evidence/03-vulnerability-risk-details.png) | Shows Nessus plugin details confirming the FTP service banner and service exposure on TCP port `21`. |
| 04 | [FTP Usage from Kali](evidence/04-ftp-usage-from-kali.png) | Shows Kali successfully authenticating to FTP, listing files, and downloading the legacy transfer test file. |
| 05 | [Security Onion FTP Traffic](evidence/05-security-onion-ftp-traffic.png) | Shows Security Onion Hunt results with Zeek FTP metadata, including source, destination, username, command, and file transfer details. |
| 06 | [pfSense FTP Log Validation](evidence/06-pfsense-ftp-log-validation.png) | Shows pfSense firewall logs validating FTP traffic across the expected attacker-to-victim VLAN path. |
| 07 | [Security Onion FTP Detection Rule](evidence/07-security-onion-ftp-detection-rule.png) | Shows the custom Security Onion detection rule created to identify FTP connections to the victim server. |
| 08 | [Security Onion FTP Alert Validation](evidence/08-security-onion-ftp-alert-validation.png) | Shows Security Onion alert validation confirming the custom FTP detection triggered successfully. |
| 09 | [Remediation Disable FTP](evidence/09-remediation-disable-ftp.png) | Shows FTP being stopped, disabled, removed, and verified as no longer listening on TCP port `21`. |
| 10 | [Secure SFTP Replacement](evidence/10-secure-sftp-replacement.png) | Shows SFTP successfully replacing FTP for encrypted file transfer. |
| 11 | [Nessus Remediation Rescan](evidence/11-nessus-remediation-rescan.png) | Shows the post-remediation Nessus scan confirming the FTP service findings were removed. |
| 12 | [Post-Remediation Connectivity Validation](evidence/12-post-remediation-connectivity-validation.png) | Shows FTP connection refusal and successful SFTP connectivity after remediation. |

## Key Evidence

### Legacy FTP Service Configured

![Legacy FTP Service Configured](evidence/01-vulnerable-ftp-service.png)

This screenshot shows `vsftpd` running on the victim server, TCP port `21` listening, and the test file used to simulate a legacy business file transfer workflow.

### Initial Nessus FTP Finding

![Initial Nessus FTP Finding](evidence/02-nessus-initial-ftp-finding.png)

This screenshot shows Nessus identifying FTP-related findings on the victim server during the initial vulnerability scan.

### Security Onion FTP Visibility

![Security Onion FTP Visibility](evidence/05-security-onion-ftp-traffic.png)

This screenshot shows Security Onion Hunt results with Zeek FTP metadata, proving that FTP activity was visible to the monitoring stack.

### Security Onion FTP Detection Validation

![Security Onion FTP Detection Validation](evidence/08-security-onion-ftp-alert-validation.png)

This screenshot shows the custom FTP detection triggering successfully in Security Onion.

### FTP Remediation and Removal

![FTP Remediation and Removal](evidence/09-remediation-disable-ftp.png)

This screenshot shows FTP being stopped, disabled, removed, and verified as no longer listening on TCP port `21`.

### Secure SFTP Replacement

![Secure SFTP Replacement](evidence/10-secure-sftp-replacement.png)

This screenshot shows SFTP successfully replacing FTP for encrypted file transfer.

### Post-Remediation Validation

![Post-Remediation Validation](evidence/12-post-remediation-connectivity-validation.png)

This screenshot shows FTP connection refusal and successful SFTP connectivity after remediation.

## Validation

The full discovery, detection, remediation, and verification workflow was validated through Nessus scanning, Kali access testing, Security Onion Hunt review, pfSense firewall logs, custom detection validation, service removal checks, SFTP testing, and post-remediation scanning.

Validation confirmed the following:

- `vsftpd` was intentionally deployed and listening on TCP port `21`.
- Nessus identified FTP-related findings on the victim server.
- Nessus plugin details confirmed the FTP service banner and exposure on TCP port `21`.
- Kali successfully authenticated to FTP, listed files, and retrieved a test file.
- Security Onion Hunt showed Zeek FTP metadata for the FTP session.
- pfSense firewall logs confirmed FTP traffic across the expected attacker-to-victim VLAN path.
- A custom Security Onion detection was created for FTP connections to the victim server.
- Security Onion validated that the custom FTP detection triggered successfully.
- FTP was stopped, disabled, removed, and verified as no longer listening.
- SFTP over SSH successfully replaced FTP for encrypted file transfer.
- Post-remediation Nessus results confirmed the FTP service findings were removed.
- FTP connections were refused after remediation while SFTP remained functional.

## Challenges and Lessons Learned

This project reinforced that vulnerability management is more than identifying a scanner finding. A complete remediation workflow should validate business context, technical exposure, monitoring visibility, firewall path, detection logic, remediation steps, secure replacement, and post-remediation verification.

The project also demonstrated that informational scanner findings can still represent meaningful risk when they involve insecure legacy protocols. FTP may appear as a simple exposed service, but the lack of encryption creates risk for credentials, commands, filenames, and transferred data.

A key lesson was that remediation should preserve business function when possible. Replacing FTP with SFTP removed the insecure protocol while maintaining the ability to transfer files securely.

## Security Relevance

This project demonstrates how vulnerability discovery, detection engineering, and remediation connect in real security operations. Vulnerabilities should not only be scanned and reported; they should be validated, monitored, remediated, and re-tested.

The project also demonstrates the value of post-remediation detection. The custom FTP detection helps identify whether the insecure service or protocol returns in the future, supporting continuous monitoring after the remediation is complete.

## Business Value

This project demonstrates the ability to identify an insecure legacy service, explain its business purpose, evaluate the security risk, validate the exposure with multiple tools, remediate the issue, and confirm that a secure replacement is functional.

The workflow reflects real vulnerability management and security operations practices. Rather than only identifying a finding, the project follows the issue through detection, analysis, remediation, monitoring, and verification. This type of process supports risk reduction, audit readiness, incident response handoffs, and operational security improvement.

In an enterprise environment, this type of work helps teams:

- Identify and validate insecure legacy services.
- Explain technical risk in business terms.
- Confirm exposure using scanner, firewall, SIEM, and client-side evidence.
- Replace insecure services with secure alternatives.
- Validate remediation with post-remediation testing.
- Monitor for reintroduction of deprecated protocols.

## Portfolio Summary

This capstone project brings together several major areas of the homelab portfolio: segmentation, vulnerability scanning, network monitoring, firewall validation, detection engineering, remediation, and secure replacement of legacy services.

The project began with an intentionally deployed FTP service that represented a realistic legacy business workflow. Nessus identified the exposed service, Kali validated that it could be used, Security Onion confirmed network visibility, and pfSense validated the traffic path. The insecure service was then removed and replaced with SFTP. Final validation confirmed that FTP was no longer reachable while secure file transfer remained available.

This project demonstrates a complete security engineering workflow from discovery through remediation and post-remediation validation.