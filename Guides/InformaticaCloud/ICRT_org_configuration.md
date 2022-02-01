# ICRT Cloud Org Configuration

<!-- MarkdownTOC -->

- [ICRT Cloud Org Configuration](#icrt-cloud-org-configuration)
- [Environments](#environments)
  - [DEV](#dev)
    - [DEV Agents](#dev-agents)
  - [QA](#qa)
    - [QA Agents](#qa-agents)
  - [PROD](#prod)
    - [Prod Agents](#prod-agents)
- [Directories](#directories)
- [Extension Files and External Libraries](#extension-files-and-external-libraries)
  - [Extensions DEV](#extensions-dev)
    - [Synchronize Agent Config and external libraries to another server](#synchronize-agent-config-and-external-libraries-to-another-server)
  - [Create Data Staging Directories](#create-data-staging-directories)
  - [URN Mappings](#urn-mappings)
    - [Cloud Server DEV](#cloud-server-dev)
      - [Cloud Server QA](#cloud-server-qa)
      - [Cloud Server PROD](#cloud-server-prod)
    - [Agents DEV](#agents-dev)
      - [Agents QA](#agents-qa)
      - [Agents PROD](#agents-prod)
- [Process Engine Alerting](#process-engine-alerting)
  - [QA](#qa-1)
    - [ICRT Email Service](#icrt-email-service)
    - [ICRT Fault Alert Service](#icrt-fault-alert-service)
    - [ICRT Monitoring Alert Service](#icrt-monitoring-alert-service)
  - [ICRT Monitoring Thresholds (Agents Only)](#icrt-monitoring-thresholds-agents-only)
- [ICS Email Notifications](#ics-email-notifications)
  - [Global DEV](#global-dev)
  - [Global QA](#global-qa)
  - [Global PROD](#global-prod)
- [Logging Database](#logging-database)
  - [DEV](#dev-1)
  - [QA](#qa-2)
  - [PROD](#prod-1)
- [Process Engine Configuration Changes](#process-engine-configuration-changes)
- [SAP BAPI Connector Configuration](#sap-bapi-connector-configuration)

<!-- /MarkdownTOC -->

# Environments

Informatica CLoud Org Login URL

| Login             | URL                                          |
|-------------------|----------------------------------------------|
| Common            | https://app.informaticaondemand.com/ma/login |
| Development (SSO) | `Document the SSO URL if applicable`         |
| QA (SSO)          |                                              |
| Prod (SSO)        |                                              |

## DEV

### DEV Agents

| Environment Name               | Host Name |
|--------------------------------|-----------|
| Informatica Cloud Hosted Agent |           |
| NA                             |           |
| -- na_agent_01                 |           |
| EMEA                           |           |
| -- emea_agent_01               |           |
|                                |           |

| Parameter         | Value                                                                       |
|-------------------|-----------------------------------------------------------------------------|
| Console URL       | https://ps1w2-ics.rt.informaticacloud.com/activevos/[ORGID]                 |
| SOAP services URL | https://ps1w2-ics.rt.informaticacloud.com/active-bpel/services/[ORGID]      |
| REST services URL | https://ps1w2-ics.rt.informaticacloud.com/active-bpel/services/REST/[ORGID] |

## QA

| Parameter         | Value                                                                       |
|-------------------|-----------------------------------------------------------------------------|
| Console URL       | https://ps1w2-ics.rt.informaticacloud.com/activevos/[ORGID]                 |
| SOAP services URL | https://ps1w2-ics.rt.informaticacloud.com/active-bpel/services/[ORGID]      |
| REST services URL | https://ps1w2-ics.rt.informaticacloud.com/active-bpel/services/REST/[ORGID] |

### QA Agents

Example QA Orgs Layout

| Environment Name               | Host Name |
|--------------------------------|-----------|
| Informatica Cloud Hosted Agent |           |
| NA (2)                         |           |
| -- na_agent_01                 |           |
| -- na_agent_02                 |           |
| EU  (2)                        |           |
| -- eu_agent_01                 |           |
| -- eu_agent_02                 |           |

## PROD

| Parameter         | Value                                       |
| ----------------- | ------------------------------------------- |
| Console URL       | [CAI Console CLoud][cai-console-cloud]      |
| SOAP services URL | [CAI Services URL][cai-services-cloud]      |
| REST services URL | [CAI REST Services URL][cai-services-cloud] |

### Prod Agents

Example PROD orgs layout

| Environment Name               | Host Name |
|--------------------------------|-----------|
| Informatica Cloud Hosted Agent |           |
| NA (2)                         |           |
| -- na_agent_01                 |           |
| -- na_agent_02                 |           |
| NA_DR (2)                      |           |
| -- na_agent_dr_01              |           |
| -- na_agent_dr_02              |           |
| EMEA (2)                       |           |
| -- eu_agent_01                 |           |
| -- eu_agent_01                 |           |
| EMEA_DR (2)                    |           |
| eu_agent_dr_01                 |           |
| eu_agent_dr_02                 |           |

# Directories

| Directory                   | Description                |
|-----------------------------|----------------------------|
| Agent installation location | /opt/informatica/infaagent |
| Root for staging Data       | /nfs/ipaas/data            |

Modified added custom files: that needs to be synchronized to Recovery Sites

# Extension Files and External Libraries

Document extensions and external libraries deployed to your agents

## Extensions DEV

```text
/opt/informatica/infaagent/apps/process-engine/ext
├── libsapjco3.so
├── ojdbc6_g.jar
└── sapjco3.jar

/opt/informatica/infaagent/apps/Data_Integration_Server/ext
└── deploy_to_main
    └── bin
        ├── rdtm
        │   ├── libicudata.so.34
        │   ├── libicudecnumber.so
        │   ├── libicui18n.so.34
        │   ├── libicuuc.so.34
        │   ├── libsapnwrfc.so
        │   ├── libsapucum.so
        │   └── sapnwrfc.ini
        └── rdtm-extra
            └── tpl
                └── sap
                    ├── libsapjco3.so
                    └── sapjco3.jar
```

### Synchronize Agent Config and external libraries to another server

Following are examples how to move SAP and other connector external dependencies and configuration to another server or download those to your machine

```shell

# FROM QA and PROD Instances
# CD to Agent home directory on source system
cd /opt/informatica/infaagent
rsync -avzP --relative apps/process-engine/ext user@target_system:/opt/informatica/infaagent
rsync -avzP --relative apps/Data_Integration_Server/ext user@target_system:/opt/informatica/infaagent

## download the files to local machine from server to current directory (full relative path to files will be preserved)
rsync -avzP --relative user@host:/opt/informatica/infaagent apps/process-engine/ext .
rsync -avzP --relative user@host:/opt/informatica/infaagent/apps/Data_Integration_Server/ext .
```

## Create Data Staging Directories

Following Script shows creation of staging data directory on NFS shared drive for agent in the group
The directories should be owned by ipaas user

Examples:

```shell
mkdir -p /nfs/ipaas/data/salesforce
mkdir -p /nfs/ipaas/data/stackline
mkdir -p /nfs/ipaas/data/hadoop
```

## URN Mappings

### Cloud Server DEV

| URN                         | VALUE                                     | Comment                                                              |
|-----------------------------|-------------------------------------------|----------------------------------------------------------------------|
| ae:agent-response-mechanism | async                                     | This optional parameter enables asynchronous communication to agents |
| urn:environment:name        | Cloud Server DEV                          | Defines Environment name for Reporting                               |
| ae:base-uri                 | https://ps1w2-ics.rt.informaticacloud.com | Base URL of informatica cloud Pod                                    |

#### Cloud Server QA

| URN                                       | VALUE                                          | Comment                                                              |
| ----------------------------------------- | ---------------------------------------------- | -------------------------------------------------------------------- |
| ae:agent-response-mechanism               | async                                          | This optional parameter enables asynchronous communication to agents |
| urn:environment:name                      | Cloud Server QA                                | Defines Environment name for Reporting                               |
| ae:base-uri                               | `https://ps1w2-ics.rt.informaticacloud.com`    | Base URL of informatica cloud Pod                                    |
| urn:environment:orgid                     | \<ORGID\> i.e. adoG8hzbqeIgKuWL6vhWQJ          | Org. ID                                                              |
| urn:ic:faultAlerts:configuration:provider | gitlab                                         | Fault alert service Configuration Provider                           |
| urn:ic:faultAlerts:configuration:url      | https://gitlab.com/api/v4/snippets/1902616/raw | Fault Alert Service Config URL                                       |
| urn:ic:faultAlerts:falback:email          | dl_alerts@acme.com                             | Fault alert Fallback Email                                           |

#### Cloud Server PROD

| URN                                       | VALUE                                          | Comment                                                              |
| ----------------------------------------- | ---------------------------------------------- | -------------------------------------------------------------------- |
| ae:agent-response-mechanism               | async                                          | This optional parameter enables asynchronous communication to agents |
| urn:environment:name                      | Cloud Server PROD                              | Defines Environment name for Reporting                               |
| ae:base-uri                               | `https://ps1w2-ics.rt.informaticacloud.com`    | Base URL of informatica cloud Pod                                    |
| urn:environment:orgid                     | \<ORGID\> i.e. adoG8hzbqeIgKuWL6vhWQJ          | Org. ID                                                              |
| urn:ic:faultAlerts:configuration:provider | gitlab                                         | Fault alert service Configuration Provider                           |
| urn:ic:faultAlerts:configuration:url      | https://gitlab.com/api/v4/snippets/1902616/raw | Fault Alert Service Config URL                                       |
| urn:ic:faultAlerts:falback:email          | dl_alerts@acme.com                             | Fault alert Fallback Email                                           |

### Agents DEV

| URN                                       | VALUE                                           | Comment                                                 |
| ----------------------------------------- | ----------------------------------------------- | ------------------------------------------------------- |
| ae:internal-reporting                     | http://localhost:8080/activevos/internalreports | System Mapping, do not mot modify unless instructed     |
| ae:task-inbox                             | http://localhost:8080/activevos-central/avc     | System Mapping, do not mot modify unless instructed     |
| ae:base-uri                               | `https://ps1w2-ics.rt.informaticacloud.com`     | Base URL of informatica cloud Pod                       |
| java:comp/env/jdbc/ActiveVOS              | java:comp/env/jdbc/ActiveVOS                    | System Mapping, do not mot modify unless instructed     |
| urn:aeHostEnvironmentRuntime              | avHostEnvironmentRuntimeAccess                  | System Mapping, do not mot modify unless instructed     |
| urn:environment:name                      | <AGENT_NAME>  i.e.: go1_agent_01                | must match the Actual agent name in the Org. definition |
| urn:environment:orgid                     | \<ORGID\> i.e. adoG8hzbqeIgKuWL6vhWQJ           | Org. ID                                                 |
| urn:ic:faultAlerts:configuration:provider | gitlab                                          | Fault alert service Configuration Provider              |
| urn:ic:faultAlerts:configuration:url      | https://gitlab.com/api/v4/snippets/1902616/raw  | Fault Alert Service Config URL                          |
| urn:ic:faultAlerts:falback:email          | dl_alerts@acme.com                              | Fault alert Fallback Email                              |
| urn:acme:api                              | https://api.acme.com:8443/api/entiy/v1          | Example API URL                                         |
| urn:acme:api:authorization                | encrypted:wn+c1v7mfSucng5qxvaWCIrMvi49lDyq      | Example API credentials Encrypted                       |
| urn:knox:api:staging:dir                  | /nfs/ipaas/data/acme/integration_name           | Example configurable path to Staging directory          |

#### Agents QA

| URN                                       | VALUE                                           | Comment                                                 |
| ----------------------------------------- | ----------------------------------------------- | ------------------------------------------------------- |
| ae:internal-reporting                     | http://localhost:8080/activevos/internalreports | System Mapping, do not mot modify unless instructed     |
| ae:task-inbox                             | http://localhost:8080/activevos-central/avc     | System Mapping, do not mot modify unless instructed     |
| ae:base-uri                               | `https://ps1w2-ics.rt.informaticacloud.com`     | Base URL of informatica cloud Pod                       |
| java:comp/env/jdbc/ActiveVOS              | java:comp/env/jdbc/ActiveVOS                    | System Mapping, do not mot modify unless instructed     |
| urn:aeHostEnvironmentRuntime              | avHostEnvironmentRuntimeAccess                  | System Mapping, do not mot modify unless instructed     |
| urn:environment:name                      | \<AGENT_NAME\>  i.e.: na_agent_01               | must match the Actual agent name in the Org. definition |
| urn:environment:orgid                     | \<ORGID\> i.e. adoG8hzbqeIgKuWL6vhWQJ           | Org. ID                                                 |
| urn:ic:faultAlerts:configuration:provider | gitlab                                          | Fault alert service Configuration Provider              |
| urn:ic:faultAlerts:configuration:url      | https://gitlab.com/api/v4/snippets/1902616/raw  | Fault Alert Service Config URL                          |
| urn:ic:faultAlerts:falback:email          | dl_alerts@acme.com                              | Fault alert Fallback Email                              |
| urn:acme:api                              | https://api.acme.com:8443/api/entiy/v1          | Example API URL                                         |
| urn:acme:api:authorization                | encrypted:wn+c1v7mfSucng5qxvaWCIrMvi49lDyq      | Example API credentials Encrypted                       |
| urn:knox:api:staging:dir                  | /nfs/ipaas/data/acme/integration_name           | Example configurable path to Staging directory          |

#### Agents PROD

| URN                                       | VALUE                                           | Comment                                                 |
| ----------------------------------------- | ----------------------------------------------- | ------------------------------------------------------- |
| ae:internal-reporting                     | http://localhost:8080/activevos/internalreports | System Mapping, do not mot modify unless instructed     |
| ae:task-inbox                             | http://localhost:8080/activevos-central/avc     | System Mapping, do not mot modify unless instructed     |
| ae:base-uri                               | `https://ps1w2-ics.rt.informaticacloud.com`     | Base URL of informatica cloud Pod                       |
| java:comp/env/jdbc/ActiveVOS              | java:comp/env/jdbc/ActiveVOS                    | System Mapping, do not mot modify unless instructed     |
| urn:aeHostEnvironmentRuntime              | avHostEnvironmentRuntimeAccess                  | System Mapping, do not mot modify unless instructed     |
| urn:environment:name                      | \<AGENT_NAME\>  i.e.: na_agent_01               | must match the Actual agent name in the Org. definition |
| urn:environment:orgid                     | \<ORGID\> i.e. adoG8hzbqeIgKuWL6vhWQJ           | Org. ID                                                 |
| urn:ic:faultAlerts:configuration:provider | gitlab                                          | Fault alert service Configuration Provider              |
| urn:ic:faultAlerts:configuration:url      | https://gitlab.com/api/v4/snippets/1902616/raw  | Fault Alert Service Config URL                          |
| urn:ic:faultAlerts:falback:email          | dl_alerts@acme.com                              | Fault alert Fallback Email                              |
| urn:acme:api                              | https://api.acme.com:8443/api/entiy/v1          | Example API URL                                         |
| urn:acme:api:authorization                | encrypted:wn+c1v7mfSucng5qxvaWCIrMvi49lDyq      | Example API credentials Encrypted                       |
| urn:knox:api:staging:dir                  | /nfs/ipaas/data/acme/integration_name           | Example configurable path to Staging directory          |

# Process Engine Alerting

## QA

### ICRT Email Service

| Parameter    | Value                |
|--------------|----------------------|
| Enable       | true                 |
| Host         | smtp.acme.com        |
| Port         | 25                   |
| From Address | Corresponding to env |
| Username     |                      |
| Security     | None                 |

### ICRT Fault Alert Service

| Parameter             | Value                |
|-----------------------|----------------------|
| Enable Alert Service: | Yes                  |
| Email for Alerts:     | Corresponding env DL |
| Action:               | Send Email           |
| Service:              | N/A                  |

### ICRT Monitoring Alert Service

| Parameter             | Value |
|-----------------------|-------|
| Enable Alert Service: | Yes   |

## ICRT Monitoring Thresholds (Agents Only)

see:
[Monitoring](https://network.informatica.com/onlinehelp/IICS/prod/CAI/en/index.htm#page/cai-aae-monitor/Monitors.html)

| Property to Monitor                       | Level     | Statistic | OP | Value |
|-------------------------------------------|-----------|-----------|----|-------|
| Dispatch Service message rejected (count) | Warning   | Count     | >= | 1     |
| Faulted\Faulting processes (count)        | Warning   | Count     | >= | 50    |
| Process count exceeded (count)            | Warning   | Count     | >= | 1     |
| Time to obtain plan (ms)                  | Warning   | Average   | >= | 5000  |
| Time to save process (ms)                 | Error     | Average   | >= | 5000  |
| Slow XQuery expressions (count)           | Statistic | Count     | >= | 1     |
| Critical storage exceptions (count)       | Count     | Count     | >= | 1     |
| Work manager work start delay (ms)        | Count     | Average   | >= | 5000  |
| Time to Execute XQuery (ms)               | Warning   | Max       | >= | 10000 |

# ICS Email Notifications

## Global DEV

| Error Level | Emails      |
|-------------|-------------|
| Success     | `<fill-in>` |
| Warning     | `<fill-in>` |
| Error       | `<fill-in>` |

## Global QA

| Error Level | Emails      |
|-------------|-------------|
| Success     | `<fill-in>` |
| Warning     | `<fill-in>` |
| Error       | `<fill-in>` |

## Global PROD

| Error Level | Emails      |
|-------------|-------------|
| Success     | `<fill-in>` |
| Warning     | `<fill-in>` |
| Error       | `<fill-in>` |

# Logging Database

## DEV

| Parameter                | Value                                              | Comment                                                                                  |
|--------------------------|----------------------------------------------------|------------------------------------------------------------------------------------------|
| JDBC Connection URL      | jdbc:oracle:thin:@hostname:SID                     |                                                                                          |
| JDBC Jar Directory       | /opt/informatica/infaagent/apps/process-engine/ext |                                                                                          |
| JDBC Driver Class Name   | oracle.jdbc.OracleDriver                           |                                                                                          |
| Schema                   |                                                    |                                                                                          |
| Username                 |                                                    |                                                                                          |
| Password                 |                                                    |                                                                                          |
| Object Filter            |                                                    | Comma separated list of object names.                                                    |
| TimeZone                 | Default                                            | Database timezone. Use this property if DB and Agent are in different timezones          |
| __Read Attributes__      |                                                    |                                                                                          |
| Isolation Level          | None                                               | Specifies the isolation level while reading from source object.                          |
| Override Isolation Level | No                                                 | Yes/No Specifies if the task should proceed if a non-supported isolation level is chosen |
| __Write Attributes__     |                                                    |                                                                                          |
| Number of retries        | 5                                                  | Specifies the number of retries for a closed connection                                  |
| Retry wait period        | 3                                                  | Specifies the waiting time period in seconds before retrying                             |

## QA

| Parameter                | Value                                              | Comment                                                                                  |
|--------------------------|----------------------------------------------------|------------------------------------------------------------------------------------------|
| JDBC Connection URL      | jdbc:oracle:thin:@hostname:SID                     |                                                                                          |
| JDBC Jar Directory       | /opt/informatica/infaagent/apps/process-engine/ext |                                                                                          |
| JDBC Driver Class Name   | oracle.jdbc.OracleDriver                           |                                                                                          |
| Schema                   |                                                    |                                                                                          |
| Username                 |                                                    |                                                                                          |
| Password                 |                                                    |                                                                                          |
| Object Filter            |                                                    | Comma separated list of object names.                                                    |
| TimeZone                 | Default                                            | Database timezone. Use this property if DB and Agent are in different timezones          |
| __Read Attributes__      |                                                    |                                                                                          |
| Isolation Level          | None                                               | Specifies the isolation level while reading from source object.                          |
| Override Isolation Level | No                                                 | Yes/No Specifies if the task should proceed if a non-supported isolation level is chosen |
| __Write Attributes__     |                                                    |                                                                                          |
| Number of retries        | 5                                                  | Specifies the number of retries for a closed connection                                  |
| Retry wait period        | 3                                                  | Specifies the waiting time period in seconds before retrying                             |

## PROD

| Parameter                | Value                                              | Comment                                                                                  |
|--------------------------|----------------------------------------------------|------------------------------------------------------------------------------------------|
| JDBC Connection URL      | jdbc:oracle:thin:@hostname:SID                     |                                                                                          |
| JDBC Jar Directory       | /opt/informatica/infaagent/apps/process-engine/ext |                                                                                          |
| JDBC Driver Class Name   | oracle.jdbc.OracleDriver                           |                                                                                          |
| Schema                   |                                                    |                                                                                          |
| Username                 |                                                    |                                                                                          |
| Password                 |                                                    |                                                                                          |
| Object Filter            |                                                    | Comma separated list of object names.                                                    |
| TimeZone                 | Default                                            | Database timezone. Use this property if DB and Agent are in different timezones          |
| __Read Attributes__      |                                                    |                                                                                          |
| Isolation Level          | None                                               | Specifies the isolation level while reading from source object.                          |
| Override Isolation Level | No                                                 | Yes No Specifies if the task should proceed if a non-supported isolation level is chosen |
| __Write Attributes__     |                                                    |                                                                                          |
| Number of retries        | 5                                                  | Specifies the number of retries for a closed connection                                  |
| Retry wait period        | 3                                                  | Specifies the waiting time period in seconds before retrying                             |

# Process Engine Configuration Changes

| Configuration Parameter             | Where                                                                                    | Default Value  | Mondelez Value    |
| ----------------------------------- | ---------------------------------------------------------------------------------------- | -------------- | ----------------- |
| JVM Memory Parameters "min-heap"    | Administration/Configure/RuntimeEnvironments/Agent/Process Server/JVM                    | '512M'         | '1G'              |
| JVM Memory Parameters "max-heap"    | Administration/Configure/RuntimeEnvironments/Agent/Process Server/JVM                    | '1536M'        | '24G'             |
| Message size limit                  | Application Integration Console/Server Configuration/Agent/Server Settings               | 5242880 (5 MB) | 157286400(150 MB) |
| Message with attachments size limit | Application Integration Console/Server Configuration/Agent/Server Settings               | 5242880 (5 MB) | 157286400(150 MB) |
| Contribution Cache                  | Application Integration Console/Server Configuration/Agent/Server Settings               | 100            | 200               |
| Deployment Plan Cache:              | Application Integration Console/Server Configuration/Agent/Server Settings               | 100            | 200               |
| Shell Service                       | Application Integration Console/Server Configuration/Agent/System Services/Shell Service | disabled       | enabled           |
| Email Service                       | Application Integration Console/Server Configuration/Agent/System Services/Email         | disabled       | enabled           |

# SAP BAPI Connector Configuration

To support SAP Bapi Connector SAP Client libraries must be placed to corresponding extension directories under the secure agent as described in the [Extension Files and External Libraries](#extension-files-and-external-libraries)

In addition the Secure Agent Classpath must be updated

`CLoud Administration Console > Data Integration Server > Tomcat JRE/`

```text
JAVA_LIBS
../bin/rdtm-extra/tpl/sap/sapjco3.jar:../bin/rdtm/javalib/sap/sap-adapter-common.jar
```

[cai-console-cloud]: https://na1.ai.dm-us.informaticacloud.com/activevos-central/projres/apps/app-integration/integrationConsole/index.html#/main/processlist/cloud
[cai-services-cloud]: https://na1.ai.dm-us.informaticacloud.com/active-bpel/services/adoG8hzbqeIgKuWL6vhWQJ
[cai-rest-cloud]: https://na1.ai.dm-us.informaticacloud.com/active-bpel/services/REST/adoG8hzbqeIgKuWL6vhWQJ
