# Building a high available Anycast service using AWS global accelerator

This is a terraform recipe for spinning up an AWS Global Accelerator instance. 

Also make sure to check the accompanying blog post here:
https://medium.com/p/450fc8c4fd1e/

This accelerator will have two listeners, one for UDP53 and one for TCP80. As part of the Terraform recipe, we also spin up vpc's in 4 regions, each with two EC2 instances.
This repo comes with a DNS and Webserver (GoLang) that will be installed on the EC2 instances (see `/scripts/` )


To get started:
Make sure have your AWS credentials ready.

Also make sure the ssh key path is set correctly, currently hardcoded as `~/.ssh/id_rsa.pub` in `vpc/010-ssh-key.tf` 

To start the terraform work, simply type:
```
terraform init 
terraform plan 
terraform apply 
```

The terraform output will show the Global Accelerator IPs. 
Example output:
```
Output:
<SNIP>
GlobalAccelerator = [
  [
    [
      {
        "ip_addresses" = [
          "13.248.138.197",
          "76.223.8.146",
        ]
        "ip_family" = "IPv4"
      },
    ],
  ],
]
<SNIP>
```


To test the web server (make sure the replace the IP with the IP of your GlobalAccelerator):
```
for i in {1..30}; do curl -s -q  13.248.138.197 ;done |sort | uniq -c | sort -nr
  18 hostname: i-0e32d5b1a3f76cc05.us-west-2c
  12 hostname: i-006b93ffb1844c92f.us-west-2c
```

To test the DNS server (make sure the replace the IP with the IP of your GlobalAccelerator):
```
for i in {1..20}; do dig @13.248.138.197 ID.SERVER txt ch +short ; done | sort | uniq -c | sort -nr
  10 "i-0e32d5b1a3f76cc05.us-west-2c"
  10 "i-006b93ffb1844c92f.us-west-2c"
``` 
