##Troubleshooting
**What java version is installed?**

We can determine which version of the JDK is the default by typing
```
java -version
```

![image1](https://github.com/alekskar/mntlab/blob/master/Troubleshooting/sources/javaver.png "Java Version")


**How was it installed and configured?**
```
Java was installed via unpackage (rpm -qi java does't return result)
Java was configured via alternatives
```
**Where are log files of tomcat and httpd?**

Tomcat logs are defined in catalina.sh and by defaults it is "$CATALINA_BASE"/logs/catalina.out - where $CATALINA_BASE 
is base directory for resolving dynamic portions, if not defined it equel $CATALINA_HOME in task it is 
```
/opt/apache/tomcat/7.0.62/logs/
```
Httpd logs location are defined in httpd.conf and included *.conf files with vhosts definition.

global server log located 
```
/etc/httpd/logs/
files are: 
    access_log
    error_log
    
```
vhost server log is located
```
/etc/httpd/logs/
/etc/httpd/logs/
files are: 
    access.log
    error.log
```

**Where is JAVA_HOME and what is it?**

JAVA_HOME is an environment variable that helps to locate JDK and JRE to other applications such as Tomcat
at host it configured via alternatives which refer to symlink /usr

![image2](https://github.com/alekskar/mntlab/blob/master/Troubleshooting/sources/javasetup.png "JAVA HOME")

```
JAVA_HOME=/opt/oracle/java/x64/jdk1.7.0_79
```
**Where is tomcat installed?**
```
/opt/apache/tomcat/7.0.62
```

**What is CATALINA_HOME?**

It is an environment variable which point at  Catalina "build" or "root" directory.
```
/opt/apache/tomcat/7.0.62
```
**What users run httpd and tomcat processes? How is it configured?**

run command *ps -ef | grep httpd* show us that root httpd process run under root user and child processes run under apache user
this behaviour is described in httpd.conf file.
tomcat is running under tomcat user. It was set up in init script /etc/init.d/tomcat

**What configuration files are used to make components work with each other?**

* Apache config
    * httpd.conf
    * vhost.conf
    * workers.properties
* Tomcat config
    * server


**What does it mean: “load average: 1.18, 0.95, 0.83”?**
```
The three numbers represent averages load and queue of CPU over progressively
longer periods of time (1,5,15 min). 
On single core mashines 1,70 means that system is overloaded and we have queue.
On multi-processor system, the load is relative to the number of processor cores available. 
The "100% utilization" mark is 1.00 on a single-core system, 2.00, on a dual-core, 4.00.
```

| n   | Issue           | How to find       |Time to find | How to fix            | Time to fix |
| ----| ----------------|-------------------|-------------|-----------------------|-------------|
|   1  | Site is not available | internal:curl -IL 192.168.56.10 return 302 response, and redirect to mntlab  | 1 min  | check local availability: curl -IL 192.168.56.10 return 302 and 503 response - problem with different configurations. Fix httpd.conf (comment <Virtualhost block ) and vhost.conf (replace in Virtualhost directory listen from mntlab to all interfaces). Restart apache  |20|
|2|Site is not available. Problems with tomcat |curl -IL 192.168.56.10 return 503 error, that means Service Tomcat Temporarily Unavailable. Check tomcat process: ps -ef \|grep tomcat -service isn't running | 5 | * Try to start service: service tomcat start,  ps -ef \|grep tomcat -service isn't running. Check init script /etc/init.d/tomcat, comment redirect stdout to null interface. restarting tomcat response with missing file classpath.sh. Check executable script catalina.sh  looking for classpath.sh - locate problem with environment variable $CATALINA_HOME. Script is running under the user tomcat. Swich to tomcat user su - tomcat. Check Variable $CATALINA_HOME -locate the problem with wrong path, found the problem in profile tomcat user in ~/.bashrc - delete wrong records. Restart tomcat. Locate issue with permissions on catalina.out files. check rights and ownrer - owner is wrong - change to tomcat user with chown -R on all directory with logs to tomcat:tomcat.Restart tomcat |50|
|3|Site is not available. Problems with JAVA| Check tomcat logs catalina.out - locate problems with missing libs.|2| Checking java version -it return error. host is 64bit, but java version is 32, change java via alternatives.Restart tomcat | 5| 
|4|Site is not available. Wrong connectors properties|curl -IL return 503 error|10|Check httpd logs location,  check modjk.log - locate problems with ajp and tomcat.worker. Check configuration workers.properties. Fix configuration (change worker-jk@ppname to tomcat.worker, and fix ip adress to 192.168.50.10) Restart httpd and tomcat|25|
|5|Service iptables not run|iptables -L -n | 1| Iptables is readOnly and cannot be modified. Check atributes with lsattr. Locate immutable attibute. Modify immutable attribute with chattr -i. Edit iptables with proper records. -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT and A INPUT -p tcp -m tcp --dport 80 -m comment --comment "#webserver" -j ACCEPT and COMMIT restart iptables |60|


