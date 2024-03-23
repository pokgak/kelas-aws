# Basics

## Principals

- users, roles, other AWS services

### Users

- login to console using password
- OR authenticate using access key ID and secret access key on CLI

### Default and custom profile

- `default` profile will be used by default if no profiles specified
- we can specify the profile by either using the `--profile` CLI flag or `AWS_PROFILE` environment variable when running a command
- calling AWS cli with no default profile will return error:
  ```
  Unable to locate credentials. You can configure credentials by running "aws configure".
  ```

### Groups

- grant permissions to a group of users
- why we need roles? (https://stackoverflow.com/q/63386524)
  - security: temporary credentials
  - users + group is account specific: less hassle managing users in multiple accounts with diff access keys

### Roles

- IAM user > assume role > IAM role > do stuffs
- best practice is to grant the permission to roles and then grant the users permission to assume that role i.e. role-based access control (RBAC)
  - temporary credentials instead of static: when assuming roles, a temporary ACCESS_KEY and S

#### Trust Relationship

- role assumption need to be allowed from both sides
- TODO: diagram user A assuming role

## Conditions

- additional constraint to limit the granted permission
- can be used for implementing ABAC

## Attribute-based Access Control (ABAC)

- more scalable way of doing permissions
- grants permissions based on resource tags
- example: allow delete resource to only roles with tag `isAdmin: true`

## Resource-based policies

- some services e.g. S3 allow using resource-based policy
- policy is attached to the resource directly instead of granted to any principal (user/role)

## Assuming roles from your application

The AWS SDK will try to load AWS credentials based on the [credentials provider chain](https://docs.aws.amazon.com/sdkref/latest/guide/standardized-credentials.html#credentialProviderChain).

1. Access keys
1. Federated identity (OIDC) e.g. IRSA on EKS
1. Container
1. IMDS credential provider e.g. EC2 instance profile

Credentials loading precedence ([ref](https://docs.aws.amazon.com/sdkref/latest/guide/settings-reference.html#precedenceOfSettings)).

## Troubleshooting permission issues

- READ THE ERROR MESSAGE
- it usually tells you which principal is missing permision to do which actions

```
# without any policies attached
$ aws eks list-clusters --profile pokgak-user

An error occurred (AccessDeniedException) when calling the ListClusters operation: User: arn:aws:iam::058264261389:user/pokgak is not authorized to perform: eks:ListClusters on resource: arn:aws:eks:ap-southeast-1:058264261389:cluster/*
```
