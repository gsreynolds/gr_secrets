# helper for retrieving a secret from an azure keyvault

module Azure
  module KeyVault
    def akv_get_secret(options = {})
      require 'azure_key_vault'

      vault = options.fetch(:vault, '')
      secret_name = options.fetch(:secret, '')
      spn = options.fetch(:spn, {})
      user_assigned_msi = options.fetch(:user_assigned_msi, {})
      secret_version = options.fetch(:secret_version, nil)

      raise 'Vault name not provided' if vault.empty? || vault.nil?
      raise 'Secret name not provided' if secret_name.empty? || secret_name.nil?

      vault_url = "https://#{vault}.vault.azure.net"
      if secret_version.nil?
        secret_version = ''
      end
      token_provider = create_token_credentials(spn, user_assigned_msi)
      credentials = MsRest::TokenCredentials.new(token_provider)
      client = Azure::KeyVault::V7_0::KeyVaultClient.new(credentials)
      response = client.get_secret(vault_url, secret_name, secret_version).value
      response
    end

    private

    def token_audience
      @audience ||= MsRestAzure::ActiveDirectoryServiceSettings.new.tap do |s|
        s.authentication_endpoint = 'https://login.windows.net/'
        s.token_audience = 'https://vault.azure.net'
      end
    end

    def create_token_credentials(spn, user_assigned_msi = {})
      # We assume use MSI if spn is empty.
      # We define the port because we get a var deprecation error if not defined.
      if spn.nil? || spn.empty?
        @token_provider ||= begin
          MsRestAzure::MSITokenProvider.new(50342, token_audience, user_assigned_msi)
        end
      else
        validate_service_principal!(spn)
        tenant_id = spn['tenant_id']
        client_id = spn['client_id']
        secret = spn['secret']
        @token_provider ||= begin
          MsRestAzure::ApplicationTokenProvider.new(tenant_id, client_id, secret, token_audience)
        end
      end
    end

    def validate_service_principal!(spn)
      spn['tenant_id'] ||= ENV['AZURE_TENANT_ID']
      spn['client_id'] ||= ENV['AZURE_CLIENT_ID']
      spn['secret'] ||= ENV['AZURE_CLIENT_SECRET']
      raise 'Invalid SPN info provided' unless spn['tenant_id'] && spn['client_id'] && spn['secret']
    end
  end
end

Chef::Recipe.send(:include, Azure::KeyVault)
Chef::Resource.send(:include, Azure::KeyVault)
