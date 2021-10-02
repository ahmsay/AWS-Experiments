# without --query, it will bring all the information about all instances that --filter applies

aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].{InstanceId:InstanceId,Placement:Placement,CustomNameForArchitecture:Architecture}"
