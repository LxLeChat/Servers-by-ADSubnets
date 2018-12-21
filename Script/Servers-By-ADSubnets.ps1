## Regroupe les serveurs par SUBNETs

## source pour la fonction checksubnet
## http://www.gi-architects.co.uk/2016/02/powershell-check-if-ip-or-subnet-matchesfits/

## Il se peut que à la fin du script, le tableau servers contienne encore des entrées.
## Si c'est le cas, c'est que les machines ne correspondent à aucun subnet

## Le tableau servers est vidée au fur et à mesure.
## Un serveur qui appartient à un subnet est retiré du tableau, donc plus on avance dans les subnets, plus le parcour des serveur est rapide.

## Le tableau array contient le resultat
## On peut chercher dans le resultat comme ça : $array | where Servers -Contains 'ServerA'

## Dot source des fonctions checksubnet
. .\checkSubnet.ps1

[System.Collections.ArrayList]$Global:Servers = Get-ADComputer -Filter "operatingsystem -like '*server*'" -Properties ipv4address | Where-Object ipv4address -ne $null | Select-Object name,ipv4address 
$subnets = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().sites.Subnets

[System.Collections.ArrayList]$Global:array = @()

$subnets | ForEach-Object {
    
    "Current Subnet: {0} - {1}" -f $PSItem.Location,$PSItem.Name

    $properties = [Ordered]@{
        Location = $PSItem.Location
        subnetAddress = $PSItem.Name
        Servers = [System.Collections.ArrayList]@()
    }

    ## Tableau qui contiendra les serveurs matchant le subnet et à supprimer du tableau servers
    [System.Collections.ArrayList]$EntriesToDelete = @()
    For($i=0;$i -lt $Global:Servers.count;$i++){
        $SubnetCheck = checkSubnet $Global:Servers[$i].IPv4Address $properties.subnetAddress
        If ( $SubnetCheck.Condition -eq $True ){
            $properties.Servers.add($Global:Servers[$i].Name) | Out-Null
            $EntriesToDelete.Add($Global:Servers[$i]) | Out-Null
        }
    }

    ## on supprimmer les entrees du tableau servers
    If ( $EntriesToDelete.count -gt 0) { $EntriesToDelete | ForEach-Object{$Global:Servers.Remove($_) | Out-Null}; Remove-Variable EntriesToDelete } 
   
    $Global:array.add($(new-object -TypeName PSObject -Property $properties)) | out-null
}