# EKS Infrastructure with Terraform

A comprehensive Terraform project for deploying Amazon Elastic Kubernetes Service (EKS) with complete networking infrastructure, including VPC, subnets, NAT gateways, and node groups. This project follows AWS best practices for production-ready Kubernetes clusters.

## 🚀 Overview

This Terraform project provisions a complete EKS infrastructure including:
- **EKS Cluster** - Managed Kubernetes control plane
- **Node Groups** - Auto-scaling worker nodes
- **VPC & Networking** - Custom VPC with public and private subnets
- **NAT Gateways** - Internet access for private subnets
- **Security Groups** - Network security configurations
- **Elastic IPs** - Static IP addresses for NAT gateways
- **Route Tables** - Network routing configurations

## 📁 Project Structure

```
eks-ars-tgi/
├── provider.tf                    # AWS provider configuration
├── vpc.tf                        # VPC resource definitions
├── subnets.tf                    # Public and private subnets
├── internet-gateway.tf           # Internet gateway configuration
├── nat-gateways.tf              # NAT gateways for private subnets
├── eips.tf                      # Elastic IP addresses
├── routing-tables.tf            # Route table definitions
├── route-table-association.tf   # Route table associations
├── eks.tf                       # EKS cluster configuration
├── eks-node-groups.tf          # EKS worker node groups
└── README.md                   # Project documentation
```

## 📋 Prerequisites

### Required Tools
- **Terraform**: Version 1.0+ (recommended 1.5+)
- **AWS CLI**: Version 2.x configured with appropriate credentials
- **kubectl**: Kubernetes command-line tool
- **AWS Account**: With appropriate IAM permissions

### Required AWS Permissions
Your AWS user/role needs the following permissions:
- `AmazonEKSClusterPolicy`
- `AmazonEKSWorkerNodePolicy`
- `AmazonEKS_CNI_Policy`
- `AmazonEC2ContainerRegistryReadOnly`
- VPC and EC2 management permissions

### Installation

**Install Terraform:**
```bash
# macOS (using Homebrew)
brew install terraform

# Linux (using package manager)
sudo apt-get update && sudo apt-get install terraform

# Verify installation
terraform version
```

**Install AWS CLI:**
```bash
# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

**Install kubectl:**
```bash
# macOS
brew install kubectl

# Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

## 🛠️ Quick Start

### 1. Clone and Configure
```bash
git clone https://github.com/Royce237/eks-ars-tgi.git
cd eks-ars-tgi
```

### 2. Configure AWS Credentials
```bash
# Configure AWS CLI
aws configure
# Enter your AWS Access Key ID, Secret Access Key, Region, and Output format

# Or export environment variables
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### 3. Initialize Terraform
```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan deployment
terraform plan
```

### 4. Deploy Infrastructure
```bash
# Apply configuration
terraform apply

# Confirm with 'yes' when prompted
```

### 5. Configure kubectl
```bash
# Update kubeconfig for the new cluster
aws eks update-kubeconfig --name eks --region us-east-1

# Verify cluster access
kubectl get nodes
kubectl get pods --all-namespaces
```

## 🏗️ Infrastructure Components

### VPC Configuration
- **CIDR Block**: Configurable (default: 10.0.0.0/16)
- **Availability Zones**: Multi-AZ deployment for high availability
- **DNS Support**: Enabled for service discovery
- **DNS Hostnames**: Enabled for internal communication

### Subnet Architecture
```
├── Public Subnets (Internet-facing)
│   ├── Public Subnet 1 (AZ-1): 10.0.1.0/24
│   └── Public Subnet 2 (AZ-2): 10.0.2.0/24
└── Private Subnets (Internal)
    ├── Private Subnet 1 (AZ-1): 10.0.3.0/24
    └── Private Subnet 2 (AZ-2): 10.0.4.0/24
```

### EKS Cluster Features
- **Managed Control Plane**: AWS-managed Kubernetes API server
- **High Availability**: Control plane across multiple AZs
- **Security Groups**: Automatic security group management
- **IAM Integration**: AWS IAM for authentication and authorization
- **Logging**: CloudWatch logging integration
- **Networking**: VPC CNI for pod networking

### Node Groups Configuration
- **Auto Scaling**: Automatic scaling based on demand
- **Instance Types**: Configurable EC2 instance types
- **AMI**: Amazon EKS-optimized AMI
- **Launch Templates**: Advanced configuration options
- **Spot Instances**: Optional spot instance support

## ⚙️ Configuration Customization

### Variable Customization
Create a `terraform.tfvars` file to customize your deployment:

```hcl
# terraform.tfvars
cluster_name = "my-eks-cluster"
region = "us-west-2"
vpc_cidr = "10.0.0.0/16"
node_group_instance_types = ["t3.medium", "t3.large"]
node_group_scaling = {
  desired = 3
  max     = 5
  min     = 1
}
```

### Environment-Specific Configurations

**Development Environment:**
```hcl
# dev.tfvars
cluster_name = "eks-dev"
node_group_instance_types = ["t3.small"]
node_group_scaling = {
  desired = 2
  max     = 3
  min     = 1
}
```

**Production Environment:**
```hcl
# prod.tfvars
cluster_name = "eks-prod"
node_group_instance_types = ["m5.large", "m5.xlarge"]
node_group_scaling = {
  desired = 5
  max     = 10
  min     = 3
}
```

Apply with specific configuration:
```bash
terraform apply -var-file="prod.tfvars"
```

## 🔒 Security Best Practices

### Cluster Security
- **Private API Endpoint**: Option to make API server private
- **Network Policies**: Kubernetes network policies support
- **Encryption**: EKS secrets encryption at rest
- **IAM Roles**: Least privilege IAM roles for nodes
- **Security Groups**: Restrictive security group rules

### Node Security
- **IMDSv2**: Instance Metadata Service v2 enforced
- **SSM Access**: Systems Manager for secure access
- **Patch Management**: Automated patching with managed node groups
- **Container Runtime**: Containerd security features

### Network Security
```hcl
# Example security group rule
resource "aws_security_group_rule" "cluster_ingress_workstation" {
  cidr_blocks       = ["YOUR_IP/32"]
  description       = "Allow workstation to communicate with cluster"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster.id
  to_port           = 443
  type              = "ingress"
}
```

## 🚀 Post-Deployment Setup

### Essential Add-ons
```bash
# Install AWS Load Balancer Controller
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

# Install Cluster Autoscaler
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml

# Install Metrics Server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### Monitoring Setup
```bash
# Install Prometheus and Grafana (using Helm)
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack
```

### Ingress Controller
```bash
# Install NGINX Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/aws/deploy.yaml
```

## 📊 Monitoring and Observability

### CloudWatch Integration
```bash
# Enable CloudWatch Container Insights
aws eks update-cluster-config \
  --name eks \
  --logging '{"enable":["api","audit","authenticator","controllerManager","scheduler"]}'
```

### Cluster Monitoring
```bash
# Check cluster status
kubectl get nodes -o wide
kubectl top nodes
kubectl get pods --all-namespaces

# View cluster info
kubectl cluster-info
kubectl get componentstatuses
```

### Cost Monitoring
```bash
# Install AWS Cost and Usage Report integration
kubectl apply -f https://raw.githubusercontent.com/aws/aws-cost-anomaly-detection/main/kubernetes/deployment.yaml
```

## 🔄 Scaling Operations

### Manual Scaling
```bash
# Scale node group manually
aws eks update-nodegroup-config \
  --cluster-name eks \
  --nodegroup-name main-nodes \
  --scaling-config minSize=2,maxSize=8,desiredSize=4
```

### Auto Scaling Configuration
```hcl
# Cluster Autoscaler configuration
resource "kubernetes_deployment" "cluster_autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
  }
  # Configuration details...
}
```

### Horizontal Pod Autoscaler
```yaml
# hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: app-deployment
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
```

## 🧪 Testing and Validation

### Infrastructure Testing
```bash
# Terraform validation
terraform fmt
terraform validate
terraform plan

# Infrastructure testing with Terratest (Go)
go test -v terraform_aws_eks_test.go
```

### Cluster Testing
```bash
# Deploy test application
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Test connectivity
kubectl get services
curl http://LOAD_BALANCER_IP

# Clean up test resources
kubectl delete deployment nginx
kubectl delete service nginx
```

### Load Testing
```bash
# Install and run load testing
kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/debug/load-generator.yaml
```

## 🔧 Troubleshooting

### Common Issues

**Cluster Creation Fails:**
```bash
# Check IAM permissions
aws sts get-caller-identity
aws iam get-role --role-name eks-cluster-service-role

# Verify VPC configuration
terraform show | grep vpc
```

**Node Groups Not Joining:**
```bash
# Check node group status
aws eks describe-nodegroup --cluster-name eks --nodegroup-name main-nodes

# Check worker node logs
kubectl logs -n kube-system -l k8s-app=aws-node
```

**kubectl Connection Issues:**
```bash
# Update kubeconfig
aws eks update-kubeconfig --name eks --region us-east-1

# Verify cluster endpoint
aws eks describe-cluster --name eks --query cluster.endpoint
```

**Networking Issues:**
```bash
# Check DNS resolution
kubectl run -it --rm debug --image=busybox --restart=Never -- nslookup kubernetes

# Test pod-to-pod connectivity
kubectl exec -it pod-name -- ping another-pod-ip
```

### Debug Commands
```bash
# Describe cluster
aws eks describe-cluster --name eks

# List available node groups
aws eks list-nodegroups --cluster-name eks

# Check cluster logging
aws logs describe-log-groups --log-group-name-prefix /aws/eks/eks

# Terraform debugging
export TF_LOG=DEBUG
terraform apply
```

## 🔄 Maintenance and Updates

### Cluster Updates
```bash
# Update cluster version
aws eks update-cluster-version --name eks --kubernetes-version 1.28

# Update node groups
aws eks update-nodegroup-version --cluster-name eks --nodegroup-name main-nodes
```

### Terraform State Management
```bash
# Backup state file
cp terraform.tfstate terraform.tfstate.backup

# Import existing resources
terraform import aws_eks_cluster.main eks

# State file operations
terraform state list
terraform state show aws_eks_cluster.main
```

### Backup and Recovery
```bash
# Backup cluster configuration
kubectl get all --all-namespaces -o yaml > cluster-backup.yaml

# ETCD backup (for self-managed clusters)
kubectl create secret generic etcd-backup --from-file=backup.db
```

## 💰 Cost Optimization

### Instance Optimization
- Use Spot Instances for non-critical workloads
- Right-size instances based on actual usage
- Implement cluster autoscaling
- Use Reserved Instances for predictable workloads

### Resource Management
```bash
# Set resource requests and limits
kubectl apply -f - <<EOF
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limit-range
spec:
  limits:
  - default:
      memory: "512Mi"
      cpu: "200m"
    defaultRequest:
      memory: "256Mi"
      cpu: "100m"
    type: Container
EOF
```

## 🚀 Deployment Strategies

### Blue-Green Deployment
```bash
# Create new node group
terraform apply -var="node_group_name=green"

# Migrate workloads
kubectl drain node-blue --ignore-daemonsets
kubectl apply -f app-deployment-green.yaml

# Clean up old node group
terraform destroy -target=aws_eks_node_group.blue
```

### Canary Deployment
```yaml
# canary-deployment.yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: app-rollout
spec:
  replicas: 10
  strategy:
    canary:
      steps:
      - setWeight: 10
      - pause: {duration: 1m}
      - setWeight: 50
      - pause: {duration: 1m}
```

## 🤝 Contributing

### Development Guidelines
1. **Test Changes**: Always test in development environment first
2. **State Management**: Use remote state backend for team collaboration
3. **Code Review**: Submit pull requests for all changes
4. **Documentation**: Update documentation for infrastructure changes
5. **Security**: Follow AWS security best practices

### Code Standards
- Use consistent resource naming conventions
- Add appropriate tags to all resources
- Include variable descriptions and validation
- Use data sources instead of hardcoded values
- Implement proper error handling

## 📚 Additional Resources

- **AWS EKS Documentation**: [https://docs.aws.amazon.com/eks/](https://docs.aws.amazon.com/eks/)
- **Terraform AWS Provider**: [https://registry.terraform.io/providers/hashicorp/aws/latest](https://registry.terraform.io/providers/hashicorp/aws/latest)
- **Kubernetes Documentation**: [https://kubernetes.io/docs/](https://kubernetes.io/docs/)
- **AWS EKS Best Practices**: [https://aws.github.io/aws-eks-best-practices/](https://aws.github.io/aws-eks-best-practices/)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏆 Maintainer

**Royce237** - Cloud Engineer and DevOps Specialist

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/Royce237/eks-ars-tgi/issues)
- **AWS Support**: Use AWS Support for infrastructure-related issues
- **Community**: Join the AWS and Kubernetes community forums

---

**Building scalable Kubernetes infrastructure on ☁️ AWS with Terraform automation**
