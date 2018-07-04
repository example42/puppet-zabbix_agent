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
#     - source  : Installs zabbix_agent downloading and extracting a specific
#                 tarball or zip file
#     - puppi   : Installs zabbix_agent tarball or file via Puppi, creating the
#                 "puppi deploy zabbix_agent" command
#
# [*install_source*]
#   The URL from where to retrieve the source archive.
#   Used if install => "source" or "puppi"
#   Default is from upstream developer site. Update the version when needed.
#
# [*install_destination*]
#   The base path where to extract the source archive.
#   Used if install => "source" or "puppi"
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
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for zabbix_agent checks
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#
# [*firewall*]
#   Set to 'true' to enable firewalling of the services provided by the module
#
# [*firewall_tool*]
#   Define which firewall tool(s) (ad defined in Example42 firewall module)
#   you want to use to open firewall for zabbix_agent port(s)
#
# [*firewall_src*]
#   Define which source ip/net allow for firewalling zabbix_agent. Default: 0.0.0.0/0
#
# [*firewall_dst*]
#   Define which destination ip to use for firewalling. Default: $ipaddress
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#
# [*package_source*]
#   The URL from where to download the Package (http or puppet)
#
# [*package_provider*]
#   The Provider to use for the package resource
#
# [*package_path*]
#   The Path where to save the Package for installation
#
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
#   The name of zabbix_agent arguments. Used by puppi and monitor.
#   Used only in case the zabbix_agent process name is generic (java, ruby...)
#
# [*process_user*]
#   The name of the user zabbix_agent runs with.
#
# [*process_group*]
#   The name of the group zabbix_agent runs with.
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
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
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_file*]
#   Log file(s). Used by puppi
#
# [*port*]
#   The listening port, if any, of the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Note: This doesn't necessarily affect the service configuration file
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#
#
# See README for usage patterns.
#
class zabbix_agent (
  $server,
  $service_provider,
  $dependencies_class,
  Boolean $create_user,
  $install,
  $install_source,
  $install_destination,
  $init_script_template,
  $my_class,
  String $source,
  $source_dir,
  Boolean $source_dir_purge,
  String $template,
  Boolean $service_autorestart,
  Hash $options,
  $version,
  Boolean $absent,
  Boolean $disable,
  Boolean $disableboot,
  Boolean $monitor,
  $monitor_tool,
  $monitor_target,
  Boolean $puppi,
  $puppi_helper,
  Boolean $firewall,
  $firewall_tool,
  $firewall_src,
  $firewall_dst,
  Boolean $debug,
  Boolean $audit_only,
  $package,
  $package_source,
  $package_provider,
  $package_path,
  $service,
  $service_status,
  $process,
  $process_args,
  $process_user,
  $process_group,
  $config_dir,
  $config_file,
  $config_file_mode,
  $config_file_owner,
  $config_file_group,
  $pid_file,
  $data_dir,
  $log_dir,
  $log_file,
  $port,
  $protocol,
){

  ### Definition of some variables used in the module
  $manage_package = $absent ? {
    true  => 'absent',
    false => $install ? {
      package => $package_source ? {
        ''      => $version,
        default => $::operatingsystem ? {
          /(?i:Debian|Ubuntu|Mint)/ => 'present',
          default                   => $version,
        },
      },
      default => $version,
    },
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

  if $absent or $disable or $disableboot {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  if $absent or $disable {
    $manage_firewall = false
  } else {
    $manage_firewall = true
  }

  $manage_audit = $audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $audit_only ? {
    true  => false,
    false => true,
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
  $real_install_source = $install_source ? {
    undef   => "http://www.zabbix.com/downloads/${version}/zabbix_agents_${version}.${os_string}${os_version}.${os_arch}.tar.gz",
    default => $install_source,
  }

  $home = "${install_destination}/zabbix_agent"

  $real_config_file = $config_file ? {
    ''     => $install ? {
      package => '/etc/zabbix/zabbix_agentd.conf',
      default => "${home}/conf/zabbix_agentd.conf",
    },
    default => $config_file,
  }

  $real_config_dir = $config_dir ? {
    ''     => $install ? {
      package => '/etc/zabbix/',
      default => "${home}/conf/",
    },
    default => $config_dir,
  }

  $package_filename = url_parse($package_source, 'filename')
  $real_package_path = $package_path ? {
    ''      => $package_source ? {
      ''      => undef,
      default => "${install_destination}/${package_filename}",
    },
    default => $package_path,
  }

  $real_package_provider = $package_provider ? {
    ''      => $package_source ? {
      ''      => undef,
      default => $::operatingsystem ? {
          /(?i:Debian|Ubuntu|Mint)/     => 'dpkg',
          /(?i:RedHat|Centos|Scienfic)/ => 'rpm',
          default                   => undef,
      },
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

  ### Example42 extensions
  if $puppi or $monitor or $firewall {
    class { 'zabbix_agent::example42': }
  }

  ### Debug
  if $debug {
    class { 'zabbix_agent::debug': }
  }

}
