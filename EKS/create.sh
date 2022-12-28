cluster_name=
aws_account_id=
argo_cd_password=

# create policy (needed only once per aws user)
#curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy.json
#aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json

# create cluster
eksctl create cluster --config-file=cluster.yaml

# install argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl patch svc argocd-server -n argocd -p '{"metadata": {"annotations": {"service.beta.kubernetes.io/aws-load-balancer-type": "external"}}}'
kubectl patch svc argocd-server -n argocd -p '{"metadata": {"annotations": {"service.beta.kubernetes.io/aws-load-balancer-nlb-target-type": "ip"}}}'
kubectl patch svc argocd-server -n argocd -p '{"metadata": {"annotations": {"service.beta.kubernetes.io/aws-load-balancer-scheme": "internet-facing"}}}'

new_argo_cd_password=$(python3 -c "import bcrypt; print(bcrypt.hashpw(b'$argo_cd_password', bcrypt.gensalt()).decode())")
kubectl -n argocd patch secret argocd-secret -p '{"stringData": {"admin.password": "'$(echo $new_argo_cd_password)'","admin.passwordMtime": "'$(date +%FT%T%Z)'"}}'
kubectl delete secret argocd-initial-admin-secret -n argocd

# install alb controller
eksctl create iamserviceaccount --cluster=$cluster_name --namespace=kube-system --name=aws-load-balancer-controller --role-name "AmazonEKSLoadBalancerControllerRole" --attach-policy-arn=arn:aws:iam::$aws_account_id:policy/AWSLoadBalancerControllerIAMPolicy --approve
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"
kubectl create -f ALBController.yaml # wait until it's ready
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'