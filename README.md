# CloudResume-Backend
AWS CLOUD RESUME CHALLENGE

The Cloud Resume Challenge is a multiple-step resume project which helps build and demonstrate skills fundamental to pursuing a career as an AWS Cloud Engineer

These are the steps that are part of the challenge:

1.  Certification
2.  HTML
3.  CSS
4.  Static Website
5.  HTTPS
6.  DNS
7.  Javascript
8.  Database
9.  API
10. Python
11. Infrastructure as Code
12. Source Control
13. CI/CD (Back end)
14. CI/CD (Front end)

How I achieved the goal:

-As I am not a web developer but do have some basic HTML kowledge, I was able to get a HTML template with CSS to create my Resume.
-Created S3 bucket to secure the webiste files.  
-Initidated Dynamo DB to store the visitor count.  
-Created a Lambda funtion using Python to iterate visitor count and attached permissions to access DynamoDB.  

-Integrated Lambda funtion with API gateway for Website JS to POST request via RESTful API  

-Initiated Cloudfront Distributiona and attached origin as S3 Bucket  

-Created a Hosted Zone in Rooute 53 and created a Type A record  

-Bought a Domain Name via third party, changed DNS NS as per Route53 NS  

-Requested TLS certificate for HTTPS via AWS Certificate Manager and attached to Cloudfront Distribution  

-Created Terraform modules and resources to manage Infrastructure as Code  

-Pushed the code to Github Repo  

-Created CICD pipepline using GitHub Actions for Frontend and Backend