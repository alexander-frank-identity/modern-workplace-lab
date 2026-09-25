# ==========================================================
# 04-Update-MgUser.ps1
# Benutzer-Attribute aendern (MOVER)
# ==========================================================
#
# Mover-Schritt: ein Mitarbeiter wechselt Abteilung, wird
# befoerdert oder wechselt den Standort. Wir aendern nur die
# betroffenen Felder, nicht den ganzen Benutzer.

# Benutzer finden und seine Id merken.
$userId = (Get-MgUser -Filter "userPrincipalName eq 'testuser.kap3@mdmcooperation111.onmicrosoft.com'").Id

# Zu aendernde Felder sammeln.
$updateParams = @{
    Department     = "Marketing"
    JobTitle       = "Junior IAM Tester"
    OfficeLocation = "Berlin"
}

# Update durchfuehren. Aenderungen laufen ueber -BodyParameter.
# Es werden nur die genannten Felder ueberschrieben (PATCH).
Update-MgUser -UserId $userId -BodyParameter $updateParams

# Kontrolle: sind die neuen Werte gesetzt?
Get-MgUser -UserId $userId -Property DisplayName,Department,JobTitle,OfficeLocation |
    Select-Object DisplayName,Department,JobTitle,OfficeLocation

# ----------------------------------------------------------
# Haeufige Fehler:
# - "Resource not found"    -> UserId falsch
# - "Request_BadRequest"    -> Feldname existiert nicht (z.B. Departement)
# ----------------------------------------------------------
