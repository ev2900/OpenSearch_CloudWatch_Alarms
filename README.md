# OpenSearch Dashboard Nginx Proxy

<img width="275" alt="map-user" src="https://img.shields.io/badge/cloudformation template deployments-290-blue">

Amazon OpenSearch services can deploy a domain in a private VPC, subnet(s). Deploying OpenSearch in a private subnet blocks traffic to the OpenSearch dashboard via. the public internet.

A Nginx proxy can be configured on an Ec2 in a public subnet (in the same VPC as the private subnet) to proxy traffic to the OpenSearch dashboard. **Enabling you to have a OpenSearch domain deployed in a private subnet with a OpenSearch dashboard accessible from the public internet**

Follow the instructions below

1. Run the CloudFormation stack below

[![Launch CloudFormation Stack](https://sharkech-public.s3.amazonaws.com/misc-public/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=os-nginx&templateURL=https://sharkech-public.s3.amazonaws.com/misc-public/opensearch_nginx.yaml)

The resources created by the CloudFormation stack are documented in the architecture below


<img alt="opensearch_nginx_yaml" src="https://github.com/ev2900/OpenSearch_Dashboard_Nginx_Proxy/blob/main/Read_Me_Architecture/ReadMe_Architecture.png">

2. Install NGINX on Ec2

SSH into the Ec2 that was created by the cloudformation and run the following commands on the terminal.

*Note* you will need to update the ec2 security group to allow incoming traffic from your IP address before you can SSH into the Ec2 instance.

```sudo apt update```

```sudo apt install nginx```

## Create SSL self-signed certificate

The OpenSearch dashboard URL uses https. Consequently we need to have SSL enabled in our Nginx proxy. We will generate a self-signed certificate to use as part of our SSL configuration.

Run the following commands on the terminal of the Ec2 created by the cloudformation

```cd /etc/nginx/```

```sudo openssl genrsa -des3 -out /etc/nginx/private.key 2048```

```sudo openssl rsa -in private.key -out public.key```

```sudo openssl req -new -key public.key -out certificate_signing_request.csr```

```sudo openssl x509 -req -days 365 -in certificate_signing_request.csr -signkey public.key -out self_signed_certificate.crt```

3. Configure Nginx

Run the following commands on the terminal of the Ec2 created by the cloudformation

```cd sites-enabled```

```sudo vim default```

Delete all of the content in the default file. Update the 3 <os_domain_url> placeholders in the [ngnix_config](https://github.com/ev2900/OpenSearch_Dashboard_Nginx_Proxy/blob/main/ngnix_config) file. Copy/past the updated [ngnix_config](https://github.com/ev2900/OpenSearch_Dashboard_Nginx_Proxy/blob/main/ngnix_config) into the default file. Save and close the default file.

4. Restart / start Nginx

Restart the Nginx service to have the changes made to the configuration take effect. Run the following commands on the terminal of the Ec2 created by the cloudformation

```sudo service nginx restart```

If you need to stop or start Nginx issue the commands below as needed

```sudo service nginx start```

```sudo service nginx stop```

5. Access OpenSearch dashboard via. public internet

To access the OpenSearch dashboard ensure that the ec2 security group will accept incoming traffic for your source. In a web browser navigate to https://<ec2's-public-ip>/_dashboards

Your web browser may flag the website as insecure. This is because we are using a self-signed SSL certificate instead of a SSL certificate signed by a trusted authority. Procced to the website. You will see the OpenSearch dashboard log in page.

<img width="550" alt="log_in" src="https://user-images.githubusercontent.com/5414004/182025931-a0acec68-452f-441c-98f2-a091cfb04091.png">

## Future Improvement(s)
1. Containerize Nginx server
2. High availability Nginx server (ie. two servers behind an elastic load balancer)
