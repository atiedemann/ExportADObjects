<#
    Author:         Arne Tiedemann
    Date:           2018-11-21
    Description:    This script export all user, group and contact objects
                    to an xml file with Export-CliXML

#>

#######################################################################
# Variables
#######################################################################
$ExportPath = "$($env:PUBLIC)\Documents"

#######################################################################
# Script
#######################################################################
Import-Module -Name ActiveDirectory

foreach($Domain in (Get-ADForest).Domains) {
        $D = Get-ADDomain -Identity $Domain
        $Server = $D.PDCEmulator
        $NetBIOSName = $D.NetBIOSName

        # Export User objects
        Get-ADUser -Filter * -Properties * -Server $Server -SearchBase $D.DistinguishedName |
            Export-Clixml -Path ('{0}\{1}_User.xml' -f $ExportPath, $NetBIOSName)

        # Export group objects
        Get-ADGroup -Filter *  -Properties * -Server $Server -SearchBase $D.DistinguishedName |
            Export-Clixml -Path ('{0}\{1}_Group.xml' -f $ExportPath, $NetBIOSName)

        # Export contact objects
        Get-ADObject -Filter {(ObjectClass -eq 'Contact' )} -Properties * -Server $Server -SearchBase $D.DistinguishedName |
            Export-Clixml -Path ('{0}\{1}_Contacts.xml' -f $ExportPath, $NetBIOSName)
}

