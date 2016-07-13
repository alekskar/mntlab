##Troubleshoting
**What java version is installed?**

We can determine which version of the JDK is the default by typing
```
java -version
```
**How was it installed and configured?**
```
Java was installed via unpackage (rpm -qi java does't return result)
Java vas configured via alternatives
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
The three numbers represent averages load and queue of CPU over progressively longer periods of time (1,5,15 min). On single core mashines 1,70 means that system is overloaded and we have queue.
On multi-processor system, the load is relative to the number of processor cores available. The "100% utilization" mark is 1.00 on a single-core system, 2.00, on a dual-core, 4.00.
```

| n   | issue           | How to find       |Time to find | How to fix            | Time to fix |
| ----| ----------------|-------------------|-------------|-----------------------|-------------|
|   1  | Monday          |           pasta   |                 $6    |        1     |2|

