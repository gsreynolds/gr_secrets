# Write the secret to a file:
file '/etc/config_file' do
  content lazy { "password = #{akv_get_secret(node['secrets_test']['vault'], 'test-secret')}" }
end
