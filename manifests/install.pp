# Class: zabbix_agent::install
#
# This class installs zabbix_agent
#
# == Variables
#
# Refer to zabbix_agent class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by zabbix_agent
#
class zabbix_agent::install {

  case $zabbix_agent::install {

    package: {

      if ($zabbix_agent::package_source != '') or ($zabbix_agent::package_source == undef) {
        case $zabbix_agent::package_source {
          /^http/: {
            exec {
              "wget zabbix_agent package":
                command => "wget -O ${zabbix_agent::real_package_path} ${zabbix_agent::package_source}",
                creates => "${zabbix_agent::real_package_path}",
                unless  => "test -f ${zabbix_agent::real_package_path}",
                before  => Package['zabbix_agent']
            }
          }
          /^puppet/: {
            file {
              'zabbix_agent package':
                path    => "${zabbix_agent::real_package_path}",
                ensure  => $zabbix_agent::manage_file,
                source  => $zabbix_agent::package_source,
                before  => Package['zabbix_agent']
            }
          }
          default: {}
        }
      }

      package { 'zabbix_agent':
        ensure    => $zabbix_agent::manage_package,
        name      => $zabbix_agent::package,
        provider  => $zabbix_agent::real_package_provider,
        source    => $zabbix_agent::real_package_path,
        noop      => $zabbix_agent::noops,
      }
    }

    source: {
      if $zabbix_agent::bool_create_user == true {
        require zabbix_agent::user
      }
      puppi::netinstall { 'netinstall_zabbix_agent':
        url                 => $zabbix_agent::real_install_source,
        destination_dir     => $zabbix_agent::home,
        extracted_dir       => 'conf',
        noop                => $zabbix_agent::noops,
        require             => File['zabbix_agent_home'],
      }

      file { 'zabbix_agent_home':
        ensure  => directory,
        path    => "${zabbix_agent::home}",
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        audit   => $zabbix_agent::manage_audit,
        noop    => $zabbix_agent::noops,
      }
    }

    puppi: {
      if $zabbix_agent::bool_create_user == true {
        require zabbix_agent::user
      }

      puppi::project::archive { 'zabbix_agent':
        source      => $zabbix_agent::real_install_source,
        deploy_root => $zabbix_agent::home,
        user        => $zabbix_agent::process_user,
        auto_deploy => true,
        enable      => true,
        noop        => $zabbix_agent::noops,
        require     => File['zabbix_agent_home'],
      }

      file { 'zabbix_agent_home':
        ensure  => directory,
        path    => "${zabbix_agent::home}",
        mode    => '0755',
        owner   => $zabbix_agent::config_file_owner,
        group   => $zabbix_agent::config_file_group,
        audit   => $zabbix_agent::manage_audit,
        noop    => $zabbix_agent::noops,
      }

    }

    default: { }

  }

}
