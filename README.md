
### How to export the cluster .kube/config file?

1- Login in AWS using the CLI first with your secret and access key

2- Run the below command to export the .kube/config file in your home directory

aws eks update-kubeconfig --name [cluster_name] --region [region]

Example: aws eks update-kubeconfig --name eks --region us-east-1

=======
# eks-ars-tgi
>>>>>>> 01bb7100f221fbf31092dc91bc943eb92d16e2f0
