# ==========================================================
# 01-Connect-MgGraph.ps1
# Verbindung zu Microsoft Graph herstellen (Basis)
# ==========================================================
#
# Erster Schritt jedes JML-Skripts. Ohne Verbindung laeuft
# kein einziger Graph-Befehl. Wir fordern per Least Privilege
# nur die Scopes an, die der JML-Prozess wirklich braucht.

# Modul einmalig installieren (nur beim ersten Mal noetig):
# Install-Module Microsoft.Graph -Scope CurrentUser

# Verbindung herstellen und Rechte anfordern.
# Ein Browserfenster oeffnet sich fuer den Login.
Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All","Directory.ReadWrite.All"

# Kontrolle: mit welchem Konto, welchem Tenant, welchen Scopes
# bin ich verbunden? Immer der erste Diagnose-Befehl.
Get-MgContext

# Am Ende der Session sauber trennen:
# Disconnect-MgGraph

# ----------------------------------------------------------
# Hinweis (Stolperstein aus der Praxis):
# - Auf macOS lief -UseDeviceAuthentication in einen 120s-Timeout.
#   Loesung: normaler interaktiver Browser-Login (wie oben).
# - Bei "Insufficient privileges": zuerst Get-MgContext pruefen,
#   ob man ueberhaupt mit dem richtigen Konto verbunden ist.
# ----------------------------------------------------------
