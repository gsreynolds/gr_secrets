include_recipe 'secrets::default'

# Write the secret to a file:
file '/etc/config_file' do
  content lazy { "password = #{akv_get_secret('kitchen-secrets-test', 'test-secret')}" }
end
