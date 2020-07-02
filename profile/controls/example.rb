control 'azurerm_aks_cluster_gitops-demo-aks' do
  title 'Check if the gitops-demo-aks cluster matches expectations'
  impact 1.0

describe azurerm_aks_cluster(resource_group: 'azkubernetes', name: 'gitops-demo-aks') do
do 
  it { should exist }
  it { should be running}
  its('location') { should cmp 'eastus' }
  its('resource_group_name') { should cmp 'azkubernetes' }
  it { should have_tags } { 'Terraform' }
  
  its('properties.dnsPrefix') { should cmp 'gitlab' }
end
describe azurerm_network_security_group(resource_group: 'azkubernetes', name: 'gitops-demo-aks') 
do
  its('properties.agentPoolProfiles.first.name') { should cmp 'default' }
  its('properties.agentPoolProfiles.first.count') { should cmp 1 }
  its('properties.agentPoolProfiles.first.vmSize') { should cmp 'Standard_F2s_v2' }
    its('properties.osProfile.diskSizeGB') { should cmp 30 }
 
  
end

describe azurerm_network_security_group(resource_group: 'azkubernetes', name: 'gitops-demo-aks')
do
  its('properties.provisioningState') { should cmp 'Succeeded' }
end  

depends:
  - name: inspec-azure
    git: https://github.com/inspec/inspec-azure.git
supports:
  platform: azure
end

my_services = yaml(content: inspec.profile.file('services.yml')).params

my_services.each do |s|
  describe service['http'] do
    it { should be_running }
end

describe port['80' do
  it { should be_listening }
  end

