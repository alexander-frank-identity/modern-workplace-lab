# Modern Workplace Lab

Microsoft 365 und Identity so, wie es in einem Mittelstandsprojekt zusammenhängt: Ein Mitarbeiter wird angelegt, bekommt ein verwaltetes Gerät, kommt nur mit MFA und konformem Gerät an seine Daten und wird beim Austritt sauber abgebaut. Daneben Okta als zweite Identity-Plattform.

Alles selbst gebaut, in eigenen Testumgebungen, mit Screenshots und den Fehlern, die mir dabei passiert sind.

## Auf einen Blick

| | Thema | Was gezeigt wird |
|---|---|---|
| [01](01-jml/) | **Identity Lifecycle (JML)** | Joiner, Mover, Leaver per Microsoft Graph PowerShell: 8 Skripte, 8 Screenshots |
| [02](02-autopilot/) | **Windows-Geräte & Autopilot** | Entra Join mit automatischer Intune-Registrierung, Gruppenstruktur, Autopilot-Profil |
| [03](03-compliance-ca/) | **Compliance & Conditional Access** | Compliance für Windows und macOS, CA mit MFA und konformem Gerät, Rollout-Verfahren |
| [04](04-android-enterprise/) | **Android Enterprise** | Dediziertes Gerät per QR-Code, Apps aus Managed Google Play, Fernaktionen |
| [05](05-okta/) | **Okta** | Group Rules, delegierte Admin-Rollen, Session- und App-Policies, System Log, SAML-Föderation |

## Wie die Teile zusammenhängen

```
01 Benutzer entsteht ──► Gruppen ──► Lizenz, Apps, Richtlinien
                                         │
02 Windows / macOS  ─┐                   ▼
04 Android          ─┴──► Intune bewertet das Gerät ──► 03 Conditional Access
                                                         (MFA + konformes Gerät)
05 Okta: dieselben Konzepte auf der zweiten Plattform
```

## Umgebung

| Komponente | Einsatz |
|---|---|
| Microsoft 365 Business Premium (Testmandant) | Entra ID P1, Intune |
| Windows 11 (VM, ARM) und MacBook Pro | Entra Join bzw. Unternehmensportal, Compliance |
| Samsung Galaxy A16, Android 16 | Android Enterprise, dediziertes Gerät |
| PowerShell 7, Microsoft Graph PowerShell SDK | Lifecycle-Automatisierung |
| Okta Workforce Identity (2 Orgs) | Föderation, Policies, delegierte Administration |

## Hinweis

Eigene Laborumgebung, keine Kundendaten, keine echten Personen. Token, QR-Codes, Objekt-IDs und private Adressen sind geschwärzt. Der Microsoft-Testmandant und die Okta-Orgs sind inzwischen abgelaufen. Was dort nicht mehr dokumentiert werden konnte, steht im jeweiligen Abschnitt unter „Nächste Stufe“.

---

**Alexander Frank** · Microsoft Modern Workplace & Identity · freiberuflich, remote DACH
SC-300 · MD-102 · Okta Certified Professional · Okta Certified Administrator · Android Enterprise Certified Expert
[LinkedIn](https://www.linkedin.com/in/alexander-frank-identity)
