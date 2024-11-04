# Base Infrastructure

This repository contains Terraform scripts for provisioning the foundational infrastructure used in projects developed at Stamper Labs.
These scripts provide a consistent and automated way to set up and manage essential resources.

## Jenkins EC2 instance

To configure Jenkins to run over HTTPS on an EC2 instance, follow these steps:

#### Start Jenkins with HTTPS

1. SSH into the Jenkins EC2 Instance:

```bash
ssh -i /path/to/your/key.pem ec2-user@your-ec2-instance-ip
```

2. Edit the Jenkins Service: Open the service configuration for Jenkins:

```bash
sudo systemctl edit jenkins
```

3. Add Service Configuration: In the `override.conf` file, add the following configuration and save your changes:

```conf
[Service]
Environment="JENKINS_PORT=-1"
Environment="JENKINS_HTTPS_PORT=8443"
Environment="JENKINS_HTTPS_KEYSTORE=/var/lib/jenkins/.ssl/server.jks"
Environment="JENKINS_HTTPS_KEYSTORE_PASSWORD=password"
```

4. Restart Jenkins: Apply the changes by reloading the systemd manager configuration and restarting Jenkins:

```bash
sudo systemctl daemon-reload
sudo systemctl restart jenkins
```

5. Check Jenkins is up and running

```bash
sudo systemctl status jenkins
```
