hosts = [
  { name: 'master',     box: 'centos/7',     cpu: 1,     mem: 2048, 	netint: 1 },
  { name: 'work1',      box: 'centos/7',	   cpu: 2,     mem: 4096,	  netint: 2 },
  { name: 'work2',      box: 'centos/7',	   cpu: 2,     mem: 4096,	  netint: 2 }
]


Vagrant.configure('2') do |config|
  hosts.each do |host|
    config.vm.define host[:name] do |node|
      node.vm.box = host[:box]
      node.vm.hostname = host[:name]
      node.vm.provider :virtualbox do |vm|
        vm.memory = host[:mem]
		    vm.cpus = host[:cpu]
      end

      if host[:netint] == 1
        node.vm.network :public_network, bridge: "Intel(R) Ethernet Connection (7) I219-LM"
        node.vm.provision 'shell', path: 'kube_master.sh'
      end

      if host[:netint] == 2
        node.vm.network :public_network, bridge: "Intel(R) Ethernet Connection (7) I219-LM"
        node.vm.provision 'shell', path: 'kube_work.sh'
      end

    end
    config.vm.synced_folder '.', '/vagrant', type: 'virtualbox'
    Vagrant::Config.run do |config|
      config.vbguest.auto_update = false
      config.vbguest.no_remote = true
    end
  end
end
