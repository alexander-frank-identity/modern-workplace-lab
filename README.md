# Modern Workplace Lab

Meine Laborumgebung für Microsoft 365 und Identity: Entra ID, Intune, Conditional Access, Android Enterprise, Lifecycle-Automatisierung mit Microsoft Graph und daneben Okta als zweite Identity-Plattform.

Die einzelnen Teile sind nicht als Einzelübungen gedacht, sondern als eine Kette, so wie sie in einem Mittelstandsprojekt auch zusammenhängt: Ein Benutzer entsteht, bekommt Gruppen und Lizenz, meldet sich an einem verwalteten Gerät an, kommt nur mit MFA und konformem Gerät an Microsoft 365 und wird beim Austritt sauber abgebaut.

Zu jedem Abschnitt gehören die Fehler, die mir beim Aufbau passiert sind, und wie ich sie gelöst habe. Die sind oft interessanter als die Konfiguration selbst.

---

## Inhalt

| Abschnitt | Thema | Stand |
|---|---|---|
| [00 – Bestandsaufnahme](00-assessment/) | Tenant-Prüfung mit Maester und Graph, vorher / nachher | geplant |
| [01 – Hybrid Identity](01-hybrid-identity/) | Lokales AD, Entra Connect / Cloud Sync, GPO → Intune | geplant |
| [02 – Windows-Geräte & Autopilot](02-autopilot/) | Entra Join + automatische Intune-Registrierung, Autopilot-Profil, Gruppenstruktur | Registrierung umgesetzt, Autopilot-Profil angelegt |
| [03 – Compliance & Conditional Access](03-compliance-ca/) | Compliance-Richtlinien Windows/macOS, CA mit MFA und konformem Gerät | Compliance umgesetzt, CA im Modus „Nur Bericht“ |
| [04 – Identity Lifecycle (JML)](04-jml/) | Joiner, Mover, Leaver mit Microsoft Graph PowerShell | umgesetzt, CSV-Massenbetrieb in Arbeit |
| [05 – Android Enterprise](05-android-enterprise/) | Dediziertes Gerät (Kiosk) auf Samsung Galaxy A16, Gerät mit Benutzer | Kiosk-Registrierung und Fernaktionen umgesetzt, Sperrmodus + Arm A offen |
| [06 – Okta](06-okta/) | Zwei Trial-Orgs: Gruppenregeln, delegierte Admin-Rollen, Session- und App-Policies, System Log, SAML-Föderation | umgesetzt mit Screenshots, JIT-Nachweis offen |

## Umgebung

| Komponente | Einsatz |
|---|---|
| Microsoft 365 Business Premium (Testmandant) | Lizenzierung, Entra ID P1, Intune |
| Microsoft Entra ID | Benutzer, Gruppen, Conditional Access |
| Microsoft Intune | Geräteregistrierung, Compliance, App-Bereitstellung, Android Enterprise |
| Windows 11 (VM auf dem MacBook, ARM) | Entra Join, automatische Intune-Registrierung |
| MacBook Pro (macOS) | über das Unternehmensportal in Intune registriert, Compliance-Richtlinie |
| Samsung Galaxy A16, Android 16 | Android Enterprise, dediziertes Gerät |
| Microsoft Graph PowerShell SDK, PowerShell 7 | Joiner / Mover / Leaver |
| Okta Workforce Identity (2 Trial-Orgs) | Föderation, Lifecycle, Policies |

## Wie die Teile zusammenhängen

```
                 ┌─► Gruppen ─► Lizenz, Apps, Richtlinien
Benutzer (JML) ──┤
  04             └─► Conditional Access ◄── Gerät konform? ◄── Intune Compliance
                        03                                        03
                         ▲
Windows (Entra Join) ────┤  02
Android Enterprise ──────┘  05
```

Intune bewertet das Gerät, Conditional Access entscheidet über den Zugriff, die Gruppen aus dem Lifecycle steuern, wer welche Richtlinie bekommt.

## Aufbau jedes Abschnitts

Alle Ordner folgen demselben Schema wie [04 – JML](04-jml/):

```
0X-abschnitt/
├── README.md     Ausgangslage, Umsetzung, Stolpersteine, nächste Stufe
├── images/       Screenshots und Fotos
├── scripts/      nur wo es Code gibt
└── docs/         nur wo es Zusatzdokumente gibt
```

## Namenskonventionen

| Objekt | Schema | Beispiel |
|---|---|---|
| Gruppen | `GRP-<Bereich>-<Zweck>` | `GRP-INTUNE-PILOT-DEVICES` |
| Autopilot-Profile | `AP_<OS>_<Zielgruppe>_<Modus>_<Stufe>` | `AP_WIN11_KMU_USERDRIVEN_BASELINE` |
| Gerätenamen (Autopilot) | `KMU-WIN-%RAND:5%` | `KMU-WIN-A7B2C` |
| Android-Registrierungsprofile | `CASE<Nr>-<Modus>-<Gerät>` | `CASE01-KIOSK-A16` |
| CA-Richtlinien | `CA<Nr>-<Wirkung>-<Zielgruppe>` | `CA01-MFA-AlleBenutzer` |

## Hinweis

Eigene Laborumgebung, keine Kundendaten, keine echten Personen. Alle Screenshots stammen aus meinen Testmandanten. Registrierungstoken, QR-Codes, Objekt-IDs und private Adressen sind geschwärzt.

Die Abschnitte 02, 03 und 05 entstanden 2025/26 in einem Microsoft-Testmandanten, der inzwischen geschlossen ist. Was dort nicht mehr dokumentiert werden konnte, steht in jedem Abschnitt unter „Nächste Stufe“ und wird in einem neuen Testmandanten nachgebaut.

---

**Alexander Frank** · Microsoft Modern Workplace & Identity · freiberuflich, remote DACH
SC-300 · MD-102 · Okta Certified Professional · Okta Certified Administrator · Android Enterprise Certified Expert
[LinkedIn](https://www.linkedin.com/in/alexander-frank-identity)
