require 'serverspec'

# Required by serverspec
set :backend, :exec

## Use Junit formatter output, supported by jenkins
#require 'yarjuf'
#RSpec.configure do |c|
#    c.formatter = 'JUnit'
#end

describe package('SumoCollector'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end
describe package('sumocollector'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('collector') do
  it { should be_enabled }
#  it { should be_running }
end

# Only-valid post-registration. NOK inside CI/CD without registration
#describe process("wrapper") do
#  its(:user) { should eq "root" }
#  its(:args) { should match /wrapper.displayname=SumoLogic/ }
#  its(:count) { should eq 1 }
#end
#describe process("java") do
#  its(:user) { should eq "root" }
#  its(:args) { should match /sumologic/ }
#  its(:count) { should eq 1 }
#end

describe file('/opt/SumoCollector/config/user.properties') do
  its(:size) { should > 0 }
  its(:content) { should match /accessid/ }
  its(:content) { should match /accesskey/ }
  let(:sudo_options) { '-u root -H' }
end

describe file('/opt/SumoCollector/logs/collector.log') do
  its(:size) { should > 0 }
  its(:content) { should match /com.sumologic.util.scala.configuration.AssemblyBootstrapConfigurationFactory - Loaded configuration file:/ }
## will have errors as not providing credentials
#  its(:content) { should_not match /ERROR/ }
  let(:sudo_options) { '-u root -H' }
end
describe file('/opt/SumoCollector/logs/collector.out.log') do
  its(:size) { should > 0 }
  its(:content) { should match /--> Wrapper Started as Daemon/ }
  let(:sudo_options) { '-u root -H' }
end

## any sumo command to check setup is valid?
#describe command('true') do
#  its(:stdout) { should_not match /FATAL/ }
#  its(:exit_status) { should eq 0 }
#end

# https://help.sumologic.com/03Send-Data/Installed-Collectors/05Reference-Information-for-Collector-Installation/01Test-Connectivity-for-Sumo-Logic-Collectors
describe command('curl -iv https://collectors.sumologic.com') do
  its(:stdout) { should match /Tweep/ }
  its(:stderr) { should match /200 OK/ }
  #its(:stderr) { should match /SSL certificate verify ok./ }
  #its(:stderr) { should match /subjectAltName: host "collectors.sumologic.com" matched cert's "collectors.sumologic.com"/ }
  its(:exit_status) { should eq 0 }
end
