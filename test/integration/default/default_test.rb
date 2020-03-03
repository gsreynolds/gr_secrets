# InSpec test for recipe gr_secrets::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe file('/etc/config_file') do
  its(:content) { should match 'password = test1234' }
end

describe file('/etc/config_file_user_assigned_msi') do
  its(:content) { should match 'password = test1234' }
end

describe file('/etc/config_file_spn') do
  its(:content) { should match 'password = test1234' }
end
