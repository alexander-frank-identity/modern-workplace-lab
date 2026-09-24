# ==========================================================
# 05-Add-MgGroupMember.ps1
# Benutzer zu einer Gruppe hinzufuegen
# ==========================================================
#
# Gruppen steuern Zugriffe und Conditional-Access-Policies.
# Beim Onboarding wird der User den richtigen Gruppen zugeordnet.

# Verfuegbare Gruppen ansehen (zur Orientierung).
Get-MgGroup -Top 10 | Select-Object DisplayName, GroupTypes, Id

# Zielgruppe finden.
$groupId = (Get-MgGroup -Filter "displayName eq 'GRP-INTUNE-PILOT-USERS'").Id

# Benutzer finden.
$userId = (Get-MgUser -Filter "userPrincipalName eq 'testuser.kap3@mdmcooperation111.onmicrosoft.com'").Id

# Benutzer zur Gruppe hinzufuegen.
New-MgGroupMember -GroupId $groupId -DirectoryObjectId $userId

# Kontrolle: ist der User jetzt Mitglied?
Get-MgGroupMember -GroupId $groupId | Select-Object DisplayName, Id

# Benutzer wieder entfernen (z.B. beim Mover/Leaver):
# Remove-MgGroupMember -GroupId $groupId -DirectoryObjectId $userId

# ----------------------------------------------------------
# Gruppentypen:
#   {}                  Sicherheitsgruppe (Conditional Access)
#   {Unified}           Microsoft-365-Gruppe (Teams/SharePoint)
#   {DynamicMembership} regelbasiert -- NICHT manuell befuellen
#
# "One or more added object references already exist" heisst nur:
# der User ist bereits Mitglied -- kein echter Fehler.
# ----------------------------------------------------------
