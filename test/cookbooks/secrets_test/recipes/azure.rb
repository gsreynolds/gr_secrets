# https://docs.microsoft.com/en-gb/azure/active-directory/managed-identities-azure-resources/overview

# Using the system-assigned managed identity for the VM, that has been permitted access to the Key Vault
# Write the secret to a file:
file '/etc/config_file' do
  content lazy { "password = #{akv_get_secret(node['secrets_test']['vault'], 'test-secret')}" }
end

# # Using a user-assigned managed identity that is permitted access to the Key Vault, added to the VM
# user_assigned_msi = { 'client_id': '551c07b7-10f5-4623-bfa2-2b4ff6e6ba05' }
# user_assigned_msi = { 'object_id': 'e0af322e-87ef-4631-addf-c1e65b50293e' }
# file '/etc/config_file_user_assigned_msi' do
#   content lazy { "password = #{akv_get_secret(node['secrets_test']['vault'], 'test-secret', {}, user_assigned_msi)}" }
# end

# # Use a service principal, that has been permitted access to the Key Vault
# # encrypted_data_bag_secret in client.rb, defaults to /etc/chef/encrypted_data_bag_secret
# # and C:\chef\encrypted_data_bag_secret. In Test Kitchen it is /tmp/kitchen/encrypted_data_bag_secret

# # knife data bag create azure_key_vault spn_encrypted --secret-file encrypted_data_bag_secret
# spn_data_bag = data_bag_item('azure_key_vault', 'spn_encrypted')

# # Write the secret to a file:
# file '/etc/config_file_spn' do
#   content lazy { "password = #{akv_get_secret(node['secrets_test']['vault'], 'test-secret', spn_data_bag.to_h)}" }
# end
