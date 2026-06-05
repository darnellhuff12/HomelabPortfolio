# Project 8: Web Application Scanning with OWASP ZAP and Juice Shop

## Objective

This project documents the setup and validation of a controlled web application security testing lab using **OWASP ZAP** and **OWASP Juice Shop**. The goal is to safely practice web application reconnaissance, vulnerability scanning, proxy-based testing, and SIEM visibility inside the isolated homelab environment.

This project builds on the previous network segmentation, SIEM deployment, traffic mirroring, and attack-detection projects by adding a vulnerable web application target and a dedicated web application scanning workflow.

## Lab Environment

| Component | Purpose |
|---|---|
| pfSense | Firewall, VLAN routing, and network segmentation |
| Proxmox | Virtualization platform for lab systems |
| Kali Linux | Attacker/testing workstation |
| OWASP ZAP | Web application proxy and vulnerability scanner |
| OWASP Juice Shop | Intentionally vulnerable web application target |
| Security Onion | SIEM and network visibility platform |
| Managed Switch | VLAN tagging and traffic mirroring |
| Raspberry Pi 5 | Bastion host and secure remote access point |

## Network Placement

The web application testing workflow is performed inside the isolated homelab network. Kali is used as the scanning workstation, Juice Shop is used as the vulnerable target, and Security Onion is used to observe related network activity.

| System | VLAN / Role | Notes |
|---|---|---|
| Kali Linux | Attacker VLAN | Runs OWASP ZAP and browser-based testing tools |
| Juice Shop | Victim / Target VLAN | Hosts the intentionally vulnerable web application |
| Security Onion | SIEM VLAN | Monitors mirrored traffic from the lab environment |
| pfSense | Firewall | Controls traffic between VLANs |

## Validation Goals

- Deploy or access OWASP Juice Shop in the lab environment.
- Install and launch OWASP ZAP from the Kali workstation.
- Confirm that Kali can reach the Juice Shop web application.
- Configure browser proxying through ZAP.
- Capture baseline web traffic using ZAP.
- Run a safe automated scan against Juice Shop.
- Review discovered alerts and categorize findings by severity.
- Confirm that Security Onion can observe the related web scanning traffic.
- Document the workflow with clear screenshots and evidence.

## Tools Used

- OWASP ZAP
- OWASP Juice Shop
- Kali Linux
- Security Onion
- pfSense
- Proxmox
- Docker or local application hosting
- Web browser configured to proxy through ZAP

## Business and Security Value

Web application scanning is a common part of vulnerability management, application security testing, and security validation. OWASP ZAP provides a safe way to inspect web traffic, identify common application weaknesses, and practice interpreting scanner output.

This project connects web application testing with blue-team visibility by validating that Security Onion can observe web scanning traffic generated from Kali against the Juice Shop target. This demonstrates both offensive testing workflow and defensive monitoring awareness.

## Scope and Rules of Engagement

All testing was limited to the isolated homelab environment. OWASP Juice Shop was used as the intentionally vulnerable target application, and scanning activity was performed only against the lab-hosted Juice Shop instance.

Out of scope:

- Public internet targets
- Third-party websites
- Production applications
- Unauthorized scanning
- Exploitation outside the lab environment

## Validation and Evidence

Web application scanning was validated through target deployment, attacker connectivity, ZAP launch, proxy-based browsing, automated scan execution, alert review, firewall rule review, Security Onion visibility, and ZAP report generation.

| Validation Area | Result | Evidence |
|---|---|---|
| Docker service validation | Passed - Docker was installed and running on the Ubuntu victim host | [01-docker-installed.png](evidence/01-docker-installed.png) |
| Juice Shop deployment | Passed - Juice Shop was running in Docker and listening on port `3000` | [02-juice-shop-running-docker.png](evidence/02-juice-shop-running-docker.png) |
| Kali connectivity to Juice Shop | Passed - Kali successfully reached Juice Shop using ping and curl | [03a-kali-access-to-juice-shop.png](evidence/03a-kali-access-to-juice-shop.png) |
| Browser access to Juice Shop | Passed - Juice Shop loaded successfully in the Kali browser | [03b-kali-access-to-juice-shop.png](evidence/03b-kali-access-to-juice-shop.png) |
| OWASP ZAP launch | Passed - OWASP ZAP opened successfully on Kali | [04-zap-launched.png](evidence/04-zap-launched.png) |
| ZAP HUD and browser exploration | Passed - ZAP HUD was enabled while manually browsing Juice Shop | [05-zap-hud-juice-shop-browser.png](evidence/05-zap-hud-juice-shop-browser.png) |
| ZAP proxy history | Passed - ZAP captured HTTP requests and responses from Juice Shop browsing | [06-zap-history-capturing-juice-shop.png](evidence/06-zap-history-capturing-juice-shop.png) |
| ZAP automated scan | Passed - Automated scanning completed against the Juice Shop target | [07-zap-scan-running.png](evidence/07-zap-scan-running.png) |
| ZAP alert review | Passed - ZAP identified multiple web application findings, including SQL injection and security header alerts | [08-zap-alerts-summary.png](evidence/08-zap-alerts-summary.png) |
| Security Onion visibility | Passed - Security Onion observed web scanning traffic and related Suricata alerts | [09-security-onion-web-scan-visibility.png](evidence/09-security-onion-web-scan-visibility.png) |
| pfSense web testing rule review | Passed - Firewall rule evidence confirmed the lab traffic path for web application testing | [10-pfsense-web-testing-rule.png](evidence/10-pfsense-web-testing-rule.png) |
| ZAP report generation | Passed - A ZAP-generated report was exported for review | [11-zap-generated-report.png](evidence/11-zap-generated-report.png) |

## Implementation Summary

OWASP Juice Shop was hosted inside the lab as an intentionally vulnerable web application target. Kali was used as the testing workstation, with OWASP ZAP providing proxy-based traffic inspection and automated web application scanning. After confirming network access to Juice Shop, browser traffic was proxied through ZAP, baseline HTTP requests were captured, and an automated scan was executed against the lab target. The results were reviewed in ZAP, exported as a report, and correlated with Security Onion visibility and pfSense firewall rule evidence.

## Evidence Summary

The following evidence documents the completed OWASP ZAP and Juice Shop web application scanning workflow.

| ID | Evidence | What It Demonstrates |
|---|---|---|
| 01 | [01-docker-installed.png](evidence/01-docker-installed.png) | Docker service enabled and running on the Ubuntu victim host |
| 02 | [02-juice-shop-running-docker.png](evidence/02-juice-shop-running-docker.png) | Juice Shop Docker container running and mapped to port `3000` |
| 03a | [03a-kali-access-to-juice-shop.png](evidence/03a-kali-access-to-juice-shop.png) | Kali successfully reaching Juice Shop with ping and curl |
| 03b | [03b-kali-access-to-juice-shop.png](evidence/03b-kali-access-to-juice-shop.png) | Juice Shop loaded in the Kali browser |
| 04 | [04-zap-launched.png](evidence/04-zap-launched.png) | OWASP ZAP launched on Kali |
| 05 | [05-zap-hud-juice-shop-browser.png](evidence/05-zap-hud-juice-shop-browser.png) | ZAP HUD enabled while manually browsing Juice Shop |
| 06 | [06-zap-history-capturing-juice-shop.png](evidence/06-zap-history-capturing-juice-shop.png) | ZAP history populated with captured Juice Shop requests |
| 07 | [07-zap-scan-running.png](evidence/07-zap-scan-running.png) | ZAP automated scan completed against the Juice Shop target |
| 08 | [08-zap-alerts-summary.png](evidence/08-zap-alerts-summary.png) | ZAP alerts summary showing discovered web application findings |
| 09 | [09-security-onion-web-scan-visibility.png](evidence/09-security-onion-web-scan-visibility.png) | Security Onion visibility of web scanning traffic and related alerts |
| 10 | [10-pfsense-web-testing-rule.png](evidence/10-pfsense-web-testing-rule.png) | pfSense firewall rule evidence for the web testing traffic path |
| 11 | [11-zap-generated-report.png](evidence/11-zap-generated-report.png) | Exported ZAP report evidence |

## Key Evidence

The screenshots below highlight the most important web application scanning evidence while the table above preserves links to the full evidence set.

**Juice Shop Target Application**

![Juice Shop running in Kali browser](./evidence/03b-kali-access-to-juice-shop.png)

**ZAP Alert Results**

![OWASP ZAP alerts summary](./evidence/08-zap-alerts-summary.png)

**Security Onion Detection Visibility**

![Security Onion web scan visibility](./evidence/09-security-onion-web-scan-visibility.png)

## Key Findings

This project demonstrated how a vulnerable web application can be safely tested inside an isolated lab while maintaining visibility through the SIEM. OWASP ZAP provided the application security testing perspective, while Security Onion provided the network monitoring and detection perspective.

ZAP identified multiple web application findings against Juice Shop, including SQL injection-related alerts, missing security headers, content security policy issues, cross-domain misconfiguration, information disclosure, and application error disclosure. These findings are expected for an intentionally vulnerable training application and provide useful practice for interpreting scan output.

Security Onion also observed the scan activity and generated related Suricata alerts for web application attack patterns against the Juice Shop target on port `3000`. This confirms that the offensive web scanning activity was visible from the defensive monitoring side of the lab.

## Skills Demonstrated

- Web application security testing
- Vulnerability scanning
- Proxy-based traffic inspection
- OWASP ZAP usage
- Vulnerable application deployment
- HTTP traffic analysis
- SIEM validation
- Security Onion log review
- Lab isolation and safe testing practices
- Documentation of offensive and defensive workflows

## Lessons Learned

This project reinforces the importance of combining vulnerability discovery with detection engineering. Running a scanner is only one part of the workflow. A stronger security process also confirms whether the activity is visible to monitoring tools and whether defenders can identify the behavior in logs.

This project also showed how a single web application scan can create useful evidence across multiple layers of the lab: Docker on the victim host, browser access from Kali, ZAP proxy history, ZAP alert output, pfSense rule validation, and Security Onion detections.

## Remediation Concepts

Although Juice Shop is intentionally vulnerable, the findings from ZAP can be mapped to real-world remediation practices such as:

- Adding missing security headers.
- Improving input validation.
- Enforcing secure authentication behavior.
- Reducing information disclosure.
- Hardening application configuration.
- Monitoring suspicious web activity in SIEM tools.

## Project Status

| Area | Status |
|---|---|
| Juice Shop deployment validated | Complete |
| Kali connectivity to Juice Shop validated | Complete |
| OWASP ZAP launched and configured | Complete |
| Browser traffic captured through ZAP | Complete |
| Automated ZAP scan completed | Complete |
| ZAP findings reviewed | Complete |
| ZAP report generated | Complete |
| pfSense web testing rule documented | Complete |
| Security Onion visibility confirmed | Complete |
| Evidence screenshots captured and linked | Complete |

## Portfolio Value

This project adds a web application security component to the homelab portfolio. It shows the ability to test a vulnerable application with OWASP ZAP, interpret scan results, and validate defensive visibility through Security Onion. This helps connect offensive testing, vulnerability management, and blue-team monitoring into one documented workflow.