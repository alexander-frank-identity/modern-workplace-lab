# JML-Lab — Microsoft Graph PowerShell Commands Cheatsheet

## 8 Befehle - Referenz zum Auswendiglernen (begleitend zum Lab)

**Stand:** August 2026  
**Autor:** Alexander Frank  
**Kontext:** Joiner · Mover · Leaver Automation mit Microsoft Graph  

---

## KAPITEL 1 — CONNECTION
### Connect-MgGraph
```powershell
Connect-MgGraph -Scopes "User.ReadWrite.All","Directory.ReadWrite.All","Group.ReadWrite.All"
```

**Was:** Verbindung zu Microsoft 365 / Entra ID herstellen  
**Wann:** Am Anfang jedes Scripts  
**Scopes (Minimum):**
- `User.ReadWrite.All` → Benutzer lesen & ändern
- `Directory.ReadWrite.All` → Verzeichnis ändern
- `Group.ReadWrite.All` → Gruppen ändern
- `Organization.Read.All` → Lizenzen prüfen (optional)

**Rückgabe:** Access Token (unsichtbar, wird gecacht)  
**Fehler-Lösungen:**
- "AADSTS65001" → Admin Consent nötig
- "Timeout" → `-UseDeviceAuthentication` verwenden
- "Not recognized" → Modul nicht installiert (`Install-Module Microsoft.Graph`)

**Alternativ:**
```powershell
Connect-MgGraph -UseDeviceAuthentication
```

---

## KAPITEL 2 — LESEN
### Get-MgUser
```powershell
# Alle Benutzer (Achtung: kann lange dauern)
Get-MgUser -All

# Top 5 mit bestimmten Feldern
Get-MgUser -Top 5 -Property DisplayName,UserPrincipalName,Id,AccountEnabled

# Nach Name suchen
Get-MgUser -Filter "displayName eq 'Daniel Schmidt'"

# Nach Email suchen (EMPFOHLEN — eindeutig!)
Get-MgUser -Filter "userPrincipalName eq 'daniel.schmidt@firma.de'"

# Mit Wildcard
Get-MgUser -Filter "startsWith(userPrincipalName, 'daniel')"

# Nach ID direkt
Get-MgUser -UserId $userId -Property DisplayName,Department,JobTitle
```

**Was:** Benutzer auslesen / suchen  
**Wann:** Vor jedem Update oder Löschen (Eindeutigkeit prüfen)  
**Properties (häufig):**
- `DisplayName` → Anzeigename
- `UserPrincipalName` → Email (eindeutig!)
- `Id` → Object ID (eindeutig!)
- `AccountEnabled` → true/false
- `Department` → Abteilung
- `JobTitle` → Jobbezeichnung
- `OfficeLocation` → Bürostandort

**Rückgabe:** Array von User-Objekten  
**Filter-Syntax:**
- `eq` = gleich
- `startsWith()` = beginnt mit
- `contains()` = enthält

**Best Practice:**
```powershell
# Eindeutigkeit IMMER mit UserPrincipalName/Id prüfen
$user = Get-MgUser -Filter "userPrincipalName eq '$email'"
if ($user.Count -ne 1) { Write-Error "Nicht eindeutig!" }
```

---

## KAPITEL 3 — ERSTELLEN (JOINER)
### New-MgUser
```powershell
$newUser = @{
    DisplayName           = "Max Mustermann"
    MailNickname          = "max.mustermann"
    UserPrincipalName     = "max.mustermann@firma.de"
    AccountEnabled        = $true
    PasswordProfile       = @{
        ForceChangePasswordNextSignIn = $true
        Password                      = "TempPassword123!@#"
    }
}

$createdUser = New-MgUser @newUser

# Prüfen
$createdUser | Select-Object DisplayName, UserPrincipalName, Id
```

**Was:** Neuen Benutzer anlegen  
**Wann:** Joiner-Prozess (HR stellt ein)  
**Pflicht-Parameter:**
- `DisplayName` → Sichtbarer Name
- `MailNickname` → Kurz-Alias (eindeutig!)
- `UserPrincipalName` → Email (eindeutig! Format: name@tenant.onmicrosoft.com)
- `PasswordProfile` → Passwort-Einstellungen

**Passwort-Regeln:**
- Mindestens 8 Zeichen
- Großbuchstaben + Kleinbuchstaben + Zahlen + Sonderzeichen
- `ForceChangePasswordNextSignIn = $true` → User muss bei erstem Login ändern

**Rückgabe:** User-Objekt mit neu generierter `Id`  
**Häufige Fehler:**
- "UserPrincipalName already exists" → Email-Adresse doppelt
- "Invalid MailNickname" → Sonderzeichen oder doppelt
- "Password does not meet requirements" → Passwort zu schwach

**Best Practice — mit Error Handling:**
```powershell
try {
    $user = New-MgUser @newUser
    Write-Host "User erstellt: $($user.Id)"
} catch {
    Write-Error "Fehler: $_"
}
```

---

## KAPITEL 4 — ÄNDERN (MOVER)
### Update-MgUser
```powershell
# Benutzer finden
$userId = (Get-MgUser -Filter "userPrincipalName eq 'max.mustermann@firma.de'").Id

# Attribute ändern
Update-MgUser -UserId $userId -BodyParameter @{
    Department     = "Marketing"
    JobTitle       = "Senior Manager"
    OfficeLocation = "Berlin"
}

# Prüfen
Get-MgUser -UserId $userId -Property DisplayName,Department,JobTitle,OfficeLocation
```

**Was:** Benutzer-Attribute ändern  
**Wann:** Mover-Prozess (Abteilungswechsel, Beförderung)  
**Häufige Felder:**
- `Department` → Abteilung
- `JobTitle` → Jobbezeichnung
- `OfficeLocation` → Bürostandort
- `Manager` → Vorgesetzter (User-ID nötig)
- `MobilePhone` → Handy
- `CompanyName` → Firma

**Wichtig:** `-BodyParameter` verwenden, nicht einzelne Parameter  
**Syntax:**
```powershell
Update-MgUser -UserId $userId -BodyParameter @{
    Field1 = "Wert1"
    Field2 = "Wert2"
}
```

**Rückgabe:** Nichts (Status: OK)  
**Fehler:**
- "Resource not found" → UserId falsch
- "Request_BadRequest" → Feldname existiert nicht

**Best Practice:**
```powershell
# Alle Änderungen sammeln, dann update
$updates = @{}
if ($newDepartment) { $updates.Department = $newDepartment }
if ($newJobTitle) { $updates.JobTitle = $newJobTitle }

Update-MgUser -UserId $userId -BodyParameter $updates
```

---

## KAPITEL 5 — GRUPPEN
### Get-MgGroup & New-MgGroupMember
```powershell
# Gruppen auflisten
Get-MgGroup -Top 10 | Select-Object DisplayName, GroupTypes, Id

# Bestimmte Gruppe finden
$groupId = (Get-MgGroup -Filter "displayName eq 'GRP-INTUNE-PILOT-USERS'").Id

# Benutzer zur Gruppe hinzufügen
$userId = (Get-MgUser -Filter "userPrincipalName eq 'max.mustermann@firma.de'").Id
New-MgGroupMember -GroupId $groupId -DirectoryObjectId $userId

# Gruppenmitglieder prüfen
Get-MgGroupMember -GroupId $groupId | Select-Object DisplayName, Id

# Benutzer aus Gruppe entfernen
Remove-MgGroupMember -GroupId $groupId -DirectoryObjectId $userId
```

**Was:** Gruppen verwalten & Mitgliedschaften  
**Wann:** Joiner (zu Gruppe hinzufügen), Mover (Gruppe wechseln), Leaver (aus Gruppe entfernen)

**Group Types:**
- `{}` (leer) → Sicherheitsgruppe (für Conditional Access)
- `{Unified}` → Microsoft 365 Gruppe (Teams/SharePoint)
- `{DynamicMembership}` → Dynamische Gruppe (Regeln)

**Befehle:**
- `Get-MgGroup` → Gruppen anzeigen
- `New-MgGroupMember` → User hinzufügen
- `Get-MgGroupMember` → Mitglieder prüfen
- `Remove-MgGroupMember` → User entfernen

**Häufige Fehler:**
- "One or more added object references already exist" → User schon Mitglied
- "Resource not found" → GroupId oder UserId falsch

**Best Practice — Bulk Add:**
```powershell
$userIds = @("id1", "id2", "id3")
foreach ($uid in $userIds) {
    New-MgGroupMember -GroupId $groupId -DirectoryObjectId $uid
}
```

---

## KAPITEL 6 — LIZENZEN
### Set-MgUserLicense
```powershell
# Verfügbare Lizenzen prüfen
Get-MgSubscribedSku | Select-Object SkuPartNumber, SkuId

# Lizenz zuweisen
$licenseAssignment = @{
    AddLicenses = @(
        @{
            SkuId = "6fd2c87f-b296-42f0-b197-1e91e994b900"  # ENTERPRISEPACK
        }
    )
    RemoveLicenses = @()
}

$userId = (Get-MgUser -Filter "userPrincipalName eq 'max.mustermann@firma.de'").Id
Set-MgUserLicense -UserId $userId -BodyParameter $licenseAssignment

# Lizenzen prüfen
Get-MgUser -UserId $userId -Property AssignedLicenses | Select-Object DisplayName, AssignedLicenses
```

**Was:** Microsoft 365 Lizenzen zuweisen  
**Wann:** Nach Joiner (User braucht sofort Lizenz)  
**Häufige SKUs:**
- `ENTERPRISEPACK` = Microsoft 365 E3 (Office, Teams, OneDrive)
- `ENTERPRISEPREMIUM` = Microsoft 365 E5 (alles + Security)
- `STANDARDPACK` = Microsoft 365 Business Standard
- `PROJECTPREMIUM` = Project Premium

**Lizenz-Struktur:**
```powershell
@{
    AddLicenses = @(
        @{ SkuId = "..." }
    )
    RemoveLicenses = @()
}
```

**AddLicenses:** Neue Lizenzen (Array, mehrere möglich)  
**RemoveLicenses:** Alte Lizenzen (zum Ersetzen)

**Häufige Fehler:**
- "License X does not correspond to valid company License" → SKU-ID falsch
- "Subscription not found" → Tenant hat Lizenz nicht

**Best Practice:**
```powershell
# SKU-ID speichern für spätere Verwendung
$e3SkuId = (Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -eq "ENTERPRISEPACK"}).SkuId
```

---

## KAPITEL 7 — DEAKTIVIEREN (LEAVER PART 1)
### Update-MgUser (AccountEnabled = false)
```powershell
# Benutzer finden
$userId = (Get-MgUser -Filter "userPrincipalName eq 'max.mustermann@firma.de'").Id

# Account deaktivieren (NICHT löschen!)
Update-MgUser -UserId $userId -BodyParameter @{AccountEnabled = $false}

# Prüfen
Get-MgUser -UserId $userId -Property DisplayName,AccountEnabled
```

**Was:** Benutzer-Konto deaktivieren (Leaver-Schritt 1)  
**Wann:** Mitarbeiter geht  
**Effekt:**
- ❌ User kann sich NICHT anmelden
- ✅ Daten bleiben 90 Tage erhalten
- ✅ Email kann an neuen Owner übergeben werden

**Unterschied zu Löschen:**
- **Deaktivieren** = reversibel, Daten bleiben
- **Löschen** = permanent nach 30 Tagen

**Best Practice — mit Logging:**
```powershell
$user = Get-MgUser -UserId $userId
Write-Host "Benutzer deaktiviert: $($user.DisplayName) - $($user.UserPrincipalName)"
# Log in CSV speichern für Audit
```

---

## KAPITEL 8 — LÖSCHEN (LEAVER PART 2)
### Remove-MgUser
```powershell
# Benutzer finden
$userId = (Get-MgUser -Filter "userPrincipalName eq 'max.mustermann@firma.de'").Id

# BENUTZER LÖSCHEN (nach 30 Tagen weg!)
Remove-MgUser -UserId $userId

# Prüfen — User sollte nicht mehr existieren
Get-MgUser -Filter "userPrincipalName eq 'max.mustermann@firma.de'"
# Keine Ausgabe = erfolgreich gelöscht
```

**Was:** Benutzer komplett aus Tenant löschen (Leaver-Schritt 2)  
**Wann:** Nach 90 Tagen Aufbewahrung (oder sofort, wenn nötig)  
**Wichtig:**
- ⚠️ **NICHT REVERSIBEL**
- Nach 30 Tagen: User ist komplett weg
- OneDrive wird nach 93 Tagen gelöscht
- Teams-Nachrichten -> Archiv

**Best Practice — Sicherheitsabfrage:**
```powershell
$confirm = Read-Host "Benutzer $email wirklich löschen? (ja/nein)"
if ($confirm -eq "ja") {
    Remove-MgUser -UserId $userId
    Write-Host "Benutzer gelöscht."
} else {
    Write-Host "Abgebrochen."
}
```

**Fehler:**
- Kein Output = Erfolg
- "Resource not found" → User existiert nicht (schon gelöscht?)

---

## KOMPLETTER WORKFLOW (JML)

### Joiner (Neuer Mitarbeiter)
```powershell
# 1. Benutzer anlegen (Kap 3)
$user = New-MgUser @{
    DisplayName = "Max Mustermann"
    MailNickname = "max.mustermann"
    UserPrincipalName = "max.mustermann@firma.de"
    AccountEnabled = $true
    PasswordProfile = @{
        ForceChangePasswordNextSignIn = $true
        Password = "TempPassword123!@#"
    }
}

# 2. Zu Gruppen hinzufügen (Kap 5)
$groupId = (Get-MgGroup -Filter "displayName eq 'GRP-INTUNE-PILOT-USERS'").Id
New-MgGroupMember -GroupId $groupId -DirectoryObjectId $user.Id

# 3. Lizenz zuweisen (Kap 6)
Set-MgUserLicense -UserId $user.Id -BodyParameter @{
    AddLicenses = @(@{SkuId = "..."})
    RemoveLicenses = @()
}

Write-Host "Joiner fertig: $($user.UserPrincipalName)"
```

### Mover (Abteilungswechsel)
```powershell
# 1. Benutzer finden (Kap 2)
$user = Get-MgUser -Filter "userPrincipalName eq 'max.mustermann@firma.de'"

# 2. Attribute updaten (Kap 4)
Update-MgUser -UserId $user.Id -BodyParameter @{
    Department = "Marketing"
    JobTitle = "Senior Manager"
}

# 3. Gruppen anpassen (optional, Kap 5)
Remove-MgGroupMember -GroupId $oldGroupId -DirectoryObjectId $user.Id
New-MgGroupMember -GroupId $newGroupId -DirectoryObjectId $user.Id

Write-Host "Mover fertig: $($user.DisplayName)"
```

### Leaver (Mitarbeiter geht)
```powershell
# 1. Benutzer finden (Kap 2)
$user = Get-MgUser -Filter "userPrincipalName eq 'max.mustermann@firma.de'"

# 2. Account deaktivieren (Kap 7)
Update-MgUser -UserId $user.Id -BodyParameter @{AccountEnabled = $false}
Write-Host "Account deaktiviert: 90 Tage Aufbewahrung"

# 3. Nach 90 Tagen: löschen (Kap 8)
Remove-MgUser -UserId $user.Id
Write-Host "Benutzer gelöscht"
```

---

## QUICK REFERENCE (Zum Auswendiglernen)

| Kapitel | Command | Aktion | Syntax |
|---------|---------|--------|--------|
| 1 | `Connect-MgGraph` | Verbindung | `-Scopes "User.ReadWrite.All",...` |
| 2 | `Get-MgUser` | Lesen | `-Filter "userPrincipalName eq '...'"`  |
| 3 | `New-MgUser` | Erstellen | `@{ DisplayName, MailNickname, UserPrincipalName, PasswordProfile }` |
| 4 | `Update-MgUser` | Ändern | `-BodyParameter @{ Department, JobTitle, ... }` |
| 5 | `New-MgGroupMember` | Gruppe | `-GroupId $id -DirectoryObjectId $userId` |
| 6 | `Set-MgUserLicense` | Lizenz | `-BodyParameter @{ AddLicenses, RemoveLicenses }` |
| 7 | `Update-MgUser` | Disable | `-BodyParameter @{AccountEnabled = $false}` |
| 8 | `Remove-MgUser` | Löschen | `-UserId $id` (⚠️ Nicht reversibel!) |

---

## FEHLERBEHANDLUNG (Standard)

```powershell
try {
    $result = Get-MgUser -Filter "userPrincipalName eq 'test@firma.de'"
    if ($null -eq $result) {
        Write-Error "Benutzer nicht gefunden"
    } else {
        Write-Host "Benutzer gefunden: $($result.DisplayName)"
    }
} catch {
    Write-Error "Fehler: $_"
    Write-Error $_.Exception.Message
}
```

**Ziel erreicht:** Du kennst alle 8 Commands und kannst JML-Automation mit Microsoft Graph durchführen.

Viel Erfolg beim Auswendiglernen und den ersten echten Projekten! 💪
