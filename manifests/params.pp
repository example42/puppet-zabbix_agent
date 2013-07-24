# Class: zabbix_agent::params
#
# This class defines default parameters used by the main module class zabbix_agent
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to zabbix_agent class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class zabbix_agent::params {

  ### Application related parameters

  $dependencies_class    = 'zabbix_agent::dependencies'
  $create_user           = true
  $install               = 'package'

  $install_source        = ''
  $install_destination   = '/opt'
  $init_script_template  = 'zabbix_agent/zabbix_agent.init.erb'

  $package = $::operatingsystem ? {
    default => 'zabbix-agent',
  }

  $service = $::operatingsystem ? {
    default => 'zabbix-agent',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'zabbix_agentd',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'zabbix',
  }

  $process_group = $::operatingsystem ? {
    default => 'zabbix',
  }

  $config_dir = $::operatingsystem ? {
    default => '',
  }

  $config_file = $::operatingsystem ? {
    default => '',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $pid_file = $::operatingsystem ? {
    default => '/var/run/zabbix/zabbix_agentd.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/zabbix',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/zabbix/zabbix_agentd.log',
  }

  $port = '10050'
  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false
  $noops = false

}
