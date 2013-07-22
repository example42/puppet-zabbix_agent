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

  $install_prerequisites = true
  $create_user           = true
  $install               = 'source'
  $java_opts             = undef

  $install_source        = ''
  $install_destination   = '/opt'
  $init_config_template  = 'zabbix_agent/zabbix_agent.conf.erb'
  $init_script_template  = 'zabbix_agent/zabbix_agent.init.erb'

  $package = $::operatingsystem ? {
    default => 'zabbix_agent',
  }

  $service = $::operatingsystem ? {
    default => 'zabbix_agent',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'java',
  }

  $process_args = $::operatingsystem ? {
    default => 'zabbix_agent',
  }

  $process_user = $::operatingsystem ? {
    default => 'zabbix_agent',
  }

  $process_group = $::operatingsystem ? {
    default => 'zabbix_agent',
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

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/zabbix_agent',
    default                   => '/etc/sysconfig/zabbix_agent',
  }

  $pid_file = $::operatingsystem ? {
    default => '/var/run/zabbix_agent.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '/etc/zabbix_agent',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/zabbix_agent',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/zabbix_agent/zabbix_agent.log',
  }

  $port = '9200'
  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $service_autorestart = true
  $version = '0.20.6'
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
