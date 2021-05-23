# congnito_apps

## Using Cognito service
1. User access the AWS resource - login form of application running behind the ALB. 
2. User is prompted to present identity with google credentials
3. User will then present the recieved token to Cognito service
4. Identity pool from Congnito service will send the AWS temporary credentials to access AWS resources

![system diagram](https://github.com/egirdhar/congnito_apps/blob/main/SystemArch.png)

## Source code
In the code, the *main.tf* file 
- the default profile which has security credential of AWS account on my machine. 
- Within the congnito service, user pool, domain and app client is created first
- the identity pool is created for authorisation to provide the access to authenticated users only 

In the code, the *roles.tf* file 
- there are two roles - ```aws_resource_access``` and ```deny_everything``` for authenticated and unauthenticated users respectively. 
- there are policy documents to mention the allow/deny of resources

In the code, the *variables.tf* file 
- there are two input parameters required - ```google_provider_client_id``` and ```google_provider_client_secret``` 

## to be done further 
- Complete project needs to be linked to above architecture where  ALB, its target group and SG, VPC and subnets with application running on port 80
