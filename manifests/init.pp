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
#   Can be defined also by the variable $zabbix_agent_install
#
# [*install_source*]
#   The URL from where to retrieve the source archive.
#   Used if install => "source" or "puppi"
#   Default is from upstream developer site. Update the version when needed.
#   Can be defined also by the variable $zabbix_agent_install_source
#
# [*install_destination*]
#   The base path where to extract the source archive.
#   Used if install => "source" or "puppi"
#   Can be defined also by the variable $zabbix_agent_install_destination
#
# [*init_script_template*]
#   Template file used for /etc/init.d/zabbix-agent
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, zabbix_agent class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $zabbix_agent_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, zabbix_agent main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $zabbix_agent_source
#
# [*source_dir*]
#   If defined, the whole zabbix_agent configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $zabbix_agent_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $zabbix_agent_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, zabbix_agent main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $zabbix_agent_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $zabbix_agent_options
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
#   Can be defined also by the (top scope) variable $zabbix_agent_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $zabbix_agent_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $zabbix_agent_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $zabbix_agent_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for zabbix_agent checks
#   Can be defined also by the (top scope) variables $zabbix_agent_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $zabbix_agent_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the (top scope) variables $zabbix_agent_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the (top scope) variables $zabbix_agent_puppi_helper
#   and $puppi_helper
#
# [*firewall*]
#   Set to 'true' to enable firewalling of the services provided by the module
#   Can be defined also by the (top scope) variables $zabbix_agent_firewall
#   and $firewall
#
# [*firewall_tool*]
#   Define which firewall tool(s) (ad defined in Example42 firewall module)
#   you want to use to open firewall for zabbix_agent port(s)
#   Can be defined also by the (top scope) variables $zabbix_agent_firewall_tool
#   and $firewall_tool
#
# [*firewall_src*]
#   Define which source ip/net allow for firewalling zabbix_agent. Default: 0.0.0.0/0
#   Can be defined also by the (top scope) variables $zabbix_agent_firewall_src
#   and $firewall_src
#
# [*firewall_dst*]
#   Define which destination ip to use for firewalling. Default: $ipaddress
#   Can be defined also by the (top scope) variables $zabbix_agent_firewall_dst
#   and $firewall_dst
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $zabbix_agent_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $zabbix_agent_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
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
#   Can be defined also by the (top scope) variable $zabbix_agent_port
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Can be defined also by the (top scope) variable $zabbix_agent_protocol
#
#
# See README for usage patterns.
#
class zabbix_agent (
  $server                = params_lookup( 'server' ),
  $service_provider      = params_lookup( 'service_provider' ),
  $dependencies_class    = params_lookup( 'dependencies_class' ),
  $create_user           = params_lookup( 'create_user' ),
  $install               = params_lookup( 'install' ),
  $install_source        = params_lookup( 'install_source' ),
  $install_destination   = params_lookup( 'install_destination' ),
  $init_script_template  = params_lookup( 'init_script_template' ),
  $my_class              = params_lookup( 'my_class' ),
  $source                = params_lookup( 'source' ),
  $source_dir            = params_lookup( 'source_dir' ),
  $source_dir_purge      = params_lookup( 'source_dir_purge' ),
  $template              = params_lookup( 'template' ),
  $service_autorestart   = params_lookup( 'service_autorestart' , 'global' ),
  $options               = params_lookup( 'options' ),
  $version               = params_lookup( 'version' ),
  $absent                = params_lookup( 'absent' ),
  $disable               = params_lookup( 'disable' ),
  $disableboot           = params_lookup( 'disableboot' ),
  $monitor               = params_lookup( 'monitor' , 'global' ),
  $monitor_tool          = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target        = params_lookup( 'monitor_target' , 'global' ),
  $puppi                 = params_lookup( 'puppi' , 'global' ),
  $puppi_helper          = params_lookup( 'puppi_helper' , 'global' ),
  $firewall              = params_lookup( 'firewall' , 'global' ),
  $firewall_tool         = params_lookup( 'firewall_tool' , 'global' ),
  $firewall_src          = params_lookup( 'firewall_src' , 'global' ),
  $firewall_dst          = params_lookup( 'firewall_dst' , 'global' ),
  $debug                 = params_lookup( 'debug' , 'global' ),
  $audit_only            = params_lookup( 'audit_only' , 'global' ),
  $noops                 = params_lookup( 'noops' ),
  $package               = params_lookup( 'package' ),
  $package_source        = params_lookup( 'package_source' ),
  $package_provider      = params_lookup( 'package_provider' ),
  $package_path          = params_lookup( 'package_path' ),
  $service               = params_lookup( 'service' ),
  $service_status        = params_lookup( 'service_status' ),
  $process               = params_lookup( 'process' ),
  $process_args          = params_lookup( 'process_args' ),
  $process_user          = params_lookup( 'process_user' ),
  $process_group         = params_lookup( 'process_group' ),
  $config_dir            = params_lookup( 'config_dir' ),
  $config_file           = params_lookup( 'config_file' ),
  $config_file_mode      = params_lookup( 'config_file_mode' ),
  $config_file_owner     = params_lookup( 'config_file_owner' ),
  $config_file_group     = params_lookup( 'config_file_group' ),
  $pid_file              = params_lookup( 'pid_file' ),
  $data_dir              = params_lookup( 'data_dir' ),
  $log_dir               = params_lookup( 'log_dir' ),
  $log_file              = params_lookup( 'log_file' ),
  $port                  = params_lookup( 'port' ),
  $protocol              = params_lookup( 'protocol' )
  ) inherits zabbix_agent::params {

  $bool_create_user=any2bool($create_user)
  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_firewall=any2bool($firewall)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)
  $bool_noops=any2bool($noops)


  ### Definition of some variables used in the module
  $manage_package = $zabbix_agent::bool_absent ? {
    true  => 'absent',
    false => $zabbix_agent::install ? {
      package => $zabbix_agent::package_source ? {
        ''      => $zabbix_agent::version,
        default => $::operatingsystem ? {
          /(?i:Debian|Ubuntu|Mint)/ => 'present',
          default                   => $zabbix_agent::version,
        },
      },
      default => $zabbix_agent::version,
    },
  }

  $manage_service_enable = $zabbix_agent::bool_disableboot ? {
    true    => false,
    default => $zabbix_agent::bool_disable ? {
      true    => false,
      default => $zabbix_agent::bool_absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_ensure = $zabbix_agent::bool_disable ? {
    true    => 'stopped',
    default =>  $zabbix_agent::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  $manage_service_autorestart = $zabbix_agent::bool_service_autorestart ? {
    true    => Class['zabbix_agent::service'],
    false   => undef,
  }

  $manage_file = $zabbix_agent::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  if $zabbix_agent::bool_absent == true
  or $zabbix_agent::bool_disable == true
  or $zabbix_agent::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  if $zabbix_agent::bool_absent == true
  or $zabbix_agent::bool_disable == true {
    $manage_firewall = false
  } else {
    $manage_firewall = true
  }

  $manage_audit = $zabbix_agent::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $zabbix_agent::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $zabbix_agent::source ? {
    ''        => undef,
    default   => $zabbix_agent::source,
  }

  $manage_file_content = $zabbix_agent::template ? {
    ''        => undef,
    default   => template($zabbix_agent::template),
  }

  ### Internal vars depending on user's input
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
  $real_install_source = $zabbix_agent::install_source ? {
    ''      => "http://www.zabbix.com/downloads/${version}/zabbix_agents_${version}.${os_string}${os_version}.${os_arch}.tar.gz",
    default => $zabbix_agent::install_source,
  }
  $created_dirname = url_parse($zabbix_agent::real_install_source,'filedir')
  $home = "${zabbix_agent::install_destination}/zabbix_agent"

  $real_config_file = $zabbix_agent::config_file ? {
    ''      => $zabbix_agent::install ? {
      package => '/etc/zabbix/zabbix_agentd.conf',
      default => "${zabbix_agent::home}/conf/zabbix_agentd.conf",
    },
    default => $zabbix_agent::config_file,
  }

  $real_config_dir = $zabbix_agent::config_dir ? {
    ''      => $zabbix_agent::install ? {
      package => '/etc/zabbix/',
      default => "${zabbix_agent::home}/conf/",
    },
    default => $zabbix_agent::config_dir,
  }

  $package_filename = url_parse($zabbix_agent::package_source, 'filename')
  $real_package_path = $zabbix_agent::package_path ? {
    ''      => $zabbix_agent::package_source ? {
      ''      => undef,
      default => "${zabbix_agent::install_destination}/${zabbix_agent::package_filename}",
    },
    default => $zabbix_agent::package_path,
  }

  $real_package_provider = $zabbix_agent::package_provider ? {
    ''      => $zabbix_agent::package_source ? {
      ''      => undef,
      default => $::operatingsystem ? {
          /(?i:Debian|Ubuntu|Mint)/     => 'dpkg',
          /(?i:RedHat|Centos|Scienfic)/ => 'rpm',
          default                   => undef,
      },
    },
    default => $zabbix_agent::package_provider,
  }

  ### Managed resources
  ### DEPENDENCIES class
  if $zabbix_agent::dependencies_class != '' {
    include $zabbix_agent::dependencies_class
  }

  class { 'zabbix_agent::install': }

  class { 'zabbix_agent::service':
    require => Class['zabbix_agent::install'],
  }

  class { 'zabbix_agent::config':
    notify  => $zabbix_agent::manage_service_autorestart,
    require => Class['zabbix_agent::install'],
  }

  ### Include custom class if $my_class is set
  if $zabbix_agent::my_class {
    include $zabbix_agent::my_class
  }

  ### Example42 extensions
  if $zabbix_agent::bool_puppi == true
  or $zabbix_agent::bool_monitor == true
  or $zabbix_agent::bool_firewall == true {
    class { 'zabbix_agent::example42': }
  }

  ### Debug
  if $zabbix_agent::bool_debug == true {
    class { 'zabbix_agent::debug': }
  }

}
