# ==========================================================
# 02-Get-MgUser.ps1
# Benutzer auslesen und suchen (Lesen)
# ==========================================================
#
# Grundlage fuer jeden weiteren Schritt: bevor man einen User
# aendert oder loescht, liest man ihn erst aus und prueft die
# Eindeutigkeit.

# Voraussetzung: Connect-MgGraph wurde ausgefuehrt.
Get-MgContext

# Die ersten 5 Benutzer mit ausgewaehlten Feldern.
# -Top begrenzt die Ergebnismenge (wichtig bei grossen Tenants).
# -Property waehlt nur die Felder, die wir wirklich brauchen.
Get-MgUser -Top 5 -Property DisplayName,UserPrincipalName,Id,AccountEnabled

# Nach E-Mail (UserPrincipalName) suchen -- EMPFOHLEN, weil eindeutig.
Get-MgUser -Filter "userPrincipalName eq 'testuser.kap3@mdmcooperation111.onmicrosoft.com'"

# Teiltreffer per startsWith, falls nur ein Teil bekannt ist.
Get-MgUser -Filter "startsWith(userPrincipalName, 'testuser')"

# ----------------------------------------------------------
# Merke: immer nach UserPrincipalName oder Id filtern,
# nie nach DisplayName -- Namen koennen doppelt sein, die E-Mail nie.
#
# Stolperstein aus der Praxis:
#   Get-MgUser -Filter "displayName Dan"      # FALSCH -> Syntaxfehler
#   Get-MgUser -Filter "displayName eq 'Dan'" # RICHTIG (Operator eq)
# ----------------------------------------------------------
