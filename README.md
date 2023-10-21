# Deployment 5.1 Documentation 

## Purpose:
This deployment is a continuation of deployment 5. To view deployment 5 click [here!](https://github.com/auzhangLABS/c4_deployment-5). The purpose of this deployment is to utilize Jenkins agents. Why Jenkins Agents: Using Jenkins agents would add an additional layer of security ensuring the Jenkins master remains uncompromised from potentials. Additionally, this allows Jenkins to distribute the loads effectively to their agents, reducing build times and making it scalable. 

## Steps:
We utilized Terraform to create our AWS cloud infrastructure. To see the terraform file, click [here!](https://github.com/auzhangLABS/c4_deployment5.1/blob/temp/main.tf) Here is a diagram of what it created.
![image](https://github.com/auzhangLABS/c4_deployment5.1/assets/138344000/a4ef18e5-bdb1-40c1-a6eb-a245378e3223)
 <br>
We also created a new key pair in AWS and attached the private key to all my instances. This would be an easier way to SSH into the instance without fumbling with multiple keys. <br>

#### Installing Package on Instances. 
In one of the instances, we installed Jenkins and other necessary packages using user data. See user data script [here](https://github.com/auzhangLABS/c4_deployment5.1/blob/temp/deployjenkins.sh)!
In the other instances, we installed the necessary packages in addition to default-jre (Default Java Runtime Environment) using different user data. See other user data scripts [here!](https://github.com/auzhangLABS/c4_deployment5.1/blob/temp/deploypython.sh). Default-jre would allow you to run Java applications on those instances.


#### Creating a Jenkins Agent on Instance
To create a Jenkins agent, we had to go into the instance with Jenkins. From Jenkins:
1. Click on Build Executor Status, -> Click New Node
2. Type your agent name select Permanent Agent and Create
3. Enter your remote root directory type. For this example, I used: /home/ubuntu/agent1
4. Enter your name for the label (this is an identifier to allow Jenkins to determine what node to execute in the Jenkinsfile)
5. For usage, select "Only build jobs with label expression matching this mode."
6. For Launch Method, select "Launch agent via SSH."
   - Enter Host IP (other instance IP). Add your Jenkins credentials with an SSH username and a private key. Enter your username as ubuntu and add your private key directly (including the Start RSA Private Key and End RSA Private Key)
7. For the host key verification strategy, click on the non-verifying verification strategy.
8. And save. You can check if it was successful by clicking on the node and checking the log. A successful connection will return something like this: <br>
![image](https://github.com/auzhangLABS/c4_deployment5.1/assets/138344000/d086a1d2-e2ab-4306-940f-b7e5df4d0005)
9. To create another agent, repeat those steps and make sure you use the same label. If you use another label, make sure you specify it in the Jenkins file like this:
![image](https://github.com/auzhangLABS/c4_deployment5.1/assets/138344000/36053c50-9e8a-40c7-9276-92be0c73c271)


## Deploying the application
To deploy, we created a Jenkins multibranch pipeline and ran the Jenkins file. After the pipeline is successful, you will have the banking application running on two different instances. 

![image](https://github.com/auzhangLABS/c4_deployment5.1/assets/138344000/e4981d3f-7958-404e-925b-c23623e6a3c4)

## System Design Diagram
![image](https://github.com/auzhangLABS/c4_deployment5.1/blob/main/d5.1v2.drawio.png) <br>
To see the full diagram, click [here!](https://github.com/auzhangLABS/c4_deployment5.1/blob/temp/d5.1full.drawio.png)

## Optimization
I would optimize this deployment by putting the other application instance in a different availability zone instead of the same availability zone. This makes the application highly available as well as ensuring redundancy. Additionally, we can utilize Cloudfront (Content Delivery Network), which can accelerate the delivery of our web application.



