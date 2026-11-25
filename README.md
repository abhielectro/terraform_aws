Grant user to access EKS

1. Check your AWS identity
$ aws sts get-caller-identity

2. Check EKS authentication mode
$ aws eks describe-cluster \
  --name eks-dev-mcp \
  --region us-east-1 \
  --query "cluster.accessConfig"

3. Create an EKS access entry for your IAM user or role
$ aws eks create-access-entry \
  --cluster-name eks-dev-mcp \
  --region us-east-1 \
  --principal-arn arn:aws:iam::xxxxxxxxxxxx:user/admin \
  --type STANDARD

4. Grant cluster administrator permissions
$ aws eks associate-access-policy \
  --cluster-name eks-dev-mcp \
  --region us-east-1 \
  --principal-arn arn:aws:iam::xxxxxxxxxxxx:user/admin \
  --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy \
  --access-scope type=cluster

4.1 For ReadOnly Access
$ aws eks associate-access-policy \
  --cluster-name eks-dev-mcp \
  --principal-arn <YOUR-IAM-USER-OR-ROLE-ARN> \
  --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy \
  --access-scope type=cluster \
  --region us-east-1

4.2 For administrator-level visibility in the Kubernetes resources through the console
arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy

5. Verify access entry
$ aws eks list-access-entries \
  --cluster-name eks-dev-mcp \
  --region us-east-1
