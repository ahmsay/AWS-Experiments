eksctl create cluster --config-file=cluster.yaml

#curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy.json
#aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json

eksctl create iamserviceaccount \
  --cluster=test-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name "AmazonEKSLoadBalancerControllerRole" \
  --attach-policy-arn=arn:aws:iam::041804556452:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve

curl -Lo cert-manager.yaml https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml
# change 10250 ports to another port
k apply --validate=false -f cert-manager.yaml

curl -Lo v2_4_4_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.4/v2_4_4_full.yaml
sed -i.bak -e '480,488d' ./v2_4_4_full.yaml
sed -i.bak -e 's|your-cluster-name|test-cluster|' ./v2_4_4_full.yaml
# add vpc id and region code
kubectl apply -f v2_4_4_full.yaml

curl -Lo v2_4_4_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.4/v2_4_4_ingclass.yaml
kubectl apply -f v2_4_4_ingclass.yaml
