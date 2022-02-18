### Deploy a VOS Device as a Branch Using Terraform Templates

This section describes how to use Terraform templates to automatically deploy a Versa Operating System<sup>TM</sup> (VOS<sup>TM</sup>) device as a branch. You obtain the Terraform template files from Versa Networks Customer Support. To deploy a VOS device as a branch, ask for the Versa_FlexVNF_SingleBranch_Staging.zip file, which contains the Terraform templates for the branch deployment.

To deploy a VOS device as a branch using Terraform templates, follow Step 1 to Step 6 as described in [Create VMs for Versa Headend Components](https://docs.versa-networks.com/Getting_Started/Deployment_and_Initial_Configuration/Headend_Deployment/Installation/Install_on_Azure#Create_VMs_for_Versa_Headend_Components "Getting_Started/Deployment_and_Initial_Configuration/Headend_Deployment/Installation/Install_on_Azure#Create VMs for Versa Headend Components").

The following table describes the contents of each Terraform template file and the actions performed by each file.

<table class="mt-responsive-table">

<thead>

<tr>

<th class="mt-column-width-15" scope="col">**Filename**</th>

<th class="mt-column-width-85" scope="col">**Description or Action**</th>

</tr>

<tr>

<td class="mt-column-width-15" data-th="Filename">vars.tf</td>

<td class="mt-column-width-85" data-th="Description or Action">Definitions of all variables defined and used in the template. Do not make any changes to this file.</td>

</tr>

<tr>

<td class="mt-column-width-15" data-th="Filename" style="vertical-align:top;">terraform.tfvars</td>

<td class="mt-column-width-85" data-th="Description or Action" style="vertical-align:middle;">

User-defined input variables that are used to populate the Terraform templates. Edit this file to set or change the following variables:

*   subscription_id—Subscription identifier information for the Azure account.
*   client_id—Client identifier information obtained as part of setting up Terraform access.
*   client_secret—Client secret information obtained as part of setting up Terraform access.
*   tenant_id—Tenant identifier information obtained as part of Setting up Terraform access.
*   location—Enter the string that identifies the VOS device location. For example, west-us or west-europe.
*   resource_group—Name of the resource group in which to place the resources for the VOS device. The default is Versa_FlexVNF_RG.
*   ssh_key—SSH public key. This key is required to log in to the VOS instances. To generate the SSH key, use the sshkey-gen or putty key generator command. You cannot generate keys within Azure.
*   mgmt_subnet—Management subnet ID used to create interfaces on the management subnet.
*   wan_subnet—Subnet of the WAN network used to to create the WAN network interface.
*   lan_subnet—Subnet of the LAN network used to create the LAN network interfaces.
*   vm_name—Name of the VM that is displayed in the VM list of the Azure Portal. The default is Versa_FlexVNF.
*   flexvnf_vm_size—Instance type and size used to provision the FlexVNF-1 VM. The default is Standard_F4s.
*   controller_wan_ip—WAN IP of the Controller device used for staging with the branch. This can be a private IP address or a public IP address where the branch can reach the Controller device.
*   local_auth—Local authentication at the branch used for staging.
*   remote_auth—Remote authentication to use for staging. This is Controller-side authentication key used during staging of the branch.
*   branch_serial_num—Serial number of branch to be set. This must be the same as the serial number that is provided during the corresponding Workflow device deployment in Versa Director.
*   branch_wan_nic—Indicates the port number of WAN port. To use vni-0/0 as the branch WAN interface or port, the value must be 0; to use vni-0/1, the value must be 1; and so on. The default is 0.
*   director_northboud_ip—Northbound IP address of the Director node.
*   director_southboud_ip—Southbound IP address of the Director node.

</td>

</tr>

<tr>

<td class="mt-column-width-15" data-th="Filename" style="vertical-align:middle;">output.tf</td>

<td class="mt-column-width-85" data-th="Description or Action">Output parameters, including management IP address, public IP address, WAN IP address, LAN IP address, and CLI commands, for all instances. Do not make any changes to this file.</td>

</tr>

<tr>

<td class="mt-column-width-15" data-th="Filename" style="vertical-align:middle;">flexvnf.sh</td>

<td class="mt-column-width-85" data-th="Description or Action">Bash script that runs as part of cloud-init script on the VOS instance. Do not make any changes to this file.</td>

</tr>

<tr>

<td class="mt-column-width-15" data-th="Filename" style="vertical-align:middle;">main.tf</td>

<td class="mt-column-width-85" data-th="Description or Action">

*   Provision one resource group, called Versa_FlexVNF_RG. To change the resource group name, edit the terraform.tfvars file.
*   Assign a public IP address on the management port of the VOS device instance.
*   Assign a static public IP address for the VOS device WAN port.
*   Provision a network security group, and add all the firewall rules required to set up the VOS device.
*   Install a VOS instance and run the cloud-init script to:
    *   Update the /etc/network/interface file.
    *   Add the SSH key for the admin user.
    *   Add a cron job to trigger the staging.py script required for ZTP.

</td>

</tr>

</thead>

</table>

</div>

</div>


</footer>

</article>

<footer class="elm-footer">

<nav class="elm-footer-siteinfo-nav elm-nav">

<div class="elm-nav-container">

</div>

</nav>

</footer>

</main>
