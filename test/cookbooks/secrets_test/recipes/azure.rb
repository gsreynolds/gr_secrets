# https://docs.microsoft.com/en-gb/azure/active-directory/managed-identities-azure-resources/overview

vault = node['secrets_test']['vault']
secret = 'test-secret'

# Using the system-assigned managed identity for the VM, that has been permitted access to the Key Vault
# Write the secret to a file:
file '/etc/config_file' do
  content lazy { "password = #{akv_get_secret(vault: vault, secret: secret)}" }
end

# Using a user-assigned managed identity that is permitted access to the Key Vault, added to the VM
msi_data_bag = data_bag_item('azure_key_vault', 'msi_encrypted')
file '/etc/config_file_user_assigned_msi' do
  content lazy { "password = #{akv_get_secret(vault: vault, secret: secret, user_assigned_msi: msi_data_bag)}" }
end

# Use a service principal, that has been permitted access to the Key Vault
# encrypted_data_bag_secret in client.rb, defaults to /etc/chef/encrypted_data_bag_secret
# and C:\chef\encrypted_data_bag_secret.

# knife data bag create azure_key_vault spn_encrypted --secret-file encrypted_data_bag_secret
spn_data_bag = data_bag_item('azure_key_vault', 'spn_encrypted')

# Write the secret to a file:
file '/etc/config_file_spn' do
  content lazy { "password = #{akv_get_secret(vault: vault, secret: secret, spn: spn_data_bag)}" }
end
