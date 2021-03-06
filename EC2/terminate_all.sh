# WARNING !!! this script terminates ALL your EC2 instances

# get the instance ids first
ids=$(aws ec2 describe-instances --filters="Name=instance-state-name,Values=pending,running,stopping,stopped" --query "Reservations[].Instances[].[InstanceId]" --output text | tr '\n' ' ')

# terminate them all
aws ec2 terminate-instances --instance-ids $ids

# root volumes are automatically deleted as well
