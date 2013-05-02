case node[:platform]
  when "debian", "ubuntu"
    ['python-pysnmp4', 'python-configobj'].each{|p| package p}

    cookbook_file "/tmp/#{node['diamond']['install_cookbookfile']['filename']}" do
      action :create_if_missing
      backup false
      source node['diamond']['install_cookbookfile']['filename']
    end

    dpkg_package "diamond" do
      action :install
      source "/tmp/#{node['diamond']['install_cookbookfile']['filename']}"
      notifies :restart, resources(:service => "diamond")
    end

  when "centos", "redhat", "fedora", "amazon", "scientific"
    package "diamond" do
      action :install
      version node['diamond']['version']
      notifies :restart, resources(:service => "diamond")
    end
end
