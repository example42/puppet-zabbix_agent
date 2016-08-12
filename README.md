# Deprecation notice

This module was designed for Puppet versions 2 and 3. It should work also on Puppet 4 but doesn't use any of its features.

The current Puppet 3 compatible codebase is no longer actively maintained by example42.

Still, Pull Requests that fix bugs or introduce backwards compatible features will be accepted.


# Puppet module: zabbix_agent

This is a Puppet module for zabbix_agent based on the second generation layout ("NextGen") of Example42 Puppet Modules.

Made by Alessandro Franceschi / Lab42

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-zabbix_agent

Released under the terms of Apache 2 License.

This module requires functions provided by the Example42 Puppi module (you need it even if you don't use and install Puppi)

For detailed info about the logic and usage patterns of Example42 modules check the DOCS directory on Example42 main modules set.


## USAGE - Basic management

* Install zabbix_agent with default settings, that is installation from OS default packages

        class { 'zabbix_agent': }

* Install a specific version of zabbix_agent package.

        class { 'zabbix_agent':
          version => '2.0.6',
        }

* Install zabbix_agent from upstream tarball (you MUST provide a version with this option)

        class { 'zabbix_agent':
          install => 'source',
          version => '2.0.6',
        }

* Install zabbix_agent from upstream tarball and provide a custom template for the service's init script

        class { 'zabbix_agent':
          install => 'source',
          version => '2.0.6',
          init_script_template  => 'site/zabbix_agent/zabbix_agent.init.erb',
        }

* Install zabbix_agent from a custom source to a custom destination

        class { 'zabbix_agent':
          install             => 'source',
          install_source      => 'http://download.example42.com/software/zabbix_agents_2.0.6.solaris10.amd64.tar.gz',
          install_destination => '/usr/local', # Default: '/opt'
        }


* Install from source without creating a dedicated zabbix user 

        class { 'zabbix_agent':
          install => 'source',
          version => '2.0.6',
          create_user            => false,
        }

* Provide a custom class for the module's prerequisites (check if they apply to your case)

        class { 'zabbix_agent':
          dependency_class => 'site::pre_zabbix_agent',
        }


* Disable zabbix_agent service.

        class { 'zabbix_agent':
          disable => true
        }

* Remove zabbix_agent package

        class { 'zabbix_agent':
          absent => true
        }

* Enable auditing without without making changes on existing zabbix_agent configuration *files*

        class { 'zabbix_agent':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'zabbix_agent':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'zabbix_agent':
          source => [ "puppet:///modules/example42/zabbix_agent/zabbix_agent.conf-${hostname}" , "puppet:///modules/example42/zabbix_agent/zabbix_agent.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'zabbix_agent':
          source_dir       => 'puppet:///modules/example42/zabbix_agent/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'zabbix_agent':
          template => 'example42/zabbix_agent/zabbix_agent.conf.erb',
        }

* Automatically include a custom subclass

        class { 'zabbix_agent':
          my_class => 'example42::my_zabbix_agent',
        }


## USAGE - Example42 extensions management 
* Activate puppi (recommended, but disabled by default)

        class { 'zabbix_agent':
          puppi    => true,
        }

* Activate puppi and use a custom puppi_helper template (to be provided separately with a puppi::helper define ) to customize the output of puppi commands 

        class { 'zabbix_agent':
          puppi        => true,
          puppi_helper => 'myhelper', 
        }

* Activate automatic monitoring (recommended, but disabled by default). This option requires the usage of Example42 monitor and relevant monitor tools modules

        class { 'zabbix_agent':
          monitor      => true,
          monitor_tool => [ 'nagios' , 'monit' , 'munin' ],
        }

* Activate automatic firewalling. This option requires the usage of Example42 firewall and relevant firewall tools modules

        class { 'zabbix_agent':       
          firewall      => true,
          firewall_tool => 'iptables',
          firewall_src  => '10.42.0.0/24',
          firewall_dst  => $ipaddress_eth0,
        }


## CONTINUOUS TESTING

Travis {<img src="https://travis-ci.org/example42/puppet-zabbix_agent.png?branch=master" alt="Build Status" />}[https://travis-ci.org/example42/puppet-zabbix_agent]
