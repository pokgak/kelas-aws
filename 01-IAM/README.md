# Kelas AWS: IAM

Goal: run an application that calls to an AWS service (S3)

## Running our application

Run the app and see what we get.

```
$ go run main.go
```

### Error: No valid providers in chain

- AWS SDK [default credentials provider chain](https://docs.aws.amazon.com/sdkref/latest/guide/standardized-credentials.html#credentialProviderChain)
- Default credential provider chain go SDK:
  1. Environment variables.
  1. Shared credentials file.
  1. If your application uses an ECS task definition or RunTask API operation, IAM role for tasks.
  1. If your application is running on an Amazon EC2 instance, IAM role for Amazon EC2.

## Create an IAM user

- use an IAM user to authenticate ourself
  
### Failed to list S3 buckets: AccessDenied

- AWS IAM default will deny all actions that is not exlicitly granted to the principal
- How to grant permission?
  - attach permission to the user directly (not scalable)
  - attach permission to an IAM group

### IAM Policy document structure

- IAM policies must have **actions, effect, and resource**.
- Each AWS service has its own set of actions
  * tip: google "\<service> iam actions" and select the "Actions, resources, and conditions for \<service>"

Example policy to allow listing all S3 buckets in the account:
```
{
    "Statement": [
        {
            "Action": "s3:ListAllMyBuckets",
            "Effect": "Allow",
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
```

## Managing user permission using groups

- add users to the group
- attach policy to the group
- all users in the group will inherit the group policy

### Authenticating using roles

Services should have their own identity instead of using IAM user. Lets create a role for the service and allow members from the `developers` group to assume the role.

- what's the difference between roles and users?
  * roles have [temporary credentials](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp.html)
- assuming role need two way permission
  1. grant permission to the group to assume the role
  1. add the users to the role trust relationship (assume role policy)
- how do we assume role locally?
  * configure the role profile inside local aws config file `~/.aws/credentials` or `~/.aws/config`
  ```
  [test-service]
  source_profile=default
  role_arn=arn:aws:iam::058264261389:role/test-service
  ```
  * set the `AWS_PROFILE=developer` env when running the application

## Running the application inside EC2

lets deploy our application to EC2 and run it from there.

- build the application binary (GOOS to build linux binary since I'm on Mac):
  ```
  $  GOOS=linux go build -o test-app-linux main.go
  ```
- push the binary to our EC2 and run our app:
  ```
  $ scp ./test-app-linux test-server:
  $ ssh test-server
  $ ls
  test-app-linux
  $ ./test-app-linux
  Failed to get caller identity: NoCredentialProviders: no valid providers in chain
  caused by: EnvAccessKeyNotFound: failed to find credentials in the environment.
  SharedCredsLoad: failed to load profile, .
  AssumeRoleUnauthorizedAccess: EC2 cannot assume the role test-service.  Please see documentation at https://docs.aws.amazon.com/IAM/latest/UserGuide/troubleshoot_iam-ec2.html#troubleshoot_iam-ec2_errors-info-doc.
  ```

### Error: EC2 cannot assume the role test-service

For EC2 to be able to assume our role, we need to add the EC2 service into our role trust relationship.

Add the following statement to test-service trust relationship:
```
Statement{
  {
      "Effect": "Allow",
      "Principal": {
          "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
  }
}
```

### Run our application again

```
$ ./test-app-linux
Caller Identity:
Account ID: 058264261389
User ARN: arn:aws:sts::058264261389:assumed-role/test-service/i-00cb71844a241e4af
User ID: AROAQ3EGSCMGZKW34J3QM:i-00cb71844a241e4af
--------------------
S3 Buckets:
         pokgak-test-bucket
         pokgak-test-bucket-2
```

## Summary

What we've done:

- create access key for IAM user
- use groups to manage user permissions
- create roles and allow users to assume
- use roles to manage our test-service permissions
- attach roles to EC2 instances using instance profile
- run application from EC2 instance
