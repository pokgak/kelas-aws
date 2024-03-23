package main

import (
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/service/sts"
)

func main() {
	// Create a new AWS session
	sess, err := session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
		Config: aws.Config{
			Region:                        aws.String("ap-southeast-1"),
			CredentialsChainVerboseErrors: aws.Bool(true),
		},
	})
	if err != nil {
		fmt.Println("Failed to create AWS session:", err)
		os.Exit(1)
	}

	// Create a new STS service client
	sts := sts.New(sess)
	// Call the GetCallerIdentity API to get the identity of the caller
	result, err := sts.GetCallerIdentity(nil)
	if err != nil {
		fmt.Println("Failed to get caller identity:", err)
		os.Exit(1)
	}

	// Print the caller identity information
	fmt.Println("Caller Identity:")
	fmt.Println("Account ID:", *result.Account)
	fmt.Println("User ARN:", *result.Arn)
	fmt.Println("User ID:", *result.UserId)

	// Create a new S3 service client
	s3 := s3.New(sess)
	// Call the ListBuckets API to get a list of all S3 buckets
	listResult, err := s3.ListBuckets(nil)
	if err != nil {
		fmt.Println("Failed to list S3 buckets:", err)
		os.Exit(1)
	}

	fmt.Println("--------------------")

	// Print the names of all S3 buckets
	if len(listResult.Buckets) == 0 {
		fmt.Println("No buckets found")
	} else {
		fmt.Println("S3 Buckets:")
		for _, bucket := range listResult.Buckets {
			fmt.Println("\t", *bucket.Name)
		}
	}
}
