# ==========================================================
# 07-Disable-MgUser.ps1
# Benutzer deaktivieren (LEAVER, Teil 1)
# ==========================================================
#
# Erster Offboarding-Schritt: der Mitarbeiter verlaesst die
# Firma. Wir deaktivieren das Konto -- Anmeldung gesperrt,
# Daten bleiben erhalten (Aufbewahrungsfenster).

# Benutzer finden.
$userId = (Get-MgUser -Filter "userPrincipalName eq 'testuser.kap3@mdmcooperation111.onmicrosoft.com'").Id

# Konto deaktivieren. AccountEnabled = $false -> keine Anmeldung mehr.
Update-MgUser -UserId $userId -BodyParameter @{ AccountEnabled = $false }

# Kontrolle: ist AccountEnabled jetzt False?
Get-MgUser -UserId $userId -Property DisplayName,AccountEnabled |
    Select-Object DisplayName,AccountEnabled

# ----------------------------------------------------------
# Stolperstein aus der Praxis:
#   Update-MgUser -UserId $userId -AccountEnabled $false   # FALSCH
#     -> "A positional parameter cannot be found ..."
#   Update-MgUser -UserId $userId -BodyParameter @{AccountEnabled=$false}  # RICHTIG
#
# Deaktivieren vs. Loeschen:
#   Deaktivieren = reversibel, Daten bleiben.
#   Loeschen (Kap. 8) = endgueltig nach 30 Tagen.
# ----------------------------------------------------------
