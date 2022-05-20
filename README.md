# nomad-jobs-for-jenkins-nginx-and-redis

This template helps you to understand, how we can deploy jobs in nomad.

For introduction and quickstart you can try these blogs:

1. https://blog.knoldus.com/what-is-hashicorp-nomad/ 
2. https://blog.knoldus.com/how-to-run-the-binary-job-in-hashicrop-nomad/ 


### Pre-requisite

1. Install nomad, you can follow this blog 1.
2. Also you need to install consul for health check probe and service mesh. You can follow official documentation for that.


## TlDR;

This template uses the docker driver as well as java driver of nomad to run the jobs. Please go through the jobs files first.

### Applying jobs in nomad

1. To apply a job on hashicorp run below commad

    nomad job run nginx/nginx.hcl

2. Check status

    nomad job status <job-name>

3. Stop a job

    nomad job stop <job-name>
