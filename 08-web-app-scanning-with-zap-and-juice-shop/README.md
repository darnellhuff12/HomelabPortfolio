# Project 8: Web Application Scanning with OWASP ZAP and Juice Shop

## Project Overview

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

## Objectives

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

## Implementation Steps

### 1. Prepare the Target Application

OWASP Juice Shop should be started on the victim or target system. Once running, the application should be reachable from the Kali workstation over HTTP.

Example access format:

```text
http://<juice-shop-ip>:3000
```

The target application should only be exposed inside the lab network.

### 2. Verify Network Connectivity

From Kali, verify that the Juice Shop host is reachable.

Example checks:

```bash
ping <juice-shop-ip>
curl http://<juice-shop-ip>:3000
```

Successful connectivity confirms that the attacker workstation can access the vulnerable web application through the intended lab path.

### 3. Launch OWASP ZAP

OWASP ZAP is launched from Kali and used as the primary testing tool for this project.

ZAP provides two important functions for this lab:

1. Passive inspection of browser traffic.
2. Active vulnerability scanning against the Juice Shop application.

### 4. Configure Browser Proxying

The browser on Kali should be configured to send traffic through ZAP.

Typical proxy settings:

| Setting | Value |
|---|---|
| Proxy Host | `127.0.0.1` |
| Proxy Port | `8080` |
| Protocol | HTTP / HTTPS |

After proxying is enabled, browsing to Juice Shop should cause requests and responses to appear inside ZAP.

### 5. Capture Baseline Traffic

Before running an automated scan, manually browse the Juice Shop application while ZAP is proxying the traffic.

Baseline browsing should include:

- Loading the home page.
- Navigating between pages.
- Viewing product details.
- Opening login or account-related pages.
- Confirming requests appear in the ZAP history tab.

This establishes that ZAP is correctly intercepting web traffic.

### 6. Run a ZAP Scan

A safe scan is run against Juice Shop to identify common web application security issues. Since Juice Shop is intentionally vulnerable and isolated inside the lab, it is an appropriate target for this activity.

The scan should only target the lab-hosted Juice Shop URL.

Example target format:

```text
http://<juice-shop-ip>:3000
```

### 7. Review ZAP Alerts

After the scan completes, review the discovered alerts in ZAP.

Findings should be grouped by severity:

| Severity | Description |
|---|---|
| High | Issues that may allow serious compromise or exploitation |
| Medium | Issues that may increase risk or support further attacks |
| Low | Lower-impact weaknesses or misconfigurations |
| Informational | Observations useful for assessment context |

The purpose of this step is not only to collect alerts, but also to understand what each finding means and how it could be remediated in a real environment.

### 8. Validate Security Onion Visibility

Security Onion should be checked to confirm that web scanning traffic is visible from the monitoring side of the lab.

Useful items to search for include:

- Kali source IP address.
- Juice Shop target IP address.
- HTTP traffic.
- ZAP user-agent strings if visible.
- Suricata alerts related to web scanning activity.
- Zeek HTTP logs.

This step connects the web application testing activity back to the larger detection and monitoring goals of the homelab.

## Evidence Collected

| Evidence Item | Description | Status |
|---|---|---|
| Docker installed | Docker service enabled and running on the Ubuntu victim host | Complete |
| Juice Shop running | Juice Shop container running and listening on port `3000` | Complete |
| Kali connectivity test | Kali successfully pinged and curled the Juice Shop web application | Complete |
| Juice Shop browser access | Juice Shop loaded successfully from Kali in the browser | Complete |
| ZAP launched | OWASP ZAP opened successfully on Kali | Complete |
| ZAP HUD enabled | ZAP HUD used during manual browser exploration of Juice Shop | Complete |
| ZAP history populated | ZAP captured HTTP requests and responses from Juice Shop browsing | Complete |
| ZAP automated scan | Automated scan completed against the Juice Shop target URL | Complete |
| ZAP alerts summary | ZAP identified multiple alerts, including SQL injection and security header findings | Complete |
| Security Onion visibility | Security Onion observed web scanning traffic and related Suricata alerts to the Juice Shop target | Complete |
| pfSense web testing rule | Firewall rule evidence showing lab traffic path for web testing | Complete |
| Generated ZAP report | Screenshot showing the exported ZAP-generated report | Complete |

## Screenshots

The following screenshots were captured and stored in the `evidence/` folder.

| Screenshot | Description |
|---|---|
| [01-docker-installed.png](evidence/01-docker-installed.png) | Docker service enabled and running on the Ubuntu victim host |
| [02-juice-shop-running-docker.png](evidence/02-juice-shop-running-docker.png) | Juice Shop Docker container running and mapped to port `3000` |
| [03a-kali-access-to-juice-shop.png](evidence/03a-kali-access-to-juice-shop.png) | Kali successfully reaching Juice Shop with ping and curl |
| [03b-kali-access-to-juice-shop.png](evidence/03b-kali-access-to-juice-shop.png) | Juice Shop loaded in the Kali browser |
| [04-zap-launched.png](evidence/04-zap-launched.png) | OWASP ZAP launched on Kali |
| [05-zap-hud-juice-shop-browser.png](evidence/05-zap-hud-juice-shop-browser.png) | ZAP HUD enabled while manually browsing Juice Shop |
| [06-zap-history-capturing-juice-shop.png](evidence/06-zap-history-capturing-juice-shop.png) | ZAP history populated with captured Juice Shop requests |
| [07-zap-scan-running.png](evidence/07-zap-scan-running.png) | ZAP automated scan completed against the Juice Shop target |
| [08-zap-alerts-summary.png](evidence/08-zap-alerts-summary.png) | ZAP alerts summary showing discovered web application findings |
| [09-security-onion-web-scan-visibility.png](evidence/09-security-onion-web-scan-visibility.png) | Security Onion visibility of web scanning traffic and related alerts |
| [10-pfsense-web-testing-rule.png](evidence/10-pfsense-web-testing-rule.png) | pfSense firewall rule evidence for the web testing traffic path |
| [11-zap-generated-report.png](evidence/11-zap-generated-report.png) | Exported ZAP report evidence |

## Key Evidence Highlights

### Juice Shop Target Application

![Juice Shop running in Kali browser](./evidence/03b-kali-access-to-juice-shop.png)

### ZAP Alert Results

![OWASP ZAP alerts summary](./evidence/08-zap-alerts-summary.png)

### Security Onion Detection Visibility

![Security Onion web scan visibility](./evidence/09-security-onion-web-scan-visibility.png)

## Key Findings

This project demonstrates how a vulnerable web application can be safely tested inside an isolated lab while maintaining visibility through the SIEM. OWASP ZAP provided the application security testing perspective, while Security Onion provided the network monitoring and detection perspective.

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

**Status:** Complete

This project is complete with evidence showing Juice Shop deployment, Kali connectivity, ZAP proxy capture, automated scan results, generated report evidence, pfSense rule validation, and Security Onion visibility.

## Portfolio Value

This project adds a web application security component to the homelab portfolio. It shows the ability to test a vulnerable application with OWASP ZAP, interpret scan results, and validate defensive visibility through Security Onion. This helps connect offensive testing, vulnerability management, and blue-team monitoring into one documented workflow.