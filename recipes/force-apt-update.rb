execute 'apt-get update' do
  command 'apt-get update'
  action :nothing
end.run_action(:run)
