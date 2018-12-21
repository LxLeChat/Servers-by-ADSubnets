# Servers by ADSubnets

## Summary

Regroupe les serveurs par SUBNETs AD

Source pour la fonction checksubnet
http://www.gi-architects.co.uk/2016/02/powershell-check-if-ip-or-subnet-matchesfits/

Il se peut que à la fin du script, le tableau servers contienne encore des entrées.
Si c'est le cas, c'est que les machines ne correspondent à aucun subnet

Le tableau servers est vidée au fur et à mesure.
Un serveur qui appartient à un subnet est retiré du tableau, donc plus on avance dans les subnets, plus le parcour des serveur est rapide.

Le tableau array contient le resultat
On peut chercher dans le resultat comme ça : $array | where Servers -Contains 'ServerA'

Les tableaux servers et array sont dans le scope global, du coup accessible en fin de script depuis votre console.

La recherche ad des serveurs se fait par Get-ADComputer... Le filtre est basic "operatingsystem -like '*server*'"