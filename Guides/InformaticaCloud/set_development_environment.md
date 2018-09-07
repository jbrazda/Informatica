# Set Development Environment for IPD Development

<!-- MarkdownTOC -->

- Install Informatica Tools
    - Process Developer
- Other Recommended Tools
    - Developer Text Editor
    - Git Client
    - Apache Ant
    - Java JDK
    - After Installation of the tools \(your first Login to the Maintenance Machine\)
    - Setup SSH key
    - Setup your Git Client

<!-- /MarkdownTOC -->

This guide is set of recommendations for tools and software to use for

# Install Informatica Tools

## Process Developer

Eclipse-based IDE that developers can download to develop processes and prepare to deploy them using the Process Console.

- [Download Informatica Cloud Process Developer (Microsoft Windows)](http://doc.rt.informaticacloud.com/cpd/Cloud_Process_Developer_windows.zip)
- [Download Informatica Cloud Process Developer Eclipse Plug-ins](http://doc.rt.informaticacloud.com/cpd/Cloud_Process_Developer_plugins.zip)

> The windows Processs Developer (PD) distribution is currently only 32 bit eclipse with 32 bit jre included, if need more memory for larger projects dowbload 614 bit eclipse and install the plugins.
> You will need a specific verison of Eclipse as base installation to avoid plugin version conflicts and dependency issues
> [Eclipse RCP for RAP Developers (SP 2)](https://www.eclipse.org/downloads/packages/eclipse-rcp-and-rap-developers/keplersr2)
>
> You will also need to use plugin distribution if you want to use Informatica Process Devloper on Mac or Linux System. Informatica  does not provide a native distribution for thses systems.

# Other Recommended Tools

## Developer Text Editor

Good text editor that supports XML,xQuery, markdown editing and has git support if desired

- [Sublime Text 3](https://www.sublimetext.com)
- [Visual Studio Code](https://code.visualstudio.com)
- [Atom](https://atom.io)

## Git Client

It is best to use Git or other VCS to revsion control your Development assets such as IPD objects and Processes developed in the Process Dveloper
We recommend to familiarize yourself with git as VCS of choice for many its advantages notably being distributed system

Although there ramge of visual git clients including Infromatica Process Developer we recommend to familiarize yourself with git command line CLI
Install git Client - there is a number of choices, see https://git-scm.com/

> I prefer using [cygwin](https://www.cygwin.com/) shell with git intallation from cygwin, but the git CLI provided on git home page is easier to install, make your own choice

## Apache Ant

We have provided set of Apache ant scripts to automate various task for Release and SCM management of Informatica CLoud development assets.
See [IPD SCM managemnt project doc](../icrt/com.informatica.ipd/doc/README.md)
Ant is included with above distribution of process Developer (eclipse). Nevertheless, it is benefficial that you setup and on you system to be available from shell on your system.
Download latest verion of [Apache Ant](http://ant.apache.org/)

## Java JDK

You will need Java JDK if you opt for installation of Process Developer using standalone Eclipse distribution and Process developer Plugins. In this case JDK is not included with eclipse runtime and must installed separately
Use java JDK 1.7  or later with Process Developer

[Download JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

We highly recommend to install JDK on short path with no spaces (do not use Program Files for Process Developer or eclipse).
Use something like

- `C:\infa\eclipse\`
- `C:\infa\java\jdk_1.7`

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

Now you should be able to operate with git and make commits and push changes to orgin repoistory in visualstudio.com

In addition ypu can add follwoing useful aliases to you git config

```shell
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.changed = "git diff --name-only"
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.st status
git config --global alias.up rebase
```

