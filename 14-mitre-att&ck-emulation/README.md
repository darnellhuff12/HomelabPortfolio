# Project 14: MITRE ATT&CK Emulation with Caldera

## Project Status

Complete

## Objective

The goal of this project was to deploy MITRE Caldera inside the homelab, use it to establish a controlled agent connection to an approved victim system, run a safe non-destructive discovery operation, and validate the resulting activity in Security Onion.

This project demonstrates adversary-emulation fundamentals, segmented lab design, controlled firewall access, agent-based command execution, and blue-team visibility using Zeek telemetry in Security Onion. All testing was performed only against systems owned and controlled inside the homelab.

## Why This Project Matters

Previous projects focused on building the network foundation, segmenting VLANs, validating firewall rules, deploying Security Onion, confirming mirrored traffic visibility, detecting reconnaissance, detecting SSH brute-force activity, running web application testing, vulnerability scanning, hardening, and secure remote administration.

This project builds on that foundation by adding controlled MITRE ATT&CK-style emulation. Rather than only generating manual traffic, Caldera was used to deploy an agent and execute repeatable discovery commands against a lab victim. The resulting traffic was then reviewed in Security Onion, moving the lab closer to a realistic attack-and-detect workflow.

## Lab Environment

| Component | Role |
|---|---|
| MITRE Caldera | Adversary emulation platform hosted on Ubuntu Server |
| Ubuntu Victim | Approved endpoint target for the Caldera agent and discovery operation |
| Security Onion | SIEM/NDR platform used for Hunt, Zeek logs, and traffic validation |
| pfSense | Firewall and inter-VLAN traffic control |
| Netgear Managed Switch | VLAN tagging and traffic mirroring |
| Raspberry Pi 5 | Bastion host, Omada controller, and Tailscale access point |
| M2 MacBook Air | Administrative workstation used to access Caldera through an SSH tunnel |

## Network Design

Caldera was placed on the attacker/testing VLAN and the Ubuntu victim remained on the victim VLAN. Access to the Caldera web interface was not exposed directly to the home network. Instead, the MacBook used a local SSH tunnel through the Raspberry Pi bastion.

| System | Placement / Address |
|---|---|
| Caldera Server | Attacker VLAN / `192.168.20.102` |
| Ubuntu Victim | Victim VLAN / `192.168.40.103` |
| Caldera Web/API Port | TCP `8888` |
| MacBook Tunnel Port | Localhost TCP `8222` |
| Security Onion Management | SIEM VLAN |
| Security Onion Monitoring Interface | Mirror/SPAN traffic only |
| Admin Access | Tailscale and Raspberry Pi bastion path |

The Caldera web UI was accessed from the MacBook at:

```text
http://localhost:8222
```

The tunnel forwarded the local MacBook port to the Caldera server:

```text
MacBook localhost:8222 -> Raspberry Pi bastion -> 192.168.20.102:8888
```

The Caldera agent used the direct lab address rather than the MacBook tunnel:

```text
http://192.168.20.102:8888
```

## Security Boundaries

The following boundaries were used for this project:

- Caldera was used only inside the isolated homelab.
- The agent was deployed only to the approved Ubuntu victim.
- The operation was limited to non-destructive discovery commands.
- The victim VLAN was allowed to reach only the Caldera server on TCP `8888` for agent check-in.
- ICMP from the victim to Caldera was not broadly allowed.
- The home network remained isolated from attacker and victim lab activity.
- Security Onion was used to validate that the activity was visible through existing monitoring.

## Implementation Summary

### 1. Caldera Server Deployment

An Ubuntu Server VM named `caldera` was deployed on the attacker/testing VLAN with the IP address `192.168.20.102`. Required packages were installed, including Python, pip, Node/npm, Go, Git, and build tools. The Caldera repository was cloned under the user home directory and prepared for use.

Evidence:

- [Caldera Ubuntu server installed on VLAN 20](evidence/01-caldera-ubuntu-installed-vlan20.png)
- [Caldera dependencies installed](evidence/02-caldera-dependencies-installed.png)
- [Caldera repository cloned](evidence/03-caldera-repository-cloned.png)

### 2. Caldera Startup Workflow

A reusable startup script was created on the Caldera server so the service can be started consistently without manually typing the full command sequence each time. The script enters the Caldera directory, activates the Python virtual environment, and starts the Caldera server.

Evidence:

- [Caldera start script created](evidence/04-caldera-start-script-created.png)
- [Caldera server running](evidence/05-caldera-server-running.png)

### 3. Secure Web UI Access Through Tunnel

The Caldera web interface was accessed from the MacBook using an SSH tunnel through the Raspberry Pi bastion. The tunnel forwards local port `8222` on the MacBook to TCP `8888` on the Caldera server. The SSH tunnel uses `-N -T` so it does not drop the user into an interactive Raspberry Pi shell.

Evidence:

- [Caldera tunnel script created](evidence/06-caldera-tunnel-script-created.png)
- [Caldera dashboard accessed through tunnel](evidence/07-caldera-dashboard.png)

### 4. Victim System Preparation

The Ubuntu victim was prepared as the approved target system. The victim was confirmed to be on the victim VLAN with IP address `192.168.40.103`, running as the `labuser` account.

Evidence:

- [Victim system prepared](evidence/08-victim-system-prepared.png)

### 5. Controlled Firewall Access

A pfSense rule was created on the victim VLAN allowing the Ubuntu victim network to reach the Caldera server on TCP `8888`. This rule was placed above the broader RFC1918/private network block rule so the specific Caldera agent traffic would be allowed while other unauthorized internal access remained blocked.

Connectivity testing showed that ICMP to the Caldera server was blocked, while TCP access to the Caldera web/API service succeeded. This confirmed a least-privilege firewall design: the victim could reach the required Caldera service without broad inter-VLAN access.

Evidence:

- [pfSense victim-to-Caldera rule](evidence/09-pfsense-victim-to-caldera-rule.png)
- [Victim-to-Caldera connectivity test](evidence/10-victim-to-caldera-connectivity.png)

### 6. Caldera Agent Deployment

The Sandcat agent was deployed from the Ubuntu victim using the Caldera server address `http://192.168.20.102:8888`. The agent was assigned to the `red` group and successfully established an HTTP beacon back to the Caldera server.

Evidence:

- [Caldera agent command on victim](evidence/11-caldera-agent-command-on-victim.png)
- [Caldera agent check-in](evidence/12-caldera-agent-check-in.png)

### 7. Basic Non-Destructive Operation

A basic operation named `project14-basic-discovery` was created using manual commands, the `red` group, and plain-text obfuscation. The operation was intentionally limited to safe discovery activity such as hostname, user, kernel, and network/interface information.

The operation completed successfully against the Ubuntu victim. Caldera recorded multiple successful manual command executions and collected host facts including the victim IP address.

Evidence:

- [Basic operation configured](evidence/13-basic-operation-configured.png)
- [Basic operation completed](evidence/14-basic-operation-completed.png)
- [Basic operation command output](evidence/15-basic-operation-command-output.png)

### 8. Security Onion Visibility

Security Onion Hunt was used to validate that Caldera activity was visible in the monitoring stack. Searches for both the Caldera server IP and Ubuntu victim IP returned Zeek telemetry, including HTTP, connection, file, DNS, software, and weird logs.

The strongest observed traffic showed the Ubuntu victim communicating with the Caldera server over TCP `8888` using HTTP POST requests with `200 OK` responses. This validated that Security Onion could observe the Caldera agent check-in and command/result traffic.

Evidence:

- [Security Onion Caldera IP hunt](evidence/16-security-onion-caldera-ip-hunt.png)
- [Security Onion victim IP hunt](evidence/17-security-onion-victim-ip-hunt.png)
- [Security Onion flow detail evidence](evidence/18-security-onion-flow-or-pcap-evidence.png)

## Evidence Checklist

- [x] Caldera host system created and placed on VLAN 20
- [x] Caldera dependencies installed
- [x] Caldera repository cloned
- [x] Caldera start script created
- [x] Caldera server started successfully
- [x] Caldera web interface reachable through SSH tunnel
- [x] Victim system prepared and documented
- [x] pfSense rule created for controlled victim-to-Caldera access
- [x] Victim-to-Caldera TCP `8888` connectivity validated
- [x] Caldera agent deployed to the victim system
- [x] Agent successfully checked in to Caldera
- [x] Basic non-destructive operation configured
- [x] Operation completed successfully
- [x] Command output/facts collected from the victim
- [x] Security Onion Hunt query showed Caldera-related traffic
- [x] Security Onion Hunt query showed victim-related traffic
- [x] Expanded Zeek event showed victim-to-Caldera traffic details

## Evidence Files

```text
01-caldera-ubuntu-installed-vlan20.png
02-caldera-dependencies-installed.png
03-caldera-repository-cloned.png
04-caldera-start-script-created.png
05-caldera-server-running.png
06-caldera-tunnel-script-created.png
07-caldera-dashboard.png
08-victim-system-prepared.png
09-pfsense-victim-to-caldera-rule.png
10-victim-to-caldera-connectivity.png
11-caldera-agent-command-on-victim.png
12-caldera-agent-check-in.png
13-basic-operation-configured.png
14-basic-operation-completed.png
15-basic-operation-command-output.png
16-security-onion-caldera-ip-hunt.png
17-security-onion-victim-ip-hunt.png
18-security-onion-flow-or-pcap-evidence.png
```

## Key Findings

- Caldera was successfully deployed on the attacker/testing VLAN.
- The Caldera web interface was accessed securely through the existing Raspberry Pi bastion workflow.
- The Ubuntu victim was able to reach the Caldera server on TCP `8888` while ICMP remained blocked.
- The Sandcat agent successfully checked in over HTTP.
- A controlled manual discovery operation completed successfully against the approved victim.
- Security Onion captured Zeek telemetry for both the Caldera server and victim endpoint.
- Zeek HTTP logs showed victim-to-Caldera POST traffic to TCP `8888` with successful HTTP responses.
- A Zeek `weird` event also recorded the same victim-to-Caldera flow. The checksum-related message was likely influenced by virtualization, checksum offload, or mirrored traffic behavior and did not prevent visibility.

## Detection Engineering Value

This project creates the foundation for future detection engineering work. With Caldera deployed and validated, future projects can focus on:

- Mapping specific Caldera abilities to MITRE ATT&CK techniques.
- Reviewing the telemetry generated by specific attacker behaviors.
- Comparing Zeek, Suricata, and endpoint-level visibility.
- Creating and tuning detection logic.
- Building repeatable attack-and-detect workflows.
- Writing incident reports based on simulated activity.

## Skills Demonstrated

- MITRE ATT&CK awareness
- Caldera deployment and configuration
- Adversary emulation planning
- Safe lab testing boundaries
- VLAN-aware security testing
- pfSense rule placement and least-privilege firewall design
- SSH tunneling through a bastion host
- Controlled agent deployment
- Non-destructive discovery operation execution
- Security Onion Hunt usage
- Zeek telemetry analysis
- Network visibility validation
- Detection engineering preparation
- Portfolio documentation

## Challenges and Lessons Learned

- Caldera exposed multiple listening ports, and the working web UI path required tunneling to TCP `8888` rather than TCP `2222`.
- A reusable MacBook tunnel script simplified access and avoided exposing the Caldera web UI directly.
- The server-side Caldera start script made it easier to restart the platform consistently.
- The victim firewall rule needed to be specific enough to allow TCP `8888` to Caldera while keeping broader private network access blocked.
- ICMP failure did not indicate a problem because the required TCP application path was working.
- A `curl -I` test returned `405 Method Not Allowed`, but the response still proved TCP connectivity to the Caldera service because the server replied and indicated allowed methods.
- Some Caldera abilities may not run cleanly on every platform, so the initial operation was kept to simple manual Linux discovery commands.
- Security Onion provided useful visibility into the agent traffic through Zeek HTTP, connection, file, software, and weird logs.

## Project Outcome

This project successfully introduced MITRE Caldera into the homelab and validated that it can support controlled adversary-emulation activity. A Sandcat agent was deployed to an approved Ubuntu victim, a safe discovery operation was executed, and Security Onion confirmed visibility into the resulting victim-to-Caldera traffic.

The project also confirmed that the existing segmentation, firewall rule structure, bastion access model, and Security Onion monitoring design can support safe attack simulation and blue-team analysis.

## Next Steps

Future projects can build on this by running specific ATT&CK-aligned techniques, documenting the telemetry generated by each technique, and creating custom detections inside Security Onion.

Potential next projects:

- ATT&CK Technique Emulation and Detection
- Caldera Operation Analysis in Security Onion
- Custom Detection Rule Creation
- Endpoint Telemetry Comparison
- Incident Report Based on Simulated Attack Activity