# WARNING !!! this script stops ALL your running EC2 instances

# get the instance ids first
ids=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].[InstanceId]" --output text | tr '\n' ' ')

# stop them all
aws ec2 stop-instances --instance-ids $ids
