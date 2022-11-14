# Consul EKS

This project contains the basics for deploying Consul on an AWS EKS cluster using Terraform and `consul-k8s`.

## Requirements

- [`aws`](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
  - [AWS credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- [`consul-k8s`](https://releases.hashicorp.com/consul-k8s/)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/)
- [`terraform`](https://releases.hashicorp.com/terraform/)

## Note

**The following steps create AWS resources that will incur costs in your AWS account.**

## Usage

1. Initialize terraform

   ```shell
   terraform init
   ```


1. Deploy the EKS cluster via Terraform. This step also generates the `values.yaml` file that is used to install Consul.

   ```shell
   terraform apply -var name=$USER
   ```


1. Configure `kubectl` to target your newly minted EKS cluster.

   ```shell
   $(terraform output -json | jq -r '.update_kubeconfig_cmd.value')
   ```


1. View the nodes in your EKS cluster.

   ```shell
   kubectl get nodes
   ```


1. Deploy Consul via `consul-k8s`.

   ```shell
   consul-k8s install -namespace default -config-file values.yaml
   ```


1. View the Consul deployment in K8s.

   ```shell
   kubectl get pods
   ```

1. Export environment variables to interact with Consul

   ```shell
   export CONSUL_HTTP_ADDR=https://localhost:8501
   export CONSUL_HTTP_TOKEN=$(terraform output -json | jq -r '.consul_http_token.value')
   export CONSUL_HTTP_SSL_VERIFY=false
   ```

1. Interact with your Consul deployment.
   The easiest way to do this is to use `kubectl port-forward` to route traffic directly from `localhost` to the pods running in your EKS cluster.
   
   1. Open a separate terminal (make sure you reconfigure your AWS credentials for that terminal).
      Forward traffic from your local machine to the Consul server running on EKS.

      ```shell
      kubectl port-forward services/consul-server 8501
      ```

   1. In the original shell, use `curl` or `consul` to list the services catalog

      ```shell
      curl -ks -H "x-consul-token: $CONSUL_HTTP_TOKEN" https://localhost:8501/v1/catalog/services | jq .
      consul catalog services
      ```

1. You can do the same port forwarding magic for the Consul UI.

   1. Port-forward the Consul UI

      ```shell
      kubectl port-forward services/consul-ui 8501:443
      ```

   1. Use a web browser to view the Consul UI at [https://localhost:8501](https://localhost:8501)

   1. Use the `CONSUL_HTTP_TOKEN` to log in

      ```shell
      echo $CONSUL_HTTP_TOKEN
      ```

## Clean up

Uninstall Consul

```shell
consul-k8s uninstall -name consul -namespace default -wipe-data -auto-approve
```

Remove the EKS cluster

```shell
terraform destroy -var name=$USER
```
