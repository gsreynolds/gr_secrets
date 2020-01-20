# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'gr_secrets'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'secrets_test::default'
named_run_list :azure, 'secrets_test::azure'

# Specify a custom source for a single cookbook:
cookbook 'secrets_test', path: './test/cookbooks/secrets_test'
cookbook 'gr_secrets', path: '.'
