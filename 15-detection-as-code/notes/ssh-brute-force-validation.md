# SSH Brute Force Detection Validation

## Test Summary

This validation documents controlled SSH brute force activity generated in the homelab and converts the results into a detection-as-code workflow. The activity involved repeated failed SSH login attempts from Kali Linux against an Ubuntu victim system.

## Purpose

The purpose of this detection is to identify repeated failed SSH authentication attempts from a single source host within a short time window. This behavior may indicate brute force activity, credential guessing, or unauthorized access attempts.

## Lab Systems

| Role | System |
|---|---|
| Attacker | Kali Linux |
| Victim | Ubuntu Victim |
| Monitoring | Security Onion |
| Network Control | pfSense |
| Virtualization | Proxmox / VirtualBox |

## MITRE ATT&CK Mapping

| Field | Value |
|---|---|
| Tactic | Credential Access |
| Technique | Brute Force |
| Technique ID | T1110 |

## Detection Logic Summary

The detection looks for multiple SSH authentication failures from the same source IP within a short time window. A threshold of five failed attempts in five minutes is used as the initial lab rule.

## Test Procedure

1. Confirmed SSH was running on the Ubuntu victim.
2. Generated repeated failed SSH login attempts from Kali Linux.
3. Reviewed Ubuntu authentication logs for failed login messages.
4. Searched Security Onion for SSH traffic between Kali and the Ubuntu victim.
5. Compared the observed activity against the detection logic.

## Expected Evidence

The validation should include:

- Failed SSH login attempts from Kali.
- Ubuntu authentication logs showing failed login attempts.
- Security Onion events showing SSH activity between Kali and the Ubuntu victim.
- Detection rule file showing the documented logic.
- Notes describing false positives and tuning considerations.

## Validation Results

The SSH brute force activity was generated and validated in the homelab. Failed authentication attempts were visible on the Ubuntu victim, and related SSH activity was observed in Security Onion. The observed behavior matched the detection logic because multiple failed SSH authentication attempts originated from the same source host within a short time window.

## False Positive Considerations

A small number of failed SSH logins can happen during normal administration. This detection should not alert on one or two failures. The threshold helps separate normal mistakes from suspicious repeated login attempts.

Possible false positives include:

- A legitimate user mistyping a password multiple times.
- An administrator troubleshooting SSH access.
- A script or automation task using outdated credentials.
- A monitoring tool attempting to authenticate with an old password.

## Tuning Notes

Future tuning improvements could include:

- Increasing severity when many usernames are attempted.
- Increasing severity when failed logins are followed by a successful login.
- Filtering known administrator systems.
- Comparing activity against normal login behavior.
- Correlating authentication logs with network telemetry.

## Conclusion

This detection-as-code rule demonstrates how controlled lab telemetry can be converted into reusable detection documentation. The rule can be expanded later with additional SIEM query logic, Sigma-style formatting, alert thresholds, or automated response actions.
