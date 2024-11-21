# gcp-tf

## GCP

Terraform code within aws directory, accomplishes following task:

    1. Build a network layer with VPC, 2 subnets (public and private), routes and firwalls. Subnets are in asia-south1 region
    2. Create 2 compute engine instances, one public another private
    3. create a GCS bucket
    4. Setup VPC Peering between our network and Google's network
    5. Create MySQL instance

the code is broken into individual modules with parent main.tf at root level calling each module in sequence.

Modules are as follows:
1. vpc : Creates VPC in the region provided in the provider config in parent main.tf. Once VPC is createdd, VPC Peering with GCP network is also done.

2. subnets: Creates subnets in the above created VPC

3. firewall: Creates firewalls allowing ICMP protocol, ingress on port 3000, and ssh port.

4. routes: Creates route for internal routing and public routing using Internet Gateway.

5. compute_instance: Creates compute instances in given subnets

6. buckets: Creates a GCS bucket

7. sql: Creates a SQL instance and a db.


** Assumptions Made for above task: **

1. Application Load Balancer is present on the cloud supporting HTTP traffic.

2. Bootstraping of the private compute instance is done manually using public instance. In bootstrapping, pip along with required packages like flask and everything is installed.

3. LoadBalancer IP is hardcoded in teh frontend code.

4. Once db is created, db schema and user management is done manually.

5. GCS bucket will be used as backend which must already be present on cloud, just provide relevant details.

6. A serviceAccount with appropriate permission is present and its json is accessible.

7. Tf version will be between 1.0.0 and 2.0.0 and aws provider scope will be harshicorp/gcp.

8. Provider's project, zone, region and credentials are provided as environemnt variables using TF_VAR_


## To run the terraform:

1. Setup following environemnt variables using TF_VAR_:
    gcp_project
    gcp_region
    gcp_zone
    credentials

2. Provide backend's GCS bucket name and prefix in tfvars

3. Create tfvars, giving required inputs

4. Run terraform init to initialize.

5. Run terraform plan.

6. Run terraform init


As given in the [repo](https://github.com/ansh-lehri/user-register-app.git), api is written using Flask and web using html and script.

To SetUp the frontend, backend and the db, perform following steps:

### Frontend:

1. Add LoadBalancer (already created) IP in the index.html file to call APIs.

2. Upload the file as object in the bucket created above and provide public access.

3. Now open the object public URL on **HTTP** (not HTTPS) as our API server will run on HTTP.


### DB:

1. Create a user and password from GCP console using MySQL Studio.

2. Create a table in the db and create a schema.

### Backend:

1. ssh into the public server from your local and then ssh into the private instance created above.

2. Bootstrap the server, installing pip, git.

3. Either copy paste files in api folder of the linked repo or git clone the repo on the server.

4. Run ```pip install -r requirements.txt --no-cache-dir``` to install packages like Flask, gunicorn etc.

5. Set following enviornment variables:
    DB_HOST: IP of MySQL instance
    DB_USER
    DB_PASSWORD
    DB_NAME

6. Run following command: ```gunicorn -w 2 -b 0.0.0.0:3000 app:app --daemon```. This runs the server as daemon process and exposes the server on port 3000.

### Attaching instance to the LB:

1. Once the server is setup, then attach the instance to the LB created.

2. Create self-managed instance group.
3. Create a health check for port 3000.
4. Attach the instance group as Backend.

Once this is done, your service is now accessible.

To access already setup endpoint use the [link](http://storage.googleapis.com/atlys-bucket-101/index.html)