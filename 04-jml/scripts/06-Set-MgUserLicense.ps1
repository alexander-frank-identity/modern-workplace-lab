# ==========================================================
# 06-Set-MgUserLicense.ps1
# Microsoft-365-Lizenz zuweisen (JOINER)
# ==========================================================
#
# Ohne Lizenz kann sich ein User zwar anmelden, aber nichts
# nutzen (kein Teams, kein OneDrive, kein Outlook). Direkt
# nach dem Anlegen wird deshalb die Lizenz zugewiesen.

# Benutzer finden.
$userId = (Get-MgUser -Filter "userPrincipalName eq 'testuser.kap3@mdmcooperation111.onmicrosoft.com'").Id

# Verfuegbare Lizenzen (SKUs) im Tenant auflisten.
Get-MgSubscribedSku | Select-Object SkuPartNumber, SkuId

# SKU-Id fuer ENTERPRISEPACK (E3) ermitteln.
$skuId = (Get-MgSubscribedSku | Where-Object { $_.SkuPartNumber -eq "ENTERPRISEPACK" }).SkuId

# Lizenz-Zuweisung als Body vorbereiten.
$licenseAssignment = @{
    AddLicenses    = @( @{ SkuId = $skuId } )
    RemoveLicenses = @()
}

# Lizenz zuweisen.
Set-MgUserLicense -UserId $userId -BodyParameter $licenseAssignment

# Kontrolle: hat der User jetzt eine Lizenz?
Get-MgUser -UserId $userId -Property DisplayName,AssignedLicenses |
    Select-Object DisplayName, AssignedLicenses

# ----------------------------------------------------------
# Haeufige SKUs:
#   ENTERPRISEPACK      Microsoft 365 E3
#   ENTERPRISEPREMIUM   Microsoft 365 E5
#   STANDARDPACK        Business Standard
#
# Stolperstein aus der Praxis:
#   "License ... does not correspond to a valid company License"
#   -> die SKU-Id gehoert nicht zum Tenant, oder der (Dev-)Tenant
#      hat gar keine Lizenzen. Die Struktur oben bleibt identisch.
# ----------------------------------------------------------
