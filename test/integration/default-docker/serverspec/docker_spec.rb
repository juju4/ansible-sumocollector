require 'serverspec'

# Required by serverspec
set :backend, :exec

## Use Junit formatter output, supported by jenkins
#require 'yarjuf'
#RSpec.configure do |c|
#    c.formatter = 'JUnit'
#end

describe package('docker-ce') do
  it { should be_installed }
end

describe service('docker') do
  it { should be_enabled }
## Note: will failed inside kitchen/docker
#  it { should be_running }
end
