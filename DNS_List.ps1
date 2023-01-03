<# From Mike Barron


check all dns servers for a specific name
use to verify dns/ds replication
#>


$name="xxx"
$dnsservers=(Resolve-DnsName drl.local -Type NS).Server |sort

 
$name


foreach ($dnsserver in $dnsservers) {
    "{0,-30}" -f $dnsserver |Write-Host -NoNewline
    if (Test-Connection $dnsserver -delay 1 -Count 1 -Quiet) {
        "" + (resolve-dnsname -EA 0 -name $name -Server $dnsserver -quick).IPAddress
    } else {
        "NC"
    }

}

 