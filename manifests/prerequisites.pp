# Class: zabbix_agent::prerequisites
#
# This class installs zabbix_agent prerequisites
#
# == Variables
#
# Refer to zabbix_agent class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by zabbix_agent if the parameter
# install_prerequisites is set to true
# Note: This class may contain resources available on the
# Example42 modules set
#
class zabbix_agent::prerequisites {

  include java

  if $zabbix_agent::install != 'package' {
    git::reposync { 'zabbix_agent-servicewrapper':
      source_url      => 'https://github.com/zabbix_agent/zabbix_agent-servicewrapper.git',
      destination_dir => "${zabbix_agent::install_destination}/zabbix_agent-servicewrapper",
      post_command    => "cp -a ${zabbix_agent::install_destination}/zabbix_agent-servicewrapper/service/ ${zabbix_agent::home}/bin ; chown -R ${zabbix_agent::process_user}:${zabbix_agent::process_user} ${zabbix_agent::home}/bin/service",
      creates         => "${zabbix_agent::home}/bin/service",
      before          => [ Class['zabbix_agent::service'] , Class['zabbix_agent::config'] ],
    }
    exec { 'zabbix_agent-servicewrapper-copy':
      command => "cp -a ${zabbix_agent::install_destination}/zabbix_agent-servicewrapper/service/ ${zabbix_agent::home}/bin ; chown -R ${zabbix_agent::process_user}:${zabbix_agent::process_user} ${zabbix_agent::home}/bin/service",
      path    => '/bin:/sbin:/usr/sbin:/usr/bin',
      creates => "${zabbix_agent::home}/bin/service",
      require => Git::Reposync['zabbix_agent-servicewrapper'],
    }
    file { "${zabbix_agent::home}/bin/service/zabbix_agent":
      ensure  => present,
      mode    => 0755,
      owner   => $zabbix_agent::process_user,
      group   => $zabbix_agent::process_user,
      content => template($zabbix_agent::init_script_template),
      before  => Class['zabbix_agent::service'],
      require => Git::Reposync['zabbix_agent-servicewrapper'],
    }
    file { "/etc/init.d/zabbix_agent":
      ensure  => "${zabbix_agent::home}/bin/service/zabbix_agent",
    }
    file { "${zabbix_agent::home}/bin/service/zabbix_agent.conf":
      ensure  => present,
      mode    => 0644,
      owner   => $zabbix_agent::process_user,
      group   => $zabbix_agent::process_user,
      content => template($zabbix_agent::init_config_template),
      before  => Class['zabbix_agent::service'],
      require => Git::Reposync['zabbix_agent-servicewrapper'],
    }
    file { "${zabbix_agent::home}/logs":
      ensure  => directory,
      mode    => 0755,
      owner   => $zabbix_agent::process_user,
      group   => $zabbix_agent::process_user,
      before  => Class['zabbix_agent::service'],
      require => Git::Reposync['zabbix_agent-servicewrapper'],
    }
  }

}
