##Vagrant Task1
**1. Install Virtualbox and Vagrant**

![image]( https://github.com/alekskar/vagrant/blob/master/sources/vagrant_version.png "Figure 1. Vagrant version")

![image] (https://github.com/alekskar/vagrant/blob/master/sources/virt_box_version.png "Figure 2. VboxVersion")

**2. Initialize new Vagrant project**

![image](https://github.com/alekskar/vagrant/blob/master/sources/vagrantup.png "Figure 4. Initialize new Vagrant project")

**3. Update configuration to use specific vagrant box (sbeliakou/centos-6.7-x86_64 )**

![image] (https://github.com/alekskar/vagrant/blob/master/sources/addbox.png "Figure 4. Add box")

**4. Configure multiple VM’s in single Vagrantfile (2 VM’s):**

*Vagrantfile describes provisioning and configuration VM's*

*on VM1 we provision httpd and mod_jk and this VM's is configured as web frontend for VM2*

**this part is described in web.sh placed in root branch**

 [Script web.sh] (https://github.com/alekskar/vagrant/blob/master/web.sh "Web.sh Script")
 

Basic commands are:
```
	yum install -y httpd
	cd /home/vagrant/sources
	cp ./mod_jk.so /etc/httpd/modules/
	cp ./httpd-vhosts.conf /etc/httpd/conf.d/
	cp ./workers.properties /etc/httpd/conf/
	rm -f /etc/httpd/conf/httpd.conf
	cp ./httpd.conf /etc/httpd/conf/httpd.conf
	chkconfig httpd on
	service httpd start
```
**app.sh script installs and configures tomcat and its dependencies (VM2)**

[Script app.sh] (https://github.com/alekskar/vagrant/blob/master/app.sh "App.sh Script")
  
  Basic commands of app.sh are:
```
  	cd /home/vagrant/sources
	yum install -y java-1.8.0-openjdk.x86_64
	wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.3/bin/apache-tomcat-8.5.3.tar.gz
	tar xvfz apache-tomcat-8.5.3.tar.gz
	cd ./apache-tomcat-8.5.3/bin
	chmod a+x *.sh
	bash startup.sh
  
```

**5. Customize VMs’ settings:**

Vagrant.configure("2") do |config|

**First VM**
	
```
	  	config.vm.define "web", primary: true do |web|
	  		web.vm.box = "sbeliakou/centos-6.7-x86_64"
			web.vm.hostname = "web"
	  		web.vm.network "private_network", ip: "192.168.100.10"
	  		web.vm.network "forwarded_port", guest: 80, host: 8080
			web.vm.provider "virtualbox" do |host|
				host.name="web-frontend"
				host.cpus = 1
				host.memory = 512
	   			
			end
		 	web.vm.provision "shell", inline: "echo WebServer"
		 	web.vm.provision "shell", path: "web.sh"
		 end
```
	
**Second VM configuration**
```
  		config.vm.define "app" do |app|
			app.vm.box = "sbeliakou/centos-6.7-x86_64"
			app.vm.hostname = "app"
			app.vm.network "private_network", ip: "192.168.100.11"
			app.vm.network "forwarded_port", guest: 80, host: 8081
			app.vm.provider "virtualbox" do |host|
			        host.name="app-backend"
			        host.customize ["modifyvm", :id, "--cpuexecutioncap", "35"]
			        host.memory = 1024
			end
   		app.vm.provision "shell", inline: "echo AppServer"
   		app.vm.provision "shell", path: "app.sh"
   		end
```
  		
**6. Mount host directories into VMs, specify ownerships**

```
     	config.vm.synced_folder "sources/", "/home/vagrant/sources",
	owner: "vagrant", group: "vagrant",
	create: true
```	
   **7. Define shell provisioners # default provisioner (performs on both VMs):**
```
		config.vm.provision "shell", inline: <<-SHELL 
		echo "This host is ready for provisioning" 
		yum install -y vim
		SHELL

```
end

![images] (https://github.com/alekskar/vagrant/blob/master/sources/virtbox.png "Running VM's in VBox")

###Privisioning and VM's configuration are completed successfully!!!

![images] (https://github.com/alekskar/vagrant/blob/master/sources/all_work80.png "Running tomcat with appache")

*Report folder structure:*
```
vagrant/
	sources/
			any resources for web.sh/app.sh scripts and pictures
	README.md
	Vagrantfile
	web.sh
	app.sh
```

