# Installation of ActiveVOS on Websphere Cluster

| Document Property |                        Value                        |
|-------------------|-----------------------------------------------------|
| Author:           | [ Jaroslav Brazda ](mailto:jbrazda@informatica.com) |
| Release Date:     | December 2014                                       |


<!-- MarkdownTOC depth=3 -->

- [Overview](#overview)
    - [IBM WebSphere Terminology](#ibm-websphere-terminology)
    - [Installation Checklist](#installation-checklist)
        - [Hardware](#hardware)
        - [Software](#software)
        - [License Information](#license-information)
        - [Database Information](#database-information)
        - [Server Container Information](#server-container-information)
    - [Software used in this Guide](#software-used-in-this-guide)
    - [Prepare Database for ActiveVOS](#prepare-database-for-activevos)
    - [Install IBM WebSphere Application Server Network Deployment](#install-ibm-websphere-application-server-network-deployment)
    - [Configure IBM WebSphere Network Deployment Components](#configure-ibm-websphere-network-deployment-components)
        - [Create Deployment Manager](#create-deployment-manager)
        - [Set JVM arguments in the administration console for WebSphere Application Servers.](#set-jvm-arguments-in-the-administration-console-for-websphere-application-servers)
    - [First Steps Guide](#first-steps-guide)
        - [Create Cell Node](#create-cell-node)
        - [Create Cluster](#create-cluster)
        - [Configure ActiveVOS Data Sources](#configure-activevos-data-sources)
        - [Set up JAAS Application Logins](#set-up-jaas-application-logins)
        - [Install and Configure WAS Web Server Plugins](#install-and-configure-was-web-server-plugins)
        - [Configuring the NodeAgent to start as a Windows Service](#configuring-the-nodeagent-to-start-as-a-windows-service)
    - [Install ActiveVOS](#install-activevos)
        - [Install ActiveVOS Config Deploy Tool](#install-activevos-config-deploy-tool)
        - [Run ActiveVOS Config Deploy Tool](#run-activevos-config-deploy-tool)
        - [Configure Application Security](#configure-application-security)
        - [Resources Created by Config Deploy WAS Server](#resources-created-by-config-deploy-was-server)
- [Appendices](#appendices)
    - [Profile Management Tip](#profile-management-tip)
    - [SSL and SSO Configuration Tips](#ssl-and-sso-configuration-tips)

<!-- /MarkdownTOC -->


## Overview 
This document summarizes the steps of deploying ActiveVOS on the IBM WebSphere Platform. This guide focus on the installation on the Network Deployment Application Server clustered deployment using Oracle 11g, ActiveVOS 9.2.4 and Windows 7 Host machine.

## IBM WebSphere Terminology

During the WebSphere installation, you may encounter a mix of standard and non-standard technical terms from the Application Server technology space. IBM WebSphere currently offers three versions of their application server product.

* __IBM WebSphere Express__ is a slimmed down version of the product which offers no EJB container, embedded messaging support or JCA resource adapters. Also, there is no central administration or workload management.A mid-level offering is the __IBM WebSphere Application Server__ product which contains an EJB container, embedded messaging and JCA resource adapter. However it still does not contain a central administration or workload management facility.The third offering is a __Network Deployment Application Server__ which contains a central administration and workload management facility. It also contains a Web Services UDDI Registry and Web Services Gateway.

The following is a list of some of the terms you may encounter as well as well as an explanation of each:
* __Cell__ - a grouping of nodes into a single administrative domain. In the Base and Express configurations, a cell contains one node. That node may have multiple servers, but the configuration files for each server are stored and maintained individually. In a Network Deployment version the configuration and application files for all nodes in the cell are centralized into a cell master configuration repository.
* __Network Deployment__ - configuration offers central administration and workload management. A Network Deployment environment consists of one or more Base installations and a Deployment Manager installation. The Base application servers are added to the cell and managed by the Deployment Manager.
* __Node Agent__ - As you move up through the more advanced IBM WebSphere Application Server configurations, the concepts of configuring multiple nodes from one common administration server and workload distribution among nodes are introduced. In these centralized management configurations, each node has a node agent that works with a Deployment Manager to manage administration processes.
* __Nodes__ - A node is a logical grouping of IBM WebSphere-managed server processes that share common configuration and operational control. A node is generally associated with one physical installation of IBM WebSphere Application Server.
* __Cluster__ - A cluster is a logical collection of application server processes, with the sole purpose of providing workload balancing. Application servers that belong to a cluster are "members" of that cluster and must all have identical application components deployed on them. Other than the applications configured to run on them, cluster members do not have to share any other configuration data.
* __Application Servers__ - provide the runtime environment for application code. They provide containers and services that specialize in enabling the execution of specific Java application components.
* __IBM HTTP Server (IHS)__ - an Apache based web server which can provided Load balancing and integrated communication within the WAS Network server deployment. Together with the Websphere Application Server plug-in, it provides seamless scalability and load balancing across the WAS server nodes and instances.

## Installation Checklist

This section provides a list of most of the items that you should either have completed or information noted prior to attempting to install ActiveVOS Server.

### Hardware

* Server hardware must meet the requirements listed for each third-party application, including server container, database server and Java environment.
* At least 1 GB of disk space is required to install the ActiveVOS Server application.

### Software
* See a Product Availability Matrix, which is available on the My Support pages for each version of ActiveVOS. [ActiveVOS 9.24 PAM](https://mysupport.informatica.com/servlet/JiveServlet/downloadBody/12771-102-1-17705/ActiveVOS%209.2.4%20PAM.xlsx)
* See a [Websphere AS System Requirements](http://www-01.ibm.com/support/docview.wss?uid=swg27038218)
* A user account with administrative rights to install or manage all required software including the application and database servers and the ActiveVOS Server.
* The supported Server container installed on each machine intended to host ActiveVOS Server.
* JVM Memory arguments have been adjusted following are minimal JVM Sizing parameters: `-Xms256m -Xmx1024m -XX:MaxPermSize=384m`. [See Prerequisites](http://infocenter.activevos.com/infocenter/ActiveVOS/v92/index.jsp?topic=/doc.server_install/websphere/html/Prereqs.html)
* Make sure that your Identity Service (JDBC, LDAP, or XML), has all the roles defined especially important is to add abTaskClient role to each ActiveVOS Central user. This security role, described in the web.xml file, is required for access to ActiveVOS Central.
* On the URN Mappings page of the Administration Console, update the host and port for ActiveVOS Central to match your installation, In clustered install in this URL should point to your load balancer `http://[host]:[port]/activevos-central/avc` if needed. The default address is http://localhost:8080/activevos-central/avc.

### License Information
*  Valid license keys for the total number of sockets intended to host ActiveVOS Server.

### Database Information
* A supported database server installed and accessible.
* Permissions must be set for ActiveVOS to access your schema. 
* For WebLogic and WebSphere, configuration of a JNDI data source.
* The JDBC URL to use to connect to the ActiveVOS database.
* The database user name and password to be used by ActiveVOS Server to connect to the database.
* If you are using an Oracle database the ActiveVOS table-space created.
* A JDBC database driver that provides the required functionality.
* The class name of the JDBC database driver

### Server Container Information
* Installation Directories
* WAS Administrator User Accounts
* Desired Cluster Topology

## Software used in this Guide
|                       Software                      | Version |                                                 Download Page Link                                                |
|-----------------------------------------------------|---------|-------------------------------------------------------------------------------------------------------------------|
| IBM WebSphere Application Server Network Deployment | 8.5.5   | [Download](http://www.ibm.com/developerworks/downloads/ws/wasnetwork/)                                            |
| Oracle (1)                                          | 11g     | [Download](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html) |
| ActiveVOS Server                                    | 9.2.4   | [Download](https://mysupport.informatica.com/downloadsView.jspa)                                                  |


> (1) this guide uses Oracle XE but you can use any of the supported databases


## Prepare Database for ActiveVOS
We assume that the database is already installed in our case it was installed on the same machine as application server and ActiveVOS. 
We created user and grated the user following permissions

Please see configuration details for Oracle and other databases 
* [JDBC Configuration Parameters](http://infocenter.activevos.com/infocenter/ActiveVOS/v92/index.jsp?topic=/doc.server_install/websphere/html/config/ConfigWizard_ConfigDatabase.html)

> Note that ActiveVOS Installer (Config Deploy Tool) can create the database schema or just connect to existing one previously created by the DBA. 
> All supported database DDL scripts are included in the config deploy tool as described in this [documentation page](http://infocenter.activevos.com/infocenter/ActiveVOS/v92/topic/doc.server_install/websphere/html/Configuration_wizard.html#newdb) This guide will use method where the tables are created by the "Config Deploy" tool



Create  the ActiveVOS DB Schema user (You will have to login as SYSTEM user on Oracle)
```sql
CREATE USER <USERNAME> IDENTIFIED BY <PASSWORD>
  DEFAULT TABLESPACE "USERS"
  TEMPORARY TABLESPACE "TEMP";

GRANT CREATE SESSION TO <USERNAME>;
GRANT CREATE PROCEDURE TO <USERNAME>;
GRANT CREATE ROLE TO <USERNAME>;
GRANT CREATE SEQUENCE TO <USERNAME>;
GRANT CREATE SESSION TO <USERNAME>;
GRANT CREATE TABLE TO <USERNAME>;
GRANT CREATE VIEW TO <USERNAME>;

ALTER USER <USERNAME> quota unlimited on USERS;
```

> Please replace username and password with your own values and not them down. We will use these later during installation

We used:
* `<USERNAME> =  av924was`
* `<PASSWORD> =  av924was`

> Note that we used default USERS and TEMP tablespace for the ActiveVOS Database, in you case the tablespace may be different

## Install IBM WebSphere Application Server Network Deployment 
We used Trial version of Webspehere Application server downloaded from [Download](http://www.ibm.com/developerworks/downloads/ws/wasnetwork/). The Distribution file `NDTRIAL.agent.installer.win32.win32.x86_64.zip` contains IBM Installation Manager which allows you to download and select all the required and optional components
You will need IBM User ID and password to use this method of installation. You will need to register on [IBM Developer Support Site](https://www.ibm.com/developerworks/dwwi/jsp/Register.jsp).

> __NOTE:__ If you plan on installing IBM WebSphere to run as a service, you must log-on to the target machine using an account which has the following rights:
* Act as part of the operating system
* Log on as a service

Once you retrieve the installer unzip it to a directory of your choice. In our case we unzipped it into `<USERHOME>/Downloads/was` directory.
Run the Installer 

![Installer](images/was_install/install_01_installer.png "IBM Installation Manager")

On the First Run you will be prompted to enter your IBM Support ID Credentials
On the next step you will see options for a Web Sphere Installation components. 
Make sure you select following components:
* IBM HTTP Server for WebSphere Application Server (ILAN)
* IBM WebSphere Application Server Network Deployment
* Web Server Plug-ins for IBM WebSphere Application Server
* WebSphere Customization Toolbox (ILAN)

![Component Selection](images/was_install/install_02_components.png "Components Selection")

> __NOTE:__ We will use built-in IBM Java SDK 1.6 which is included within Websphere Application server installation. It is not necessary to install the 1.7 JDK unless it is required by some other components installed on the WAS Server.

Optionally you can select patches available for the release (we selected none)

![Patches Selection](images/was_install/install_03_patches.png "Patches Selection")

On the next Step: You have to agree with IBM License Agreement

![License Agreementt](images/was_install/install_04_license_agreement.png "License Agreement")

On the next Step: Select A Target Directory. You may see a following message on Windows 7/8 64bit

![Program files Warning](images/was_install/install_05_program_files_warning.png "Program files Warning")

Use other than  `Program Files` directory to install the product components
We used `C:\opt\ibm` as an installation base for all components.
Following screen-shot shows the C:\ibm as a target installation root

![Target Dir](images/was_install/install_06_target_dir.png "Target Dir")

On the next step: select primary language and optional translations (We used only English)
On the next Step: Check final summary of to be installed components and that you have sufficient space on your HDD (You will need proximately 3GB of space to install all required WAS components and ActiveVOS)

![Summary](images/was_install/install_07_summary.png "Summary")

Set the IBM HTTP Server port (use default 80) or optionally choose different one if it conflicts with some existing HTTP server on your machine.

![HTTP Server Params](images/was_install/install_08_http_server_params.png "HTTP Server Parameters")

Finish the wizard by running the installation. It will take some time to download and install all the components depending on your network bandwidth

![Run Install](images/was_install/install_09_run_install.png "Run Install")

Once installation is complete, you will be prompted to setup profiles for the IBM WebSphere installation, which you should run at this time.

## Configure IBM WebSphere Network Deployment Components
We will use Websphere Customization Toolbox > Profile Management Tool which is automatically started after the successful Websphere components installation. Alternatively you can also start it using Start > IBM Websphere > Websphere Customization Toolbox
### Create Deployment Manager
For our example deployment we want create topology consisting of 

* Deployment manager + Node Manager
    * ActiveVOS Cluster
        - ActiveVOS01
        - ActiveVOS02

Eventually you can add additional Node on separate Machine and a join them to the ActiveVOS Cluster

We will start with Deployment Manager and then create Node, Cluster and individual server nodes

* Run Websphere Customization Toolbox - Profile Management tool and click the `Create...` button
![New Profile](images/was_profiles/was_profile_01_new.png "New Profile")
* Select Managment Option
![Managment Profile](images/was_profiles/was_profile_02_type_managment.png "Management Profile")
* Select Advanced Profile Creation
![Profile Creation Options](images/was_profiles/was_profile_dmgr_01.png "Profile Creation Options")
* Keep Deploy Administrative Console Checked
![Profile Creation Options](images/was_profiles/was_profile_dmgr_02.png "Profile Creation Options")
* Accept the Default Location and Name for the Profile 
![DMGR Name](images/was_profiles/was_profile_dmgr_03.png "DMGR Name")
* You can Accpet the generated Node, Host and Cell Name
![Node, Host and Cell Name](images/was_profiles/was_profile_dmgr_04.png "Node, Host and Cell Name")
* Enable Administrative Security and define admin user name and password
![Admin Security](images/was_profiles/was_profile_dmgr_05.png "Admin Security")
* You can let Profile tool to generated default SSL Certificates for your node (Which is sufficient for test and development servers).  Alternatively you can also import pre-created certificates, Note that the generated certificates are signed by only by the WAS internal Certification Autority, for real environment you would want to create your certificates and let them sign by public CA your Coroporate CA.
![Certificates 1](images/was_profiles/was_profile_dmgr_06.png "Certificates 1")
* On a Dev or demo sandbox Server, you can accept the generated Values for HOST and default keystore password. Note that the default jeystore password is `WebAS`. It is practical to increase certificate expration date for your development environment. Follow customer Enterprice Policies to set the Expration time for production/test environments.
![Certificates 2](images/was_profiles/was_profile_dmgr_07.png "Certificates 2")
* Keep proposed default ports for WAS DMGR server instance
![Ports](images/was_profiles/was_profile_dmgr_08.png "Ports")
* Optionally Install as a Service if you installing on your machine, otherwise always enable automatic Service Start Configuration
![Windows Service](images/was_profiles/was_profile_dmgr_09.png "Windows Service")
* Review your Selections Summary and run the profile Creation
* Once the profile is created, You will get opportunity to display the first step Guide. You can finish the Guide.
![Finish](images/was_profiles/was_profile_dmgr_12.png "Finish")

### Set JVM arguments in the administration console for WebSphere Application Servers.
In the Administration Console select `Servers > Server Type > WebSphere application servers`
Click on the name of your server
Expand Java and Process Management and select Process Definition.
Under the Additional Properties section, click Java Virtual Machine.
![JVM](images/was_config/was_jvm_seetings.png "JVM")
Set Max and Min heap size and Scroll down and locate the textbox for Generic JVM arguments and set the perm Gen size or any other desired parameters.
![JVM](images/was_config/was_jvm_seetings_2.png "JVM")


## First Steps Guide 

* Verify that the Deployment Manager is installed and Running
* You can click on Start Deployment Manager
![First Steps](images/was_profiles/was_profile_dmgr_11.png "First Steps") You should see following output
```
ADMU0116I: Tool information is being logged in file
           C:\opt\ibm\WebSphere\AppServer\profiles\Dmgr01\logs\dmgr\startServer.log
ADMU7701I: Because dmgr is registered to run as a Windows Service, the request
           to start this server will be completed by starting the associated
           Windows Service.
ADMU0116I: Tool information is being logged in file
           C:\opt\ibm\WebSphere\AppServer\profiles\Dmgr01\logs\dmgr\startServer.log
ADMU0128I: Starting tool with the Dmgr01 profile
ADMU3100I: Reading configuration for server: dmgr
ADMU3200I: Server launched. Waiting for initialization status.
ADMU3000I: Server dmgr open for e-business; process id is 7668
```
* Try to login the Deployment manager Console
URL `https://<yourhost>:9043/ibm/console`

You may see following WARNING in your browser 
![warning](images/ssl/CA_Invalid_01.png "Create")

You can avoid by importing signing Root Certificate Generated by WAS or provided root certificate to your Windows CA trust store

### Create Cell Node
Second Step will be to create Cell Node Which will contain Your Cluster And Server Definitions

* We will run the Profile Manager Tool Again. This Time We will select Custom Profile
![Create](images/was_profiles/was_profile_node_01.png "Create")
* Select Custom Profile
![Custom](images/was_profiles/was_profile_node_02.png "Custom")
* Specify Profile name 'Node01', you can also make this profile default
![Profile Name](images/was_profiles/was_profile_node_03.png "Profile Name")
* You can Accpet the Generated Node Name and host name
![Node Name](images/was_profiles/was_profile_node_04.png "Node Name")
* Register the node under running Deployment Manager created in previous step
![Federation](images/was_profiles/was_profile_node_05.png "Federation")
* You can re- use existing certificates Generated for Deployment manager as in this case both servers are running on the same host.
![Certificates 1](images/was_profiles/was_profile_node_06.png "Certificates 1")
* Keep the Imported Certificates Values
![Certificates 2](images/was_profiles/was_profile_node_07.png "Certificates 2")
* Keep proposed Ports
![Ports](images/was_profiles/was_profile_node_08.png "Ports")
* Review your Selections Summary and run the profile Creation
![Ports](images/was_profiles/was_profile_node_09.png "Ports")
* Once the profile is created, You will get oprtunity to display the first step Guide. You can finish the Guide.
![Finish](images/was_profiles/was_profile_dmgr_11.png "Finish")

Now You should see following in the Profile Manager
![Profile Manager](images/was_profiles/was_profile_completed.png "Profile Manager")


### Create Cluster

* Login to your Deployment Manager WAS server Console `https://<your_host>:9043/ibm/console`
* go to `Servers > Clusters > WebSphere application server clusters`
![Create Cluster](images/was_config/was_cluster_01.png "Create Cluster")
* Create  Cluster named ` ActiveVOS_Cluster`
![Cluster Name](images/was_config/was_cluster_02.png "Cluster Name")
* Create  First Cluster Node, `ActiveVOS01`
![Cluster Node](images/was_config/was_cluster_03.png "Cluster Node")
* Add Second Node, `ActiveVOS02`
![Cluster Node](images/was_config/was_cluster_04.png "Cluster Node")
* Review Cluster Summary and finish the cluster guide
![Review](images/was_config/was_cluster_05.png "Review")
* Save Your Changes
![Save](images/was_config/was_cluster_05.png "Save")

Once You save the Cluster you shoul be abe to go to `Servers > Clusters > Cluster topology` and see following topology
![Cluster Topology](images/was_config/was_cluster_topology.png "Topology")


### Configure ActiveVOS Data Sources
Use following steps to create create a data source for a clustered environment
The first part of this task defines a JDBC provider with a cluster scope setting. Be aware that all members of your cluster must run at least Version 6 of WebSphere Application Server to use this scope setting for the cluster. (See Administrative console scope settings for more information about scope settings in general.)
The cluster scope has a precedence over the node and cell scopes. Create a data source for a cluster if you want the data source to:
* Be available for all the members of this cluster to use
* Override any resource factories that have the same JNDI name that is defined within the cell scope

#### Set DRIVER_PATHS
* Open the WAS administrative console.
* Click WebSphere Variables.
* Check if the `ORACLE_JDBC_DRIVER_PATH` variable exists for the Cluster Nodes
* For each node/cluster, create or edit symbolic variable used in the class path of your JDBC provider, and provide a value that is appropriate for the selected node. For example, we placed the oracle jdbc drive under `C:\opt\java\library\jdbc\oracle`
* Apply and change settings after you finished setting the variables

> __NOTE:__ This DRIVER variable must be defined on each node within the cluster.
> List of variables can be quite long, use filtering as shown on following screen shot ![Variables](images/was_config/was_variables01.png "Variables")

#### Register J2C User Credential for Database Authentication
Before We Create the data source, we have to save user credentials which will be used to connect to the ActiveVOS database

* Open the WAS administrative console.
* Click `Security > Global Security`
* Click + to expand `Java Authentication and Authorization Service` menu item
![JAAS](images/was_config/was_security_j2c.png "JASS")
* Create a New J2C Alias
![New Alias](images/was_config/was_security_j2c_01.png "New Alias")
* Create Set Username and password
![Provide Credentials](images/was_config/was_security_j2c_02.png "Provide Credentials")
* Make sure that you save and synchronize changes to the cluster

> __NOTE:__ Node Agent and Cell deployment manager may need to be restarted to apply the changes and make the new credentials alias available to the cluster nodes. Otherwise you may not be able to validate the data source connection.

#### Register JDBC Provider
* Open the WAS administrative console.
* Click `Resources > JDBC Providers` . In the Scope section, note that the default scope setting is at the node level.
* Select the cluster for which you want to define a data source. In our case this is `ActiveVOS_Cluster` which you going to slect in the Scope List.
* Click New to create a new JDBC provider at the cluster level. The class path for your new JDBC provider is already filled in; part of that class path is specified using a symbolic variable, for example: `${ORACLE_JDBC_DRIVER_PATH}/ojdbc6.jar`. Leave it at the default.
* Finish creating the JDBC provider.

#### Create ActiveVOS Data Source
* Open the WAS Administration Console.
* Click `Resources > Data sources`.
* Select the Cluster Scope `ActiveVOS_CLuster`
* Click `New` button to create a new data source
![New Data Source](images/was_config/ae_ds_create_01.png "Optional title")
* Specify DS Name and JNDI Name
![DS Name](images/was_config/ae_ds_create_02.png "Optional title")
* Specify JDBC Provider - In our case we are selection previously created Oracle JDBC Driver
![JDBC Provider](images/was_config/ae_ds_create_03.png "JDBC Provider")
* Specify JDBC URL (it will be different in your environment)
![JDBC URL](images/was_config/ae_ds_create_04.png "JDBC URL")
* Select Security Aliases Previously defined in the Register J2C User Credential for Database Authentication Step
![Security Aliases](images/was_config/ae_ds_create_05.png "Security Aliases")
* Review and finish your setting
![Review DS Settings](images/was_config/ae_ds_create_06.png "Review DS Settings")
* Make sure you save and synchronize your changes to the cluster nodes.
* Test the database connection
![Test Connection](images/was_config/ae_ds_create_07.png "Test Connection")

Data Source Parameters List Summary:

|                           Options                           |                        Values                        |
|-------------------------------------------------------------|------------------------------------------------------|
| Scope                                                       | cells:maw180674Cell01:clusters:ActiveVOS_Cluster     |
| Data source name                                            | ActiveVOS                                            |
| JNDI name                                                   | jdbc/ActiveVOS                                       |
| Select an existing JDBC provider                            | Oracle JDBC Driver                                   |
| Implementation class name                                   | oracle.jdbc.pool.OracleConnectionPoolDataSource      |
| URL                                                         | jdbc:oracle:thin:@localhost:1521:XE                  |
| Data store helper class name                                | com.ibm.websphere.rsadapter.Oracle11gDataStoreHelper |
| Use this data source in container managed persistence (CMP) | true                                                 |
| Component-managed authentication alias                      | maw180674CellManager01/activevosdb                   |
| Mapping-configuration alias                                 | (none)                                               |
| Container-managed authentication alias                      | maw180674CellManager01/activevosdb                   |

### Set up JAAS Application Logins
ActiveVOS cluster implementation on IBM WebSphere uses JMX API _MBeans_. ActiveVOS cluster uses MBeans to to communicate between cluster nodes when it sends status updates, monitors node health, running deployments, migrating proceses from node to node or creationg deployment lock during bpr deployment and in many other scenarios. When WAS global security is turned on the current thread needs to have access to the MBeans. There are two option to setup the security to provide access to the JMX MBeans:

* ActiveVOS Provided User – we will provide a username/password which will be used anytime we need to use the mbean regardless of what the subject was on the executing thread. This user will need monitor rights (if you don’t override the cluster mbean security).
* ActiveVOSIdentityAssertion – re-asserts the current identity this is a workaround to a work manager issue on IBM WebSphere where even when you say to inherit security on work manager setup you need to reassert it in order for the credentials to be processed correctly. When using this by default (if you don't override the cluster mbean security) all abServiceConsumers users must have monitor rights on the server.

We will use the first method
Define JASS Login User __ActiveVOS Provided User__

* Open the WAS administrative console. 
* Click on  `Users and Groups > Manage Users`
![Manage Users](images/was_config/was_jass_user_01.png "Manage Users")
* Add user avmonitor
![Create User](images/was_config/was_jass_user_02.png "Create User")
* Click on  `Users and Groups > Administrative user roles`
![Manage Roles](images/was_config/was_jass_role_01.png "Manage Roles")
* Add avmonitor user to the Monitor Role
![Add Role](images/was_config/was_jass_role_02.png "Add Role")
* Open `Security > Global security > JAAS - Application logins`
![Login Alias](images/was_config/was_jass_alias_00.png "Login Alias")
* Go to JAAS login module section and add new Alias entry 'ActiveVOSProvidedUser'
    * com.activee.rt.websphere.trustvalidation.AeBasicLoginModule
    * Add custom properties for this module to specify
        * username => {user}
        * password => {password}
![Login Alias](images/was_config/was_jass_alias_01.png "Login Alias")
* Save changes

> NOTE You can also optionally add following roles to the  abAdmin, abDeveloper to the avmonitor user but this is only needed if you want to allow this user to login to the ActiveVOS admin console.

__Second method ActiveVOSIdentityAssertion__
* From the Admin console go to Global Security, under JAAS Configurations select "Application login configuration"
* Add new application login for `ActiveBPELIdentityAssertion`
* Go to JAAS login module section and add following entries in following order
    * `com.activee.rt.websphere.trustvalidation.AeIdentityAssertionLoginModule`
    * `com.ibm.wsspi.security.common.auth.module.IdentityAssertionLoginModule`


> __NOTE:__ Activevos does not require XA enabled data source unles Required by the processes that you nay deploy. Regular data source should be sufficient for most of the use cases.

### Install and Configure WAS Web Server Plugins
Web server Plugin is not configured on the IHS Server by Default. WebSphere Customization Toolbox is neded to perform the post-install configuration of the WAS web server plug-in, it contains the configuration tool for the web server plug-in. 

* Run the Customization Toolbox Plug-in Configuration Tool
![Start Toolbox](images/was_config/was_toolbox.png "Start Toolbox")
* Once is the Toolbox Started Add new server Runtime location pointing your Server Location
![Add Plugin](images/was_config/was_plugin_01.png "Add Plugin")
* on the next sceen you will be prompted to speciy your server location
![Server location](images/was_config/was_plugin_02.png "Server Locatiom")
* In the lower section under 'Web Server Plug-in Configurations' click on the create button.
![Add Plugin Configuration](images/was_config/was_plugin_03.png "Add Plugin Configuration")
* You will be prompted to select the web server you wish to configure on the first screen. Choose 'IBM HTTP Server 8.5' and click next.
![Web Server Type](images/was_config/was_plugin_04.png "Web Server type")
* On the next screen point to your IBM HTTP Server configuration file (httpd.conf) and specify the port your web server is going to listen on and click Finish
![Config Location](images/was_config/was_plugin_05.png "Config Location")
* Setup the Administration Server, check the box 'Setup IBM HTTP Server Administration Server' and specify the port. Default is 8008. Click Next. You can also create a user name and password on this screen, or leave it open and configure the authentication later.
![Admin Server](images/was_config/was_plugin_06.png "Admin Server")
* Next sreen will prompty you for optional Windows service Creation. You can keep the default settings and choose the manual startup option which may be more desirable when you install server in your development sandbox environment.
![Admin Server as a Service](images/was_config/was_plugin_07.png "Admin Server as a Service")
* On the Web Server Definition Name screen, you will want to specify your web server name. If you have already created this via WebSphere you will want this name to match what you see under web servers in the WebSphere console. In our case we chose webserver1, If no web server exists in the WebSphere console you can enter another name.
![Web Server Name](images/was_config/was_plugin_08.png "Web Server Name")
* On the 'Configuration Scenario Selection' screen, choose if you are doing a local configuration or a remote. If your Application Server exists on a different machine then your web server you will want to choose remote and enter in the Host Name or IP of the Application Server. For this example our Application server is on the same system so we chose 'Local' and pointed to our Application server directory.
![Config Type](images/was_config/was_plugin_09.png "Config Type")
* On the last screen of the configuration choose your Application Server profile, click Next and review the information then click Configure.
![Config Type](images/was_config/was_plugin_10.png "Config Type")
* Your configuration Wizard screen should now look like you see below. You can close this out now and continue with the last step of the configuration.
* The last step to the profile configuration is to run the script created from the configuration wizard above. It is located in `IBM\WebSphere\Plugins\bin\configure<server_name>.bat` you will get prompt for inputting your WebSphere admin username and password. Once done the output will show 'Configuration save is complete' If you named your web server something different the batch file name will reflect the name you chose and not webserver1.

Example Configure Web Server Output
```
C:\opt\ibm\WebSphere\Plugins\bin>configurewebserver1.bat
WASX7209I: Connected to process "dmgr" on node maw180674CellManager01 using SOAP connector;  The type of process is: DeploymentManager
WASX7303I: The following options are passed to the scripting environment and are available as arguments that are stored in the argv variable: "[webserver1, IHS, C:\\opt\\ibm\\HTTPServer, C:\\opt\\ibm\\HTTPServer\\conf\\httpd.conf, 80, MAP_ALL, C:\\opt\\ibm\\WebSphere\\Plugins, managed, maw180674Node01, new-host-4.home, windows, 8008, admin, admin, IBM HTTP Server V8.5]"

Input parameters:

   Web server name             - webserver1
   Web server type             - IHS
   Web server install location - C:\opt\ibm\HTTPServer
   Web server config location  - C:\opt\ibm\HTTPServer\conf\httpd.conf
   Web server port             - 80
   Map Applications            - MAP_ALL
   Plugin install location     - C:\opt\ibm\WebSphere\Plugins
   Web server node type        - managed
   Web server node name        - maw180674Node01
   IHS Admin port              - 8008
   IHS Admin user ID           - admin
   IHS Admin password          - admin
   IHS service name            - IBM HTTP Server V8.5

Creating the web server definition for webserver1 on node maw180674Node01.
Parameters for administering IHS web server can also be updated using wsadmin script or admin console.
Web server definition for webserver1 is created.

Start computing the plugin properties ID.
Plugin properties ID is computed.

Start updating the plugin install location.
Plugin install location is updated.

Start updating the plugin log file location.
Plugin log file location is updated.

Start updating the RemoteConfigFilename location.
Plugin remote config file location is updated.

Start updating the RemoteKeyRingFileName location.
Plugin remote keyring file location is updated.

Start saving the configuration.

Configuration save is complete.

Computed the list of installed applications.

Processing the application ActiveVOS Central.
Get the current target mapping for the application ActiveVOS Central.
Computed the current target mapping for the application ActiveVOS Central.
Start updating the target mappings for the application ActiveVOS Central.
ADMA5075I: Editing of application ActiveVOS Central started.
ADMA5058I: Application and module versions are validated with versions of deployment targets.
ADMA5005I: The application ActiveVOS Central is configured in the WebSphere Application Server repository.
ADMA5005I: The application ActiveVOS Central is configured in the WebSphere Application Server repository.
ADMA5005I: The application ActiveVOS Central is configured in the WebSphere Application Server repository.
ADMA5005I: The application ActiveVOS Central is configured in the WebSphere Application Server repository.
ADMA5113I: Activation plan created successfully.
ADMA5011I: The cleanup of the temp directory for application ActiveVOS Central is complete.
ADMA5076I: Application ActiveVOS Central edited successfully. The application or its web modules may require a restart when a save is performed.
Target mapping is updated for the application ActiveVOS Central.

Processing the application ActiveVOS Enterprise Server.
Get the current target mapping for the application ActiveVOS Enterprise Server.
Computed the current target mapping for the application ActiveVOS Enterprise Server.
Start updating the target mappings for the application ActiveVOS Enterprise Server.
ADMA5075I: Editing of application ActiveVOS Enterprise Server started.
ADMA5058I: Application and module versions are validated with versions of deployment targets.
ADMA5005I: The application ActiveVOS Enterprise Server is configured in the WebSphere Application Server repository.
ADMA5005I: The application ActiveVOS Enterprise Server is configured in the WebSphere Application Server repository.
ADMA5005I: The application ActiveVOS Enterprise Server is configured in the WebSphere Application Server repository.
ADMA5005I: The application ActiveVOS Enterprise Server is configured in the WebSphere Application Server repository.
ADMA5113I: Activation plan created successfully.
ADMA5011I: The cleanup of the temp directory for application ActiveVOS Enterprise Server is complete.
ADMA5076I: Application ActiveVOS Enterprise Server edited successfully. The application or its web modules may require a restart when a save is performed.
Target mapping is updated for the application ActiveVOS Enterprise Server.

Start saving the configuration.

Configuration save is complete.
```

### Configuring the NodeAgent to start as a Windows Service
> __NOTE:__ these steps does not seem to work right, need to figure out why, I can successfully create the service which actually starts but it is not starting the node manager server.

By default, a Network Deployment installation creates a Windows service for the deployment manager but not the node agent. A Network Deployment application server profile is not fully functional until the NodeAgent for the application server has been started. Starting Node Agent manually is not very desirable. We have the ability to create a Windows Service to automatically start the NodeAgent. 

1. Open a command prompt window
2. Change the current directory to `<instal_root>WebSphere\AppServer\profiles\Node01\bin`
3. Execute the following command to create the NodeAgent service.

> __NOTE:__ you should replace 'Node01' IBM_HOME username and password with your own parameters. Also make sure WASService.exe and WASServiceMsg.dll exist in this directory. 

```batchfile
SETLOCAL
SET IBM_HOME=C:\opt\ibm
SET WAS_HOME=%IBM_HOME%\WebSphere\AppServer
SET PROFILE_PATH=%WAS_HOME%\WebSphere\AppServer\profiles\Node01
SET LOG_ROOT=%PROFILE_PATH%\logs\nodeagent
SET LOG_FILE=%LOG_ROOT%/startServer.log
SET SERVICE_START_TYPE=automatic
SET SERVICE_NAME=nodeAgent
SET STOP_ARGS=-username admin -password admin
WASService -add %SERVICE_NAME% -servername nodeagent -profilePath "%PROFILE_PATH%" -wasHome "%WAS_HOME%" -stopArgs "%STOP_ARGS%" -logfile "%LOG_FILE%" -logRoot "%LOG_ROOT%" -restart true -startType %SERVICE_START_TYPE%
ENDLOCAL
```

EXAMPLE Console Output
```
C:\opt\ibm\WebSphere\AppServer\bin>SETLOCAL
C:\opt\ibm\WebSphere\AppServer\bin>SET IBM_HOME=C:\opt\ibm
C:\opt\ibm\WebSphere\AppServer\bin>SET WAS_HOME=%IBM_HOME%\WebSphere\AppServer
C:\opt\ibm\WebSphere\AppServer\bin>SET PROFILE_PATH=%WAS_HOME%\WebSphere\AppServer\profiles\Node01
C:\opt\ibm\WebSphere\AppServer\bin>SET LOG_ROOT=%PROFILE_PATH%\logs\nodeagent
C:\opt\ibm\WebSphere\AppServer\bin>SET LOG_FILE=%LOG_ROOT%nodeAgentService.log
C:\opt\ibm\WebSphere\AppServer\bin>SET SERVICE_START_TYPE=automatic
C:\opt\ibm\WebSphere\AppServer\bin>SET SERVICE_NAME=nodeAgent
C:\opt\ibm\WebSphere\AppServer\bin>SET STOP_ARGS=-username admin -password admin
C:\opt\ibm\WebSphere\AppServer\bin>WASService -add %SERVICE_NAME% -servername nodeagent -profilePath "%PROFILE_PATH%" -wasHome "%WAS_HOME%" -stopArgs "%STOP_ARGS%" -logfile "%LOG_FILE%" -logRoot "%LOG_ROOT%" -restart true -startType %SERVICE_START_TYPE%
Adding Service: nodeAgent
        Config Root: C:\opt\ibm\WebSphere\AppServer\WebSphere\AppServer\profiles\Node01\config
        Server Name: nodeagent
        Profile Path: C:\opt\ibm\WebSphere\AppServer\WebSphere\AppServer\profiles\Node01
        Was Home: C:\opt\ibm\WebSphere\AppServer\
        Start Args:
        Restart: 1
IBM WebSphere Application Server V8.5 - nodeAgent service successfully added.
```

Start the service
```
WASService -start nodeAgent
```

Stop the service
```
WASService -stop nodeAgent
```

Remove the service
```
WASService -remove nodeAgent
```


## Install ActiveVOS

### Install ActiveVOS Config Deploy Tool
[Download](https://mysupport.informatica.com/downloadsView.jspa) ActiveVOS from Informatica My Support Page. Download a distributions for your target platform 

    Windows    - `ActiveVOSWindows924.zip`
    UNIX/Linux - `ActiveVOSUnix924.zip`

Extract the distribution file to a directory of your choice
Windows Distribution contains two files
* Designer Installer - `ActiveVOS_Designer_windows_9.2.4.exe`
* Server Installer - `ActiveVOS_Server_windows_9.2.4.exe`

Run ActiveVOS_Server_windows_9.2.4.exe it will install ActiveVOS Configuration and Deployment Tool (config_deploy)

![Start Config Deploy](images/config_deploy/config_deploy_01.png "Start Config Deploy")

Select Websphere on the Next Step

![Select Server Type](images/config_deploy/config_deploy_02.png "Select Server Type")

As with Websphere do not use Program Files Default target location. You can use `C:\ActiveVOS\Server` 
We have used `C:\opt\ae\9.2.4\server`

![Select Target Dir](images/config_deploy/config_deploy_03.png "Select Target Dir")

> __NOTE:__ When Installing on Windows 2008 or 2012 Server, make sure that the user running the installation or later run config deploy tool has full permissions to the directory and all its children, otherwise You may have permissions issues when the ActiveVOS EARs and WARs are generated by the config deploy tool.

You can accept creation of the Start Menu shortcuts
![Create Shortcuts](images/config_deploy/config_deploy_04.png "Create Shortcuts")

You will be prompted to open a Quick Start Guide

![Quick Start](images/config_deploy/config_deploy_04.png "Quick Start")

Read the Quick Start Guide. and keep the link for future reference.
Finish the Installer

### Run ActiveVOS Config Deploy Tool
Before you start config Deploy tool, following steps must be completed 
- [Install IBM WebSphere Application Server Network Deployment](#install-ibm-websphere-application-server-network-deployment)
- [Configure IBM WebSphere Network Deployment Components](#configure-ibm-websphere-network-deployment-components)
    - [Create Deployment Manager](#create-deployment-
    - [Create Cluster](#create-cluster)
    - [Create Managed Servers](#create-managed-servers)
    - [Configure ActiveVOS Data Sources](#configure-activevos-data-sources)

Node Agent and and Deployment manager server must be running before you start Config Deploy Tool

__Start Node Agent:__  
go to `<WAS_HOME>\AppServer\profiles\Node01\bin` and run
```batchfile
startNode.bat
```

or start service previously created in the [Configuring the NodeAgent to start as a Windows Service](#configuring-the-nodeagent-to-start-as-a-windows-service)

__Start Deployment Manager for the Cell:__
start service previously created the Profile Manager 
go to `<WAS_HOME>AppServer\profiles\Dmgr01\bin` and run
```batchfile
net start "IBMWAS85Service - <ManagerServerName>"

or  
cd %WAS_HOME%\AppServer\bin
WASService -start <ManagerServerName>
```

> __NOTE:__ In our case the `<ManagerServerNAme> = maw180674CellManager01`

```
C:\opt\ibm\WebSphere\AppServer\bin>WASService manager-start maw180674CellManager01
Starting Service: maw180674CellManager01
Successfully started service.
```

You can also start the service using the `services.msc`

__Run the Config Deploy Tool__ 
> __NOTE:__ The Installation of ActiveVOS can be done using three modes
> 1. gui wizard mode
> 2. console mode
> 3. silent mode

We will use the Wizard Mode this time
AV_HOME is the the directory eher you installed the ActiveVOS Config Deploy Tool in oure case it is `C:\opt\ae\9.2.4\Server`

* go to the <AV_HOME>\server-enterprise\websphere_config\bin
* run `config_deploy.bat`
* First step will propmt yu for INstallation Options, typically you want to keep default settings where all options are checked.
![Install Options](images/config_deploy/config_deploy_was_01_options.png "Install Options")
* On the next step select your ActiveVOS Baxked Database type, in our case it is Oracle.
![DB Type](images/config_deploy/config_deploy_was_02_db_type.png "DB Type")
* On the next step: Accept the default setting for JNDI names of the resources used by the ActiveVOS
![JNDI Names](images/config_deploy/config_deploy_was_03_jndi.png "JNDI NAmes")
* Set the Global security Options. Note that the name of the Security Provider must Match the Alias name specified in the [Set up JAAS Application Logins](#set-up-jaas-application-logins) Step
![Global Security](images/config_deploy/config_deploy_was_04_global_security.png "Global Security")
* Set JAAS Login Options, username and password must match the values that you provided in the  [Set up JAAS Application Logins](#set-up-jaas-application-logins) Step
![JAAS Login](images/config_deploy/config_deploy_was_05_jaas_login.png "JAAS Login")
* Set The Security Configuration options. In or case we are only securing the Admin Console, Note that ActiveVOS Central requires Authentication/Authorization regardless any of these settings.
![Security Configuration](images/config_deploy/config_deploy_was_06_security_configuration.png "Security Configuration")
* You can accept default values on the the Thread pool sizing, but typically in real environments these values should be adjusted for expected volumes of request and estimated concurrency
![Thread Pools 1](images/config_deploy/config_deploy_was_07_thread_pools_1.png "Thread pools 1")
* Accept the provided minimum Thread Pool Size.
![Thread Pools 2](images/config_deploy/config_deploy_was_08_thread_pools_2.png "Thread pools 2")
* YOu can leave the session timeout for ActivevVOS Central at default Value. The ActiveVOS Central Task Service URL must point the Cluster Load Balancer. If you want to use built in WAS SSO or external provider SSO Solution such as Web Seal, Apache CAS You would need to use URl Which point to ActiveVOS Central Certificate Secured Endpoint. See more Details on SSO support in this Presentation http://www.activevos.com/cp/46/ctot-40-single-sign-on-for-accessing-task-lists
![AVC](images/config_deploy/config_deploy_was_09_avcentral_config.png "AVC")
* Select the Deployment Options, the first check-box `Install database schema` should be enabled only the first time you run this wizard against particular app server instance. If you re run the wizards later to change any of the configurations especially when you just need to turn/off/on security, you don't want to re- crate the database schema once the database was already created and initialized or when the db tables were created by the DBA. Note that this option enables the run of the DDL script that creates the database tables and views used by the ActiveVOS. Also note that the user defined later in the database connection parameters must have permissions described in the [Prepare Database for ActiveVOS](#prepare-database-for-activevos) step. If you want to separate owner and connection user of the database you will have to create db tables manually first and unchecked the option `Install database schema`.
![Deployment Options](images/config_deploy/config_deploy_was_10_deployment_options.png "Deployment Options")
* Database COnnection Options are only requested When you select the `Install database schema` options. These are only used to Create Database Schema. IT is assumed that at this point you already defined WAS data Source for ActiveVOS in the WL CLuster as Described in the [Configure ActiveVOS Data Sources](#configure-activevos-data-sources) step of this guide.
![DB Options](images/config_deploy/config_deploy_was_11_db_connection.png "DB Options")
* On the Next step you will be prompted for Details of you WAS Server Parameters which Are used to connect to the WAS server and Deploy ActiveVOS Components
![WAS Options](images/config_deploy/config_deploy_was_11_was_server.png "WAS Options")
* Run the Install, Optionally you can click on the Show Details to monitor the progress of the Installation and server configuration.
![Run Install](images/config_deploy/config_deploy_was_13_run_install_details.png "Run Install")

### Configure Application Security
Login to the WebSphere console and  go to `Applications > Application types > WebSphere enterprise applications > ActiveVOS Enterprise Server`
Look for the Security role to user/group mapping group. Map the existing ActiveVOS security roles to groups. Typically these Groups would be defined in LDAP and mapped to the security roles

You must ensure that WebSphere application security is set up correctly. 
On the WebSphere Console navigation area, select `Security > Secure administration, applications, and infrastructure`. Then select the check-box next to Enable Application Security and select Apply.
![Aplication Security](images/was_config/was_application_security.png "Application Security")

See more at http://infocenter.activevos.com/infocenter/ActiveVOS/v92/index.jsp?topic=/doc.server_userguide/html/SvrUG3-4.html 

### Resources Created by Config Deploy WAS Server
ActiveVOS Deploy Tool will configure additional resources required by ActiveVOS automatically. please review that these resources are created as shown below.
You may need to adjust some of the parameters like connection and thread pool sizing accordingly to your estimated performance requirements or as necessary based on your performance observations and server utilization 

#### Thread Pools
![WMs](images/was_config/was_ae_work_managers.png "WMs")
* Folowing Thread pools Shopuld be Created `Resources > Asynchronous beans > Work managers`
    - ActiveVOS Work Manager
    ![WM](images/was_config/was_ae_work_manager.png "WM")
    - ActiveVOS Enterprise System Work Manager
    ![System WM](images/was_config/was_ae_system_wm.png "System WM")

#### Time Managers
ActiveVOS Timer Manager
Go to `Resources > Asynchronous beans > Timer managers`
![Timer](images/was_config/was_ae_timer_manager.png "Timer")


# Appendices

## Profile Management Tip
The command line tools also the only option when you want remove or augment the profile. The `manageprofiles.[sh|bat]` script can be difficult to use and has many often confusing parameters. You can use manageprofileInteractive as an alternaive. 
The `manageprofileInteractive.zip` file available on the page below contains the executable `manageprofilesInteractive.jar`, and launch scripts `run_manageprofileInteractive.[bat|sh]`.

http://www-01.ibm.com/support/docview.wss?uid=swg21442487

> __NOTE:__ If have a problem to delete the profile using  `/opt/IBM/WebSphere/AppServer/bin/manageprofiles.bat -delete -profileName profile_name` 
> * Make sure that all WAS JVMs are shut down, including node manager.
> * You may need to delete or rename profile_name/configuration directory to successfully delete the profile
> * make sure you clean leftover directories after you deleted the profile 
>   - configuration
>   - logs
>   - logs

Example run of deleteAll script using run_manageprofileInteractive
```
C:\opt\ibm\WebSphere\AppServer\bin>CALL "C:\opt\ibm\WebSphere\AppServer\bin\setupCmdLine.bat"
manageprofilesInteractive-v70 V0.6.6 ~ 2011.05.10/Windows 7

-----------------------------
MANAGEPROFILES - Command Menu
-----------------------------
1  create
2  augment
3  delete
4  unaugment
5  unaugmentAll
6  deleteAll
7  listProfiles
8  listAugments
9  backupProfile
10 restoreProfile
11 getName
12 getPath
13 validateRegistry
14 validateAndUpdateRegistry
15 getDefaultName
16 setDefaultName
17 response
18 help
Select number [press "q" to quit]: 6
deleteAll
-----------------------------
DELETEALL command summary:
-----------------------------
Press "b" to go back and make changes or "c" to continue: c

Press "q" to quit, "r" add to response file, or "c" to run the command: c
-------------------------------------
manageprofiles.bat -deleteAll
Created Command Log in C:/opt/ibm/WebSphere/AppServer/logs/manageprofilesInteractive.log
Execute "deleteAll" command now
Press [c to continue, q to quit]: c
You may check C:/opt/ibm/WebSphere/AppServer/logs/manageprofiles/deleteAll.log for command status.

  INSTCONFSUCCESS: Success: All profiles are deleted.

Elapse time: 4.3055 minutes
Done!
```

## SSL and SSO Configuration Tips 
[Renew certificate in Websphere keystore while retaining same alias](https://enerosweb.wordpress.com/2010/10/12/renew-certificate-in-websphere-keystore-while-retaining-same-alias/)








