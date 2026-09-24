# ==========================================================
# 08-Remove-MgUser.ps1
# Benutzer endgueltig loeschen (LEAVER, Teil 2)
# ==========================================================
#
# Abschluss des Leaver-Prozesses nach Ablauf der
# Aufbewahrungsfrist: der Benutzer wird geloescht.

# Benutzer finden (der deaktivierte aus Kapitel 7).
$userId = (Get-MgUser -Filter "userPrincipalName eq 'testuser.kap3@mdmcooperation111.onmicrosoft.com'").Id

# In Produktion IMMER eine Sicherheitsabfrage vorschalten:
# $confirm = Read-Host "Benutzer wirklich loeschen? (ja/nein)"
# if ($confirm -ne "ja") { Write-Host "Abgebrochen."; return }

# Benutzer loeschen. ACHTUNG: nach 30 Tagen endgueltig weg.
Remove-MgUser -UserId $userId

# Kontrolle: keine Ausgabe = erfolgreich geloescht.
Get-MgUser -Filter "userPrincipalName eq 'testuser.kap3@mdmcooperation111.onmicrosoft.com'" |
    Select-Object DisplayName

# ----------------------------------------------------------
# Geloeschte Objekte liegen 30 Tage im Papierkorb
# (Get-MgDirectoryDeletedItem), danach sind sie unwiderruflich weg.
# ----------------------------------------------------------
