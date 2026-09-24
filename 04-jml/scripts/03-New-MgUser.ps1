# ==========================================================
# 03-New-MgUser.ps1
# Neuen Benutzer anlegen (JOINER)
# ==========================================================
#
# Onboarding-Schritt: HR stellt einen neuen Mitarbeiter ein.
# Wir legen den Benutzer mit Name, E-Mail und temporaerem
# Passwort an.

# Voraussetzung: Connect-MgGraph wurde ausgefuehrt.

# Parameter des neuen Benutzers als Hash-Table definieren.
$newUser = @{
    DisplayName       = "TestUser Kapitel3"                                 # Anzeigename (Teams, Outlook)
    MailNickname      = "testuser.kap3"                                     # Kurz-Alias, eindeutig im Tenant
    UserPrincipalName = "testuser.kap3@mdmcooperation111.onmicrosoft.com"   # E-Mail, EINDEUTIG
    AccountEnabled    = $true                                               # Konto sofort aktivieren
    PasswordProfile   = @{
        ForceChangePasswordNextSignIn = $true                              # User setzt Passwort beim ersten Login selbst
        Password                      = "TempPassword123!@#"               # DEMO-Wert -- niemals so in Produktion!
    }
}

# In Produktion NIE das Passwort hardcoden. Besser zufaellig erzeugen, z.B.:
#   $tempPw = -join ((33..126) | Get-Random -Count 16 | ForEach-Object {[char]$_})
# und dem User ueber einen sicheren Kanal / Invitation-Link uebergeben.

# Benutzer erstellen.
$createdUser = New-MgUser @newUser

# Ergebnis pruefen: neu erzeugte Id, E-Mail, Name.
$createdUser | Select-Object DisplayName, UserPrincipalName, Id, AccountEnabled

# ----------------------------------------------------------
# Haeufige Fehler:
# - "UserPrincipalName already exists"  -> E-Mail doppelt
# - "Invalid MailNickname"              -> Sonderzeichen oder doppelt
# - "Password does not meet requirements" -> Passwort zu schwach
# ----------------------------------------------------------
