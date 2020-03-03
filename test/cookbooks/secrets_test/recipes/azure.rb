# Write the secret to a file:
file '/etc/config_file' do
  content lazy { "password = #{akv_get_secret(node['secrets_test']['vault'], 'test-secret')}" }
end

# encrypted_data_bag_secret in client.rb, defaults to /etc/chef/encrypted_data_bag_secret
# and C:\chef\encrypted_data_bag_secret. In Test Kitchen it is /tmp/kitchen/encrypted_data_bag_secret

# knife data bag create azure_key_vault spn_encrypted --secret-file encrypted_data_bag_secret
spn_data_bag = data_bag_item('azure_key_vault', 'spn_encrypted')

# Write the secret to a file:
file '/etc/config_file_spn' do
  content lazy { "password = #{akv_get_secret(node['secrets_test']['vault'], 'test-secret', spn_data_bag.to_h)}" }
end
