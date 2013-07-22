# Class: zabbix_agent::user
#
# This class creates zabbix_agent user
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by zabbix_agent
#
class zabbix_agent::user {
  @user { $zabbix_agent::process_user :
    ensure     => $zabbix_agent::manage_file,
    comment    => "${zabbix_agent::process_user} user",
    password   => '!',
    managehome => false,
    home       => $zabbix_agent::home,
    shell      => '/bin/bash',
  }
#  @group { $zabbix_agent::process_group :
#    ensure     => $zabbix_agent::manage_file,
#  }

  User <| title == $zabbix_agent::process_user |>
#  Group <| title == $zabbix_agent::process_group |>

}
