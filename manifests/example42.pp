# = Class: zabbix_agent::example42
#
# This iclass contains Example42 extensions for
# the zabbix_agent module
#
class zabbix_agent::example42 {

  ### Provide puppi data, if enabled ( puppi => true )
  if $zabbix_agent::puppi {
    $classvars=get_class_args()
    puppi::ze { 'zabbix_agent':
      ensure    => $zabbix_agent::manage_file,
      variables => $classvars,
      helper    => $zabbix_agent::puppi_helper,
    }
  }


  ### Service monitoring, if enabled ( monitor => true )
  if $zabbix_agent::monitor {
    if $zabbix_agent::port != '' {
      monitor::port { "zabbix_agent_${zabbix_agent::protocol}_${zabbix_agent::port}":
        protocol => $zabbix_agent::protocol,
        port     => $zabbix_agent::port,
        target   => $zabbix_agent::monitor_target,
        tool     => $zabbix_agent::monitor_tool,
        enable   => $zabbix_agent::manage_monitor,
      }
    }
    if $zabbix_agent::service {
      monitor::process { 'zabbix_agent_process':
        process  => $zabbix_agent::process,
        service  => $zabbix_agent::service,
        pidfile  => $zabbix_agent::pid_file,
        user     => $zabbix_agent::process_user,
        argument => $zabbix_agent::process_args,
        tool     => $zabbix_agent::monitor_tool,
        enable   => $zabbix_agent::manage_monitor,
      }
    }
  }


  ### Firewall management, if enabled ( firewall => true )
  if $zabbix_agent::firewall and $zabbix_agent::port != '' {
    firewall { "zabbix_agent_${zabbix_agent::protocol}_${zabbix_agent::port}":
      source      => $zabbix_agent::firewall_src,
      destination => $zabbix_agent::firewall_dst,
      protocol    => $zabbix_agent::protocol,
      port        => $zabbix_agent::port,
      action      => 'allow',
      direction   => 'input',
      tool        => $zabbix_agent::firewall_tool,
      enable      => $zabbix_agent::manage_firewall,
    }
  }

}
