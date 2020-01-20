require 'aws-sdk-secretsmanager'
require 'base64'

def get_aws_secret(secret_name, region_name)
  client = Aws::SecretsManager::Client.new(region: region_name)
  begin
    get_secret_value_response = client.get_secret_value(secret_id: secret_name)
  rescue Aws::SecretsManager::Errors::DecryptionFailure => e
    raise
  rescue Aws::SecretsManager::Errors::InternalServiceError => e
    raise
  rescue Aws::SecretsManager::Errors::InvalidParameterException => e
    raise
  rescue Aws::SecretsManager::Errors::InvalidRequestException => e
    raise
  rescue Aws::SecretsManager::Errors::ResourceNotFoundException => e
    raise
  else
    secret = if get_secret_value_response.secret_string
               get_secret_value_response.secret_string
             else
               Base64.decode64(get_secret_value_response.secret_binary)
             end
  end
  secret
end
