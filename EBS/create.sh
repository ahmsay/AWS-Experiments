# --size is GB
aws ec2 create-volume --volume-type gp2 --size 10 --availability-zone <your_az>
# for attaching and mounting, see AWS docs
# volume and the instance must be in the same AZ
