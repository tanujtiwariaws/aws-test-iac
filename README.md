# Ensure to update the VPC, subnet IDs, and other configurations before testing the deployment.
# For the demo, I used variables for the VPC, subnet, AMI, and other settings. However, in the production setup, I will switch to using data blocks for more dynamic configurations.
# Created Code build to trigger om pudh and store in ECR 
# used Pipeline and s3 bucket and pipeline and eventribdge rule
# for pipeline have to add buildspec to trigger build and appspec for code pipeline.
# created EKS cluster for deployment