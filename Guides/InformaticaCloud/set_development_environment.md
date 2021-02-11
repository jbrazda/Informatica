# Set Development Environment for IPD Development

<!-- MarkdownTOC -->

- [Set Development Environment for IPD Development](#set-development-environment-for-ipd-development)
- [Install Informatica Tools](#install-informatica-tools)
  - [Process Developer](#process-developer)
- [Other Recommended Tools](#other-recommended-tools)
  - [Developer Text Editor](#developer-text-editor)
  - [Git Client](#git-client)
  - [Apache Ant](#apache-ant)
  - [Java JDK](#java-jdk)
  - [After Installation of the tools (your first Login to the Maintenance Machine)](#after-installation-of-the-tools-your-first-login-to-the-maintenance-machine)
  - [Setup SSH key](#setup-ssh-key)
  - [Setup your Git Client](#setup-your-git-client)
- [Recommended VS Code plugins](#recommended-vs-code-plugins)

<!-- /MarkdownTOC -->

This guide is set of recommendations for tools and software to use for

# Install Informatica Tools

## Process Developer

Eclipse-based IDE that developers can download to develop processes and prepare to deploy them using the Process Console.

- [Download Informatica Cloud Process Developer (Microsoft Windows)](http://doc.rt.informaticacloud.com/cpd/Cloud_Process_Developer_windows.zip)
- [Download Informatica Cloud Process Developer Eclipse Plug-ins](http://doc.rt.informaticacloud.com/cpd/Cloud_Process_Developer_plugins.zip)

> The windows Process Developer (PD) distribution is currently only 32 bit eclipse with 32 bit jre included, if you need more memory for larger projects download 614 bit eclipse and install the plugins.
> You will need a specific version of Eclipse as base installation to avoid plugin version conflicts and dependency issues
> [Eclipse RCP for RAP Developers (SP 2)](https://www.eclipse.org/downloads/packages/eclipse-rcp-and-rap-developers/keplersr2)
>
> You will also need to use plugin distribution if you want to use Informatica Process Developer on Mac or Linux System. Informatica  does not provide a native distribution for these systems.

Use following [detailed guide](install_process_developer.md) if you installing Process Developer on MacOS or Linux

# Other Recommended Tools

## Developer Text Editor

Good text editor that supports XML,xQuery, markdown editing and has git support if desired

- [Sublime Text 3](https://www.sublimetext.com)
- [Visual Studio Code](https://code.visualstudio.com) (my current favorite editor)
- [Atom](https://atom.io)

## Git Client

It is best to use Git or other VCS to revision control your Development assets such as IPD objects and Processes developed in the Process Developer
We recommend to familiarize yourself with git as VCS of choice for many its advantages notably being distributed system

Although there is a range range of visual git clients available  including Informatica Process Developer we recommend to familiarize yourself with git command line CLI
Install git Client - there is a number of choices, see https://git-scm.com/

> I preferred using [cygwin](https://www.cygwin.com/) in the past but recently switched from Mac back to windows a here is my new [Windows Setup Guide](setup_tools_windows.md)

## Apache Ant

We have provided set of Apache ant scripts to automate various task for Release and SCM management of Informatica CLoud development assets.
See [IPD SCM management project doc](../icrt/com.informatica.ipd/doc/README.md)
Ant is included with above distribution of process Developer (eclipse). Nevertheless, it is beneficial that you setup Ant on you system to be available from shell.
Download latest version of [Apache Ant](http://ant.apache.org/)

## Java JDK

You will need Java JDK if you opt for installation of Process Developer using standalone Eclipse distribution and Process developer Plugins. In this case JDK is not included with eclipse runtime and must installed separately
Use java JDK 1.7  or later with Process Developer

[Download JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

We highly recommend to install JDK on short path with no spaces (do not use Program Files for Process Developer or eclipse).
Use something like

- `C:\infa\eclipse\`
- `C:\infa\java\jdk_1.8`

## After Installation of the tools (your first Login to the Maintenance Machine)

## Setup SSH key

Steps based on this guide

1. Open git client bash windows at `C:\infa\Git\git-bash`
2. generate your ssh key
    `ssh-keygen -t rsa -b 4096 -C "your.email@company.com"`
3. Follow the screen instructions, use default settings for key location
4. Setup password for the ssh private key

## Setup your Git Client

Steps based on this [guide](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)

1. Open shell git client `C:\infa\Git\git-bash`
2. Setup your user
    `git config --global user.name "Your Name"`
3. Setup your email
    `git config --global user.email "your.email@company.com"`
4. Setup git commit editor
    `git config --global core.editor "code --wait"`
5. print out the public key using
    `cat ~/.ssh/id_rsa.pub`
    This would print something like
    `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCdVIilobvPOrNY0fsnZyNbF......  ipaas@acme.com`
6. Copy printed out key starting ssh-key to clipboard
7. Go to Git Repo security settings
8. Add your key to the list of access keys
9. CD to `cd ~/git_repos/ipaas-integration` and verify connection by using `git pull` command
10. Git client will ask you for your private key passphrase and display similar output to this

    ```shell
    $ git pull
    Enter passphrase for key '~/.ssh/id_rsa':
    Already up to date.
    ```

Now you should be able to operate with git and make commits and push changes to origin repository

In addition ypu can add following useful aliases to you git config

```shell
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.changed "diff --stat"
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.st status
git config --global alias.up rebase
git config --global alias.alias "! git config --get-regexp ^alias\. | sed -e s/^alias\.// -e s/\ /\ =\ / | sort"
```

# Recommended VS Code plugins

VS Code is very useful environment for many aspects of the Informatica CLoud Development Scenarios, I highly recommend to use built in Sync or Sync Settings Plugin to synchronize the Configuration across different machines via Github Gists.
See [Sync Settings](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)

Another good way to quickly install set of plugins is this migration [method](https://stackoverflow.com/questions/35773299/how-can-you-export-the-visual-studio-code-extension-list)
I also use number other extensions related to Markdown, XML, xQuery Editing and syntax support.

Here is my current list of extensions
```shell
code --install-extension adashen.vscode-tomcat
code --install-extension AlanWalk.markdown-navigation
code --install-extension AlanWalk.markdown-toc
code --install-extension alefragnani.project-manager
code --install-extension blackmist.LinkCheckMD
code --install-extension buianhthang.xml2json
code --install-extension christian-kohler.path-intellisense
code --install-extension codezombiech.gitignore
code --install-extension csholmq.excel-to-markdown-table
code --install-extension cssho.vscode-svgviewer
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension dbaeumer.vscode-eslint
code --install-extension donjayamanne.git-extension-pack
code --install-extension donjayamanne.githistory
code --install-extension DotJoshJohnson.xml
code --install-extension DougFinke.vscode-pandoc
code --install-extension eamodio.gitlens
code --install-extension fcrespo82.markdown-table-formatter
code --install-extension felipecaputo.git-project-manager
code --install-extension GrapeCity.gc-excelviewer
code --install-extension heaths.vscode-guid
code --install-extension hubertstrk.pgsql-html
code --install-extension jakebathman.mysql-syntax
code --install-extension kohkimakimoto.vscode-mac-dictionary
code --install-extension kontrail.vscode-svg-dev
code --install-extension marvinhagemeister.theme-afterglow-remastered
code --install-extension mechatroner.rainbow-csv
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-mssql.mssql
code --install-extension ms-vscode.sublime-keybindings
code --install-extension mycelo.oracle-plsql
code --install-extension nickheap.vscode-ant
code --install-extension nidu.copy-json-path
code --install-extension pedroguerra.ant-tree-viewer
code --install-extension redhat.java
code --install-extension redhat.vscode-yaml
code --install-extension RomanPeshkov.vscode-text-tables
code --install-extension salesforce.salesforcedx-vscode
code --install-extension salesforce.salesforcedx-vscode-apex
code --install-extension salesforce.salesforcedx-vscode-apex-debugger
code --install-extension salesforce.salesforcedx-vscode-apex-replay-debugger
code --install-extension salesforce.salesforcedx-vscode-core
code --install-extension salesforce.salesforcedx-vscode-lightning
code --install-extension salesforce.salesforcedx-vscode-lwc
code --install-extension salesforce.salesforcedx-vscode-visualforce
code --install-extension Shan.code-settings-sync
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension streetsidesoftware.code-spell-checker-czech
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension vscjava.vscode-java-debug
code --install-extension vscjava.vscode-java-pack
code --install-extension vscjava.vscode-java-test
code --install-extension vscjava.vscode-maven
code --install-extension weijunyu.vscode-json-path
code --install-extension yzhang.markdown-all-in-one
code --install-extension ziyasal.vscode-open-in-github
```
