aws ec2 run-instances --image-id ami-07df274a488ca9195 --count 1 --instance-type t2.micro --key-name <your_ec2_key_pair> --security-group-ids <your_security_group> --user-data file://user_data.sh

# go to instance's public ip to see the result
