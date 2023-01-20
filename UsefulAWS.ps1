# CLI export AWS detail
aws ec2 describe-instances --region eu-west-1 --instance-ids i-xxx > C:\TEMP\SQLFxxx.json

# Enabling termination protection for everything
$InstanceList = (Get-EC2Instance -Region eu-west-1 | Where-Object {$_.instances.state.name -eq "running"}).Instances
foreach ($f in $InstanceList){
	Edit-EC2InstanceAttribute -Region eu-west-1 -InstanceId $f.instanceid  -DisableApiTermination $true
}

