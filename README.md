# Puppet module: zabbix_agent

This module has been deprecated. You can use https://github.com/voxpupuli/puppet-zabbix as alternative.

Travis {<img src="https://travis-ci.org/example42/puppet-zabbix_agent.png?branch=master" alt="Build Status" />}[https://travis-ci.org/example42/puppet-zabbix_agent]

This is a Puppet module for zabbix_agent compatible with Puppet 4 and newer.

Made by Alessandro Franceschi / Lab42 and Martin Alfke / example42

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-zabbix_agent

Released under the terms of Apache 2 License.

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
          install     => 'source',
          version     => '2.0.6',
          create_user => false,
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


