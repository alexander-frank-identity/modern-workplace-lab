# 01 – Hybrid Identity (geplant)

> **Stand: geplant.** Dieser Abschnitt ist noch nicht gebaut.

## Worum es geht

Der typische Mittelständler ist nicht cloud-only. Es gibt einen Domänencontroller, Benutzer werden dort angelegt, Gruppenrichtlinien steuern die Clients, und Microsoft 365 kam später dazu. Jede Identity- und Intune-Arbeit in so einer Umgebung beginnt mit der Frage, welches System führend ist und wie synchronisiert wird.

## Geplanter Aufbau

| Schritt | Inhalt |
|---|---|
| 1 | Windows Server als VM, AD DS, DNS, DHCP, eigene Domäne |
| 2 | OU-Struktur und Testbenutzer mit gefüllten Attributen (Abteilung, Manager, Kostenstelle) |
| 3 | UPN-Suffix auf die verifizierte Domäne umstellen |
| 4 | Synchronisierung mit Entra Connect bzw. Cloud Sync, Filterung nach OU |
| 5 | Mindestens einen echten Sync-Fehler provozieren und beheben (z. B. doppelter UPN oder `proxyAddresses`-Konflikt) |
| 6 | Zwei, drei typische GPOs anlegen und mit Group Policy Analytics in Intune bewerten: was lässt sich 1:1 übernehmen, was nicht |

## Warum das für die anderen Abschnitte wichtig ist

- **Führendes System:** Änderungen an synchronisierten Attributen in der Cloud werden beim nächsten Sync überschrieben. Das ist der häufigste Grund, warum ein Graph-Skript beim Kunden „nicht wirkt“.
- **Leaver:** In einer hybriden Umgebung wird im AD deaktiviert, nicht in Entra. Sonst ist das Konto nach dem nächsten Sync wieder aktiv. Das betrifft die Skripte in [04 – JML](../04-jml/).
- **Okta:** Dasselbe AD soll später zusätzlich über den Okta AD Agent angebunden werden, siehe [06](../06-okta/).
