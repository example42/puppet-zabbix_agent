# lint:ignore:global_resource
# Class removal
#
class { 'zabbix_agent':
  absent => true,
}
# lint:endignore
