
**What java version is installed?**

We can determine which version of the JDK is the default by typing
```
java -version
```
**How was it installed and configured?**


**Where are log files of tomcat and httpd?**

Tomcat logs are defined in catalina.sh and by defaults it is

"$CATALINA_BASE"/logs/catalina.out - where $CATALINA_BASE is base directory for resolving dynamic portions, if not defined it equel $CATALINA_HOME in task it is 
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

**What configuration files are used to make components work with each other?**

**What does it mean: “load average: 1.18, 0.95, 0.83”?**

| n   | Day     | Meal    | Price |
| ----| --------|---------|-------|
|     | Monday  | pasta   | $6    |
|     | Tuesday | chicken | $8    |
