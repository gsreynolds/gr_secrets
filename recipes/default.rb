apt_update 'periodic' do
  ignore_failure true
end.run_action(:periodic)

build_essential 'install' do
  compile_time true
end

chef_gem 'azure_key_vault' do
  action :install
  compile_time true
end
