# launchs an ec2 instance

# ami: amazon linux 2 64-bit
# security group: my custom security group that allows http and ssh connections
# by default, it gives an 8 gb ebs gp2 volume
# subnet is random if you don't specify
aws ec2 run-instances --image-id ami-07df274a488ca9195 --count 1 --instance-type t2.micro --key-name EC2_Key_Pair --security-group-ids sg-026af7f32e3e8f321
