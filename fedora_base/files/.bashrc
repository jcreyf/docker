# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

#
# Some SSH commands like SCP and SFTP have issues with content in the .bashrc file
# when a remote shell is established.
# To solve that issue, we should do our best to keep the content that is getting sourced
# during non-interactive shells like SCP/SFTP to a bare minimun so it won't interfere.
#
case $- in
*i*)
  # This is an interactive shell.  Source in the whole sjaboem (set up in different file) ...
  . ~/.bashrc_jcreyf
  ;;
esac
