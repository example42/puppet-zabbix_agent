#
# = Define: zabbix_agent::configfile
#
# The define manages zabbix_agent configfile
#
#
# == Parameters
#
# [*ensure*]
#   String. Default: present
#   Manages configfile presence. Possible values:
#   * 'present' - Install package, ensure files are present.
#   * 'absent' - Stop service and remove package and managed files
#
# [*template*]
#   String. Default: Provided by the module.
#   Sets the path of a custom template to use as content of configfile
#   If defined, configfile file has: content => content("$template")
#   Example: template => 'site/configfile.conf.erb',
#
# [*options*]
#   Hash. Default undef. Needs: 'template'.
#   An hash of custom options to be used in templates to manage any key pairs of
#   arbitrary settings.
#
define zabbix_agent::configfile (
  $template ,
  $ensure   = present,
  $options  = '' ,
  $ensure  = present ) {

  include zabbix_agent

  file { "zabbix_agent_configfile_${name}":
    ensure  => $ensure,
    path    => "${zabbix_agent::config_dir}/${name}",
    mode    => $zabbix_agent::config_file_mode,
    owner   => $zabbix_agent::config_file_owner,
    group   => $zabbix_agent::config_file_group,
    require => Package[$zabbix_agent::package],
    notify  => $zabbix_agent::manage_service_autorestart,
    content => template($template),
    replace => $zabbix_agent::manage_file_replace,
    audit   => $zabbix_agent::manage_audit,
    noop    => $zabbix_agent::noops,
  }

}
