# = Class: zabbix_agent
#
# This is the main zabbix_agent class
#
#
# == Parameters
#
# [*server*]
#   Ip of the Zabbix server
#
# [*dependencies_class*]
#   The name of the class that installs dependencies and prerequisite
#   resources needed by this module.
#   Default is $graylog2::dependencies which uses Example42 modules.
#   Set to '' false to not install any dependency (you must provide what's
#   defined in graylog2/manifests/dependencies.pp in some way).
#   Set directy the name of a custom class to manage there the dependencies
#
# [*create_user*]
#   Set to true if you want the module to create the process user of zabbix_agent
#   (as defined in $logstagh::process_user). Default: true
#   Note: User is not created when $zabbix_agent::install is package
#
# [*install*]
#   Kind of installation to attempt:
#     - package : Installs zabbix_agent using the OS common packages
#
# [*config_dir*]
#   Name of the directory containing extra configuration files
#
# [*init_script_template*]
#   Template file used for /etc/init.d/zabbix-agent
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, zabbix_agent class will automatically "include $my_class"
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, zabbix_agent main config file will have the param: source => $source
#
# [*source_dir*]
#   If defined, the whole zabbix_agent configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, zabbix_agent main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#
# [*service_autorestart*]
#   Automatically restarts the zabbix_agent service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $zabbix_agent_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#
# [*package_provider*]
#   The Provider to use for the package resource
#
# Default class params - As defined in zabbix_agent::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of zabbix_agent package
#
# [*service*]
#   The name of zabbix_agent service
#
# [*service_status*]
#   If the zabbix_agent service init script supports status argument
#
# [*process*]
#   The name of zabbix_agent process
#
# [*process_args*]
#   The name of zabbix_agent arguments.
#   Used only in case the zabbix_agent process name is generic (java, ruby...)
#
# [*process_user*]
#   The name of the user zabbix_agent runs with.
#
# [*process_group*]
#   The name of the group zabbix_agent runs with.
#
# [*config_dir*]
#   Main configuration directory.
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*data_dir*]
#   Path of application data directory.
#
# [*log_dir*]
#   Base logs directory.
#
# [*log_file*]
#   Log file(s).
#
# See README for usage patterns.
#
class zabbix_agent (
  $server = 'localhost',
  $service_provider = 'init',
  $dependencies_class = 'zabbix_agent::dependencies',
  Boolean $create_user = true,
  $install = 'package',
  $init_script_template = 'zabbix_agent/zabbix_agent.init.erb',
  $my_class = '',
  String $source = '',
  $source_dir = '',
  Boolean $source_dir_purge = false,
  String $template = '',
  Boolean $service_autorestart = true,
  Hash $options = {},
  $version = 'present',
  Boolean $absent = false,
  Boolean $disable = false,
  Boolean $disableboot = false,
  Boolean $debug = false,
  $package = 'zabbix-agent',
  $package_provider = '',
  $service = 'zabbix-agent',
  Boolean $service_status = true,
  $process = 'zabbix_agentd',
  $process_args = '',
  $process_user = 'zabbix',
  $process_group = 'zabbix',
  $config_dir = '',
  $config_file = '',
  $config_file_mode = '0644',
  $config_file_owner = 'root',
  $config_file_group = 'root',
  $data_dir = '',
  $log_dir = '/var/log/zabbix',
  $log_file = '/var/log/zabbix/zabbix_agentd.log',
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
