# IICS Disaster Recovery - Informatica Cloud

<!-- MarkdownTOC -->

- [IICS Disaster Recovery - Informatica Cloud](#iics-disaster-recovery---informatica-cloud)
- [Informatica Cloud Architecture](#informatica-cloud-architecture)
  - [Informatica Cloud Components](#informatica-cloud-components)
  - [Informatica Cloud Secure Agent](#informatica-cloud-secure-agent)
  - [Cloud Integration Hub](#cloud-integration-hub)
  - [Informatica Cloud Repository](#informatica-cloud-repository)
  - [Informatica Cloud Security](#informatica-cloud-security)
- [Informatica Cloud Disaster Recovery](#informatica-cloud-disaster-recovery)
  - [Informatica Cloud Components](#informatica-cloud-components-1)
  - [Informatica Cloud Secure Agent](#informatica-cloud-secure-agent-1)
    - [Example Regional Layout With "Hot" Standby](#example-regional-layout-with-hot-standby)
    - [Example Regional Layout With "Cold" Standby](#example-regional-layout-with-cold-standby)
    - [Data Integration Service (CDI)](#data-integration-service-cdi)
    - [Informatica Cloud Real Time (CAI)](#informatica-cloud-real-time-cai)
      - [Outage of the Single Agent Primary group](#outage-of-the-single-agent-primary-group)
      - [Full Failure of a Primary Site](#full-failure-of-a-primary-site)

<!-- /MarkdownTOC -->

# Informatica Cloud Architecture

Informatica Cloud is an on-demand subscription service that provides data integration in the cloud. Informatica Cloud includes direct connectivity to cloud applications, on-premise applications, and databases.

## Informatica Cloud Components

A multi-tenant cloud based batch and real-time integration platform that combines application and data integration and features pre-built connectors to cloud, on premise, mobile, and social data sources, as well as cloud Hosted Secure Agents to run Data Integration tasks in the cloud, Cloud Integration Hub and Secure Agents.

## Informatica Cloud Secure Agent

A component of Informatica Cloud installed on a Windows or Linux machine either inside or outside your company firewall that runs all tasks and can provide firewall access between the hosting facility and your organization or direct connectivity between two cloud applications. The Secure Agent is installed on a machine with an Internet access. Secure Agent machines require access to the Informatica Cloud service as well as the sources and targets that you want to connect to. When the Secure Agent runs a task, it connects to the Informatica Cloud repository to access task details, connects directly and securely to sources and targets, transfers data between sources and targets, and performs any additional task requirements. An organization can use any licensed number Secure Agents to run jobs.

## Cloud Integration Hub

Cloud Integration Hub launched in 2016, now includes out-of-the-box features for Salesforce users to simplify and speed up Salesforce integration.  With new Cloud Integration Hub Salesforce Accelerator, users can automatically generate the Salesforce entities that are required to connect Salesforce to Cloud Integration Hub, so users can publish data once and consume data from multiple subscribing applications.

## Informatica Cloud Repository

Securely stores connection information, organization and task metadata, and any additional metadata created by users. An Informatica Cloud connection is usually stored in the repository, but a user can optionally choose to have credentials stored locally with the Secure Agent instead.

## Informatica Cloud Security

Informatica Cloud uses 128-bit Secure Sockets Layer (SSL) technology to
protect data. It uses authentication and encryption to ensure that data is secure and available only to users within the organization. You can find out more about security http://trust.informaticacloud.com/security

# Informatica Cloud Disaster Recovery

## Informatica Cloud Components

Informatica Cloud Components are managed and operated by Informatica as a hosted multi-tenant system. Informatica takes necessary steps to maintain service availability, disaster recovery in accordance with industry practices.
Informatica Cloud Hosted Components take care of High availability and disaster recovery procedures which should be transparent to IICS IPaaS Users.

Secure Agents are the components that are hosted and managed by the Customers either on premise or in the cloud hosted environments.

Informatica Cloud System Status can be checked at the
http://trust.informaticacloud.com/status

## Informatica Cloud Secure Agent

Informatica Cloud Secure Agent is composed of several Components

- Agent core - Manages agent runtime, agent and  its components updates and configuration managed from the Cloud Administration console.
- CDI (Cloud Data Integration Integration Service) - provides technology based on ETL and large amount of connectors, DAta Quality and range of Data integration use cases
- CAI (Cloud Application Integration) - formerly known as ICRT (Informatica Cloud Real Time) is an integration component responsible for event-driven Application Integration utilizing Process Engine (BPM) technology
- Other Optional Components depending on the licenses and configuration of the org

Each component of the system has its own characteristics and specific procedures for disaster recovery

Integration tasks can run on Secure Agent groups or the Hosted Agent. Download Secure Agents and group them for load balancing and high availability.
When you add/register new secure agent to your org it will default to own agent Group and use Host name as the agent name.

|        Environment Name        | Host Name |
|--------------------------------|-----------|
| Informatica Cloud Hosted Agent |           |
| agent1 (1)                     |           |
| -- agent1                      | agent1    |
| iclab  (1)                     |           |
| -- iclab                       | iclab     |

Agents can be used separately or put into groups which can be used to execute integration tasks on agent grouped based on regions or functional requirements.

It is practical to rename your groups and agents with logical names rather than using physical host names names.
Agents can be then migrated to different host and environment migrations from DEV to QA to PROD will be also easier as they will not require renaming of the references used in the design artifacts such as connections and processes.

### Example Regional Layout With "Hot" Standby

In this configuration all groups and agents are running and receiving updates all the time, the fail-over is facilitated by renaming agent group when certain data center fails

|        Environment Name        | Host Name |    Site   |
|--------------------------------|-----------|-----------|
| Informatica Cloud Hosted Agent |           |           |
| NA (2)                         |           |           |
| -- na_agent_01                 |           | Primary   |
| -- na_agent_02                 |           | Primary   |
| NA_DR (2)                      |           |           |
| -- na_agent_dr_01              |           | Secondary |
| -- na_agent_dr_02              |           | Secondary |
| EU  (2)                        |           |           |
| -- eu_agent_01_P               |           | Primary   |
| -- eu_agent_02_P               |           | Primary   |
| EU_DR (2)                      |           |           |
| -- eu_agent_dr_01              |           | Secondary |
| -- eu_agent_dr_02              |           | Secondary |

### Example Regional Layout With "Cold" Standby

In this configuration all agents are hosted on virtualized systems
where the VM images are backed up and snapshots taken on regular basis.
The full data center structure is replicated on disaster recovery data center
when main Site fails the VMs are spin up in backup data center.

|        Environment Name        | Host Name |   Site  |
|--------------------------------|-----------|---------|
| Informatica Cloud Hosted Agent |           |         |
| NA (2)                         |           |         |
| -- na_agent_01                 |           | Primary |
| -- na_agent_02                 |           | Primary |
| EU  (2)                        |           |         |
| -- eu_agent_01                 |           | Primary |
| -- eu_agent_02                 |           | Primary |

Above table describes the Secure Agent Layout based on the Regional groups
Data integration tasks can be configured to run on specific group of agent or individual agent if the agent is not a part of the group.
For disaster recover would need to create an agent group that contains both primary and the backup site. Agents will be configured and installed all all the Sites following the same installation procedures and configuration steps.

To ensure consistency any configuration changes that are not managed from the cloud would have to be synchronized from the primary to secondary site.
We will discuss those scenarios.

### Data Integration Service (CDI)

Data integration Service configuration and The metadata for tasks executed by the Data Integration Service is stored in the cloud so when the task is schedule on the Agent the Metadata and task definitions will be retrieved from the Informatica Cloud Repository and thus the recovery of such components is not necessary.

There is a set of configuration that reside only on agent and thus has to managed and synchronized from the Primary site to Secondary Recovery Site.

These are:

- External libraries used by connectors such as SAP connector
    these will be located in the `$agent_home/apps/Data_Integration_Server/ext/`
- Some Connector Configurations - certain connector can be customized or require additional configuration which may be located under a connector directory

Files and changes to the above files must be synchronized between environments to ensure correct system operation once the disaster recovery migration is required.

This synchronization can be done using simple `cron` triggered shell script with `rsync` or some other tool suitable for synchronization

### Informatica Cloud Real Time (CAI)

ICRT is a process engine that runs in a separate Tomcat container, to be able to execute all kinds of integration processes, the metadata and process instance data are stored in a local PostgreSQL database installed and managed by the Secure Agents Core Service. This database persists the process metadata and runtime data. The Process engine can load balance task executed from the cloud process but certain tasks can target individual Agent instance even when the agent is a member of the agent group. This provides flexibility in the way Precess developers design their integration and orchestration processes as well ass allows distribution of load across the agent group nodes.

The ICRT Agent Group can be set in two modes

- Simple load balancing of stateless services where the precesses are started and executed in round-robin fashion on corresponding group nodes. In this scenario each agent has its own independent database but it allows to load balance only stateless processes while stateful processes must target only single node.

- Clustered Deployment - process engines on individual agents in the group are configured ins such way that they use the same instance of PostgreSQL DB where one of the agents is a dedicated Master, this master agent system becomes single point of failure in such configuration. ICRT currently does not support use of externally provided database to provide a storage for Process Engine neither high availability clustered PostgreSQL Configuration option

Typical Data Integration needs do not include stateful processes so the process engine can be configured as described in the first option. this makes disaster recovery similar to ICS component only with an addition of couple manual steps that needs to performed in the Cloud Administration Console

ICRT also contains certain files which are only managed locally and needs to be kept in sync in all agent instances these include

- Third Party JDBC Drivers (located at `agent_home/apps/process-engine/ext`)
- Libraries and External jar files needed by the connectors (located at `agent_home/apps/process-engine/ext`)
- Custom Keystores needed for SSL/TLS connection and two way ssl (located at `agent_home/apps/process-engine/ext` or other  custom location)

Generally `agent_home/apps/process-engine/ext` is directory protected by the Agent upgrades and should have mostly the same content across agent in the group so it should be safe to synchronize it across the agent instances

#### Outage of the Single Agent Primary group

|        Environment Name        | Host Name |    Site   | Status |
|--------------------------------|-----------|-----------|--------|
| Informatica Cloud Hosted Agent |           |           |        |
| NA (2)                         |           |           |        |
| -- na_agent_01                 |           | Primary   | Down   |
| -- na_agent_02                 |           | Primary   | Up     |
| NA_DR (2)                      |           |           |        |
| -- na_agent_dr_01              |           | Secondary | Up     |
| -- na_agent_dr_02              |           | Secondary | Up     |

What will happen?

- newly executed tasks will be dispatched and executed on `na_agent_01`
- the performance might be slower as the agent may run more tasks than when multiple nodes are available

- tasks that were running during crash or outage of the site failed and won't fail over to other agent node. They will be reported as failed and the email on failures will be triggered.

What needs to be done?

- check which components are up and running
- identify root cause
- restart agent
- restore operation of the failed agent
    - In case of complete system failure system image to last know restore point

#### Full Failure of a Primary Site

|        Environment Name        | Host Name |    Site   | Status |
|--------------------------------|-----------|-----------|--------|
| Informatica Cloud Hosted Agent |           |           |        |
| NA (2)                         |           |           |        |
| -- na_agent_01_P               |           | Primary   | Down   |
| -- na_agent_02_P               |           | Primary   | Down   |
| NA_DR (2)                      |           |           |        |
| -- na_agent_dr_01              |           | Secondary | Up     |
| -- na_agent_dr_02              |           | Secondary | Up     |

What will happen?

- Local on premise systems impacted
- Integrations will not be able to run
- Errors will be reported by Informatica CLoud
- Processes Executed on the Primary site will not be available on recovery site
- Newly Instantiated processes will run on the restored agent group

What needs to be done?

- check which components are up and running
- identify root cause
- shutdown primary Site Agents if still running
- Fail over all dependent systems that integrations use
- Ensure that the local files needed by ICRT and ICS are up to date
- Move DR Agents in the Cloud Admin Console from NA_DR group to NA Primary group
- Re-publish ICRT Designs to ensure consistency

> NOTE : all scenarios assume that Shared file systems used by the Integration to stage data locally will be continuously synchronized between the sites
