# launchs an ec2 instance

# ami: amazon linux 2 64-bit
# by default, it gives an 8 gb ebs gp2 volume
# subnet is random if you don't specify
aws ec2 run-instances --image-id ami-07df274a488ca9195 --count 1 --instance-type t2.micro --key-name <your_ec2_key_pair> --security-group-ids <your_security_group>
