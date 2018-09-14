# Environment and Tools Guides

<!-- MarkdownTOC -->

- [My Essential Tools](#my-essential-tools)
    - [Universal \(All Operating Systems\)](#universal-all-operating-systems)
        - [Git](#git)
            - [Install Git CLI](#install-git-cli)
        - [Sublime Text 3](#sublime-text-3)

<!-- /MarkdownTOC -->

Typical Cloud Application Integration development may span large amount technologies tools and APIs
To keep myself productive especially when given new environment or machine for development

Most of the guides listed here assume that you as a developer have reasonable access to your machine and install software as local administratior.
These guides intend to describe basic setup

# My Essential Tools

## Universal (All Operating Systems)

### Git

Although there is range of GUI clients for git I highly recommend to learn how to install and use command line CLI interface,
It is not only the most efficient way of dealing with daily git tasks but you will also learn better how git works internally and find help in case you hit some obstacles with git commits, conflict resolution etc. there is a ton of resources available for any git cli situations, not so many describing how to to complex tasks in GUI tools.

#### Install Git CLI

- __Unix/Linux__ git instillation is easy on most Unix/Linux platforms platforms, just using platform package manger
    - See: https://git-scm.com/download/linux
- __Windows__
    - See https://git-scm.com/download/win
    - Alternative is to install git within [Windows Subsystem for Linux](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide) which makes it as easy as on Ubuntu itself
    - If you do not have Windows 10 or necessary privileges to run your Windows with Development mode installed. Another option is the one that use most frequently and it works well even on older versions of Windows
    - Use [Cygwin] and install git using cygwin's setup tool or helper apt-cyg tool
- __Mac__: See https://git-scm.com/download/mac
    - Alternatively many people use [Homebrew](https://brew.sh/) package manager or my preferred [Mac Ports](https://www.macports.org/)
- In case you really want GUI client https://git-scm.com/downloads/guis/, Atlasian's Subtree is one of the better ones

[My Git Git Install Guide](install_git.md)

### Sublime Text 3

I prefer this editor edits and in fact these guides were written in Sublime Text as well
Download [here](https://www.sublimetext.com/3)
I highly recommend this text editor as general purpose editor, Although there are other choices such as Atom, Notepad++, vim, Visual Studio Code, which are all great editors. I never got proficient enough in using vim so my second choice of multi platform editpr is Sublime Text

The advantages of this editor for development in the comtext of Informatica Cloud development

- extensive set of plug-ins that include
    - great Markdown editor
    - good xquery editor (not as good as Informatica Process Developer)
    - good xml support (not as good as Eclipse)
    - Git Integration if you want it
- it is multi platform supported on Win, Mac, Linux
- Easy to synchronize plugin and settings between machines using github gists
- Build systems integration (Maven, Make, Gradle, Ant, Rust)

You can use Sublime Text for free "unlimited" evaluation period, but the $70 you pay for full license is well worth the money Visual Source Code or Atom are good alternatives.

[My Install Sublime Text 3 Guide](install_sublime.md)
