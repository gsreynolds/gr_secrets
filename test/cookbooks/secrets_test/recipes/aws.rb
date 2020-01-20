# Write the secret to a file:
file '/etc/config_file' do
  content lazy { "password = #{get_aws_secret('test-secret', node['secrets_test']['region'])}" }
end
