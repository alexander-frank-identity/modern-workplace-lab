# 00 – Bestandsaufnahme (geplant)

> **Stand: geplant.** Dieser Abschnitt ist noch nicht gebaut.

## Worum es geht

Bevor in einem gewachsenen Mandanten irgendetwas geändert wird, wird der Ist-Zustand erhoben. In fast jedem Mittelstandsmandanten tauchen dieselben Punkte auf: zu viele dauerhafte Global Admins, Konten ohne MFA, veraltete Authentifizierung wegen eines Druckers oder einer Branchensoftware, aktive Konten ehemaliger Mitarbeiter, kein Notfallzugang.

## Geplanter Aufbau

1. Testmandant bewusst in einen typischen „gewachsenen“ Zustand versetzen (zusätzliche Global Admins, Konten ohne MFA, inaktive Konten, kein Notfallkonto).
2. Prüfung nur lesend, mit den Rollen Global Reader und Security Reader.
3. [Maester](https://maester.dev) gegen den Mandanten laufen lassen, dazu eigene Graph-Abfragen: Mitglieder privilegierter Rollen, registrierte MFA-Methoden, letzte Anmeldung, Export aller CA-Richtlinien als JSON.
4. Befunde nach Risiko einstufen und den Abschnitten 03 und 04 zuordnen.
5. Nach der Umsetzung dieselbe Prüfung noch einmal: vorher / nachher.

## Prüfpunkte

| Prüfpunkt | Warum es zählt | Behoben in |
|---|---|---|
| MFA-Abdeckung | Ein Konto ohne MFA reicht für eine Übernahme | [03](../03-compliance-ca/) |
| Veraltete Authentifizierung | Umgeht MFA vollständig | [03](../03-compliance-ca/) |
| Notfallkonten | Einziger Rückweg, wenn eine Richtlinie aussperrt | [03](../03-compliance-ca/) |
| Dauerhafte Global Admins | Jedes Admin-Konto ist ein Generalschlüssel | 00 |
| Inaktive Konten | Zugang ohne Besitzer, oft mit bezahlter Lizenz | [04](../04-jml/) |
| Gerätekonformität als Zugriffsbedingung | Zugriff nur von verwalteten Geräten | [03](../03-compliance-ca/), [05](../05-android-enterprise/) |
