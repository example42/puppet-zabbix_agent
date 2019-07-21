# = Class: zabbix_agent
#
# This is the main zabbix_agent class
#
#
# == Parameters
#
# @param server Ip of the Zabbix server
# @param dependencies_class The name of the class that installs dependencies
#   and prerequisite resources needed by this module.
#   Default is $zabbix_agent::dependencies.
#   Set to '' false to not install any dependency (you must provide what's
#   defined in zabbix_agent/manifests/dependencies.pp in some way).
#   Set directy the name of a custom class to manage there the dependencies
# @param create_user Set to true if you want the module to create the process 
#   user of zabbix_agent. Default: true
#   Note: User is not created when $zabbix_agent::install is package
# @param install Kind of installation to attempt:
#     - package : Installs zabbix_agent using the OS common packages
# @param config_dir Name of the directory containing extra configuration files
# @param init_script_template Template file used for /etc/init.d/zabbix-agent
# @param my_class Name of a custom class to autoload to manage module's customizations
#   If defined, zabbix_agent class will automatically "include $my_class"
# @param source Sets the content of source parameter for main configuration file
#   If defined, zabbix_agent main config file will have the param: source => $source
# @param source_dir If defined, the whole zabbix_agent configuration directory content is retrieved
#   recursively from the specified source (source => $source_dir , recurse => true)
# @param source_dir_purge If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
# @param template Sets the path to the template to use as content for main configuration file
#   If defined, zabbix_agent main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
# @param options An hash of custom options to be used in templates for arbitrary settings.
# @param service_autorestart Automatically restarts the zabbix_agent service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
# @param version The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
# @param absent Set to 'true' to remove package(s) installed by module
# @param disable Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $zabbix_agent_disable
# @param disableboot  Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
# @param debug Set to 'true' to enable modules debugging
# @param package_provider The Provider to use for the package resource
# @param package The name of zabbix_agent package
# @param service  The name of zabbix_agent service
# @param service_status If the zabbix_agent service init script supports status argument
# @param process The name of zabbix_agent process
# @param process_args The name of zabbix_agent arguments.
#   Used only in case the zabbix_agent process name is generic (java, ruby...)
# @param process_user The name of the user zabbix_agent runs with.
# @param process_group The name of the group zabbix_agent runs with.
# @param config_dir Main configuration directory.
# @param config_file Main configuration file path
# @param config_file_mode Main configuration file path mode
# @param config_file_owner Main configuration file path owner
# @param config_file_group Main configuration file path group
# @param data_dir Path of application data directory.
# @param log_dir Base logs directory.
# @param log_file Log file(s).
#
# See README for usage patterns.
#
class zabbix_agent (
  Stdlib::Host     $server               = 'localhost',
  String[1]        $service_provider     = 'init',
  String           $dependencies_class   = 'zabbix_agent::dependencies',
  Boolean          $create_user          = true,
  String[1]        $install              = 'package',
  String[1]        $init_script_template = 'zabbix_agent/zabbix_agent.init.erb',
  String           $my_class             = '',
  String           $source               = '',
  String           $source_dir           = '',
  Boolean          $source_dir_purge     = false,
  String           $template             = '',
  Boolean          $service_autorestart  = true,
  Hash             $options              = {},
  String[1]        $version              = 'present',
  Boolean          $absent               = false,
  Boolean          $disable              = false,
  Boolean          $disableboot          = false,
  Boolean          $debug                = false,
  String[1]        $package              = 'zabbix-agent',
  String           $package_provider     = '',
  String[1]        $service              = 'zabbix-agent',
  Boolean          $service_status       = true,
  String[1]        $process              = 'zabbix_agentd',
  String           $process_args         = '',
  String[1]        $process_user         = 'zabbix',
  String[1]        $process_group        = 'zabbix',
  String           $config_dir           = '',
  String           $config_file          = '',
  Stdlib::Filemode $config_file_mode     = '0644',
  String[1]        $config_file_owner    = 'root',
  String[1]        $config_file_group    = 'root',
  String           $data_dir             = '',
  String[1]        $log_dir              = '/var/log/zabbix',
  String[1]        $log_file             = '/var/log/zabbix/zabbix_agentd.log',
){

  ### Definition of some variables used in the module
  $manage_package = $absent ? {
    true  => 'absent',
    false => $version,
  }

  $manage_service_enable = $disableboot ? {
    true    => false,
    default => $disable ? {
      true    => false,
      default => $absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_ensure = $disable ? {
    true    => 'stopped',
    default =>  $absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  $manage_service_autorestart = $service_autorestart ? {
    true    => Class['zabbix_agent::service'],
    false   => undef,
  }

  $manage_file = $absent ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_file_source = $source ? {
    ''       => undef,
    default  => $source,
  }

  $manage_file_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  ### Internal vars depending on user's input
  $os_string = $::kernel ? {
    'Linux'   => 'linux',
    'SunOS'   => 'solaris',
    'windows' => 'win',
  }
  $os_version = $::kernel ? {
    'Linux'   => '2_6',
    default   => regsubst($::kernelmajversion, '.' , '_' , 'G' ),
  }
  $os_arch = $::architecture ? {
    'x86_64' => 'amd64',
    default  => $::architecture,
  }

  $real_config_file = $config_file ? {
    ''      => '/etc/zabbix/zabbix_agentd.conf',
    default => $config_file,
  }

  $real_config_dir = $config_dir ? {
    ''      => '/etc/zabbix/',
    default => $config_dir,
  }

  $real_package_provider = $package_provider ? {
    ''      => $::operatingsystem ? {
      /(?i:Debian|Ubuntu|Mint)/     => 'dpkg',
      /(?i:RedHat|Centos|Scienfic)/ => 'rpm',
      default                       => undef,
    },
    default => $package_provider,
  }

  ### Managed resources
  ### DEPENDENCIES class
  if $dependencies_class != '' {
    include $dependencies_class
  }

  class { 'zabbix_agent::install': }

  class { 'zabbix_agent::service':
    require => Class['zabbix_agent::install'],
  }

  class { 'zabbix_agent::config':
    notify  => $manage_service_autorestart,
    require => Class['zabbix_agent::install'],
  }

  ### Include custom class if $my_class is set
  if $my_class != '' {
    include $my_class
  }

  ### Debug
  if $debug {
    class { 'zabbix_agent::debug': }
  }

}
