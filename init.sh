#!/bin/bash

initvim()
{
    mkdir  -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    # open vim and run :PluginInstall
}

UpdateYumRepo()
{
    if grep -q CentOS /etc/redhat-release; then     
        cd /etc/yum.repos.d
        # 163-Base
        wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
        # EPEL
        wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-7.noarch.rpm
        yum localinstall epel-release-6-7.noarch.rpm
        # rpmfusion
        # http://rpmfusion.org/
    fi
}

InstallNecessaryRPM()
{
    RPMs="vim-enhanced bash-completion git"
    yum install $RPMs -y
}

DisableSELinux()
{
    sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
}

UpdateBashrc()
{
    BASHRC="~/.bashrc"
    cat >>$BASHRC <<EOF
alias vi=vim
alias grep='grep --color=always'

maketags()
{
    cur_dir=$PWD
    echo "Finding all header and source files ..."
    find $cur_dir -name "*.h" -o -name "*.H" -o -name "*.hpp" \
                -o -name "*.c" -o -name "*.cpp" \
                -o -name "*.C" > cscope.files
    echo "Generating cscope tags ..."
    cscope -bkq -i cscope.files
    echo "Generating ctags ..."
    cat cscope.files | xargs ctags
    echo "Done!"
}
EOF

    source $BASHRC
}

### Main ###
UpdateBashrc

