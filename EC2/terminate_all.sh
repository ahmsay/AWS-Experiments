# WARNING !!! this script terminates ALL your EC2 instances

# get the instance ids first
ids=$(aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId]" --output text | tr '\n' ' ')

# terminate them all
aws ec2 terminate-instances --instance-ids $ids

# attached volumes are deleted as well
