<!-- MarkdownTOC -->

- [Environment and Tools Guides](#environment-and-tools-guides)
- [My Essential Tools](#my-essential-tools)
    - [Universal \(All Operating Systems\)](#universal-all-operating-systems)
        - [Git](#git)
            - [Install Git CLI](#install-git-cli)
        - [Sublime Text 3](#sublime-text-3)

<!-- /MarkdownTOC -->

# Environment and Tools Guides

Typical Cloud Application Integration development may span large amount technologies tools and APIs
To keep myself productive especially when given new environment or machine for development

Most of the guides listed here assume that you as a developer have reasonable access to your machine and install software as local administratior.
These guides inted to describe basic setup

# My Essential Tools

## Universal (All Operating Systems)

### Git

Although there is range of GUI clients for git I highly recommend to learn how to install and use command line CLI interface,
It is not only the most effcient way of dealing with daily git tasks but you will aslo learn better how git works internally and find help in case you hit some obstacles with git commits, confict resolution etc. there is a ton of resources available for any git cli situations, not so many describing how to to complex tasks in GUI tools.

#### Install Git CLI

- __Unix/Linux__ git installition is easy on most Unix/Linux patforms platforms, just using platform packagem manger
    + See: https://git-scm.com/download/linux
- __Windows__
    + See https://git-scm.com/download/win
    + Alternative is to isntall git within [Windows Subsystem for Linux](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide) which makes it as easy as on Ubuntu itself, Unfortunately our corprate windows Machines don't support this metod
    + If you do not have Windows 10 or necessaru priviledges to run your Windows with Development mode instelled Another option is the one that use most frequently and it works well even on older versions of Windows
    + Use [Cygwin] and isntall git using cygwin's setup tool or helper apt-cyg tool
- __Mac__: See https://git-scm.com/download/mac
    + Alternatively many people use [homebrew](https://brew.sh/) package manager or my prefered [Mac Ports](https://www.macports.org/)
- In case you really want GUI client https://git-scm.com/downloads/guis/

[My Git Git Install Guide](install_git.md)

### Sublime Text 3

I prefer this editor edits and in fact these guides were written in Sublime Text as well
Download [here](https://www.sublimetext.com/3)
I highly recommend this text ediror as general purpose editor, Although there are other choices such as Atom, Notpad++, vim, Visual Studio Code, whhich are all great editors. I never got prficient enough in using vim so my second choice of multi platform editpr is Sublime Text

The advantages of this editor for development in the comtext of Informatica Cloud development

- extensive set of plugins thst include
    +  great Markdown editor
    +  good xquery editor
    +  good xml support
    +  Git Integration if you wnat it
-  it is multi platform supported on Win, Mac, Linux
-  Easy to sychronize plugins and settings between machines
-  Build systems integration (Maven, Make, Gradle, Ant, Rust)

You can use Sublime Text for free "unlimited" evaluation period, but ythe $70 you pay for full license is well worth the money

[My Install Sublime Text 3 Guide](install_sublime.md)
