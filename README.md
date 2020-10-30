# ec2-steamStreamer
terraform and powershell code to automate the creation of a windows ec2 instance running steam

The utlimate goal here is partly to sketch this up with providers and similar instance types for Azure and GCP as well, and see if any one works better than the others, but mostly to play with terraform.

Testing with the Monkey Island games.  On a manually built version of this thing, Secret of Monkey Island audio was somewhat choppy, but not bad and video was fine.  Escape from MI wouldn't even start streaming, it just hung, probably because of a failed DirectX install.  Tales of MI streamed, but was so choppy it was unplayable.  I suspect this is a limitation of my home internet speeds (about 125-ish down and 100-ish up), but it's worth trying it on different instance types before doing anything drastic and soul crushing, like installing Windows 10 on my laptop.

### TODO:

- The powershell script is WIP.  One annoying thing is the need to convert back and forth between newlines and newlines with carriage returns, otherwise the userdata gets passed as a single line. unix2dos and dos2unix tools help somehwat, but it's still incredibly annoying.
- nvidia driver installs, but default display driver doesn't get disabled.  Don't think vb-cable is working either, as there's no sound card listed in device manager. Windows audio service is getting configured for autostart though.
- ZeroTier vpn client should be installing correctly now, but joining the network is still a manual process.  Need to somehow pass the network id as a param all the way to the userdata and modify the powershell script to read it.  Probably using environment variables.
- Ditching security group tf code.  Not really a good way to do it securely.  Just build it manually and pass the id as a parameter.
- terrform can wait for and pass the (probably encrypted) admin password back as a base64 encoded.  It'd be nice to grab the public ip and admin password and plunk them into an xfreerdp script so I don't have to go through the copy and paste madness with my private key in the console to get the admin password.  Might see if I can do this.


## Pre-deployment tasks:

1. Clone this repo, set up your AWS CLI credentials/tokens and install terraform.  Google around for a bit if you don't know how to do this.

2. Sign yourself up for an account on Zero Tier and create a VPN.  Make a note of the address space you'll be using.

https://www.zerotier.com/

3. Install the Zero Tier client on your local machine and join the network you created.  You can find documentation on this on the Zero Tier site.

4. Decide on an AWS region, AMI, and VPC, and make a note of these id's.  Create a security group in that region and VPC that allows the following inbound (and everything outbound):

   - RDP (TCP 3389) from only your ip address ("My IP" in the ec2 security group console dropdown)
   - All Trafic from the address space of your Zero Tier VPN network.

 5. Create an EC2 keypair and download the private key.  You'll need it to decrypt the Administrator password.

 6. Populate the terraform variable, either by changing the default values in variables.tf or passing them on the CLI.  Specifically, set the AMI, secuirty group id, and keypair (all from step 4), and optionally change the instance type if you want a different instance type.

 Note: the vpcid variable currently isn't used, as the vpc gets matched via the security group parameter.

 7. Run terraform plan to see what will be created, terraform apply to create it, and/or terraform destroy to tear it all down.

 8. RDP in, see if things are working, join the zerotier network, authorize the new node on your zerotier network, log into steam, see if you can stream games on your local machine.