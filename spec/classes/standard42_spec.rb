require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'zabbix_agent' do

  let(:title) { 'zabbix_agent' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) {
    { :ipaddress => '10.42.42.42' ,
      :kernel    => 'Linux' }
  }

  describe 'Test standard installation' do
    it { should contain_package('zabbix_agent') }
    it { should contain_service('zabbix_agent').with_ensure('running') }
    it { should contain_service('zabbix_agent').with_enable('true') }
    it { should contain_file('zabbix_agent.conf').with_ensure('present') }
  end

  describe 'Test custom package source http://' do
    let(:params) {
      {:package_source => 'http://example42.com/zabbix_agent.deb',
       :install => 'package',
       :version => 'present'}
    }
    it { should contain_exec('wget zabbix_agent package') }
  end

  describe 'Test custom package source puppet://' do
    let(:params) {
      {:package_source => 'puppet:///files/zabbix_agent.deb',
       :install  => 'package',
       :version  => 'present'}
    }
    it { should contain_file('zabbix_agent package') }
  end

  describe 'Test custom package source on debian should automatically set the version to present if not specified otherwise' do
    let(:params) { {:package_source => 'http://example42.com/zabbix_agent.deb', :install => 'package'} }
    let(:facts) {
    { :ipaddress => '10.42.42.42' ,
      :operatingsystem => 'Debian' ,
      :kernel    => 'Linux' }
    }
    it { should contain_package('zabbix_agent').with_ensure('present') }
  end

  describe 'Test custom package source on debian should automatically set the package provider to dpkg if not specified otherwise' do
    let(:params) { {:package_source => 'http://example42.com/zabbix_agent.deb', :install => 'package'} }
    let(:facts) {
    { :ipaddress => '10.42.42.42' ,
      :operatingsystem => 'Debian' ,
      :kernel    => 'Linux' }
    }
    it { should contain_package('zabbix_agent').with_provider('dpkg') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:install => 'package', :version => '1.0.42'} }
    it { should contain_package('zabbix_agent').with_ensure('1.0.42') }
  end

  describe 'Test standard installation with monitoring and firewalling' do
    let(:params) { {:install => 'package', :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp' } }
    it { should contain_package('zabbix_agent').with_ensure('present') }
    it { should contain_service('zabbix_agent').with_ensure('running') }
    it { should contain_service('zabbix_agent').with_enable('true') }
    it { should contain_file('zabbix_agent.conf').with_ensure('present') }
    it { should contain_monitor__process('zabbix_agent_process').with_enable('true') }
    it { should contain_firewall('zabbix_agent_tcp_42').with_enable('true') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:install => 'package', :absent => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it 'should remove Package[zabbix_agent]' do should contain_package('zabbix_agent').with_ensure('absent') end
    it 'should stop Service[zabbix_agent]' do should contain_service('zabbix_agent').with_ensure('stopped') end
    it 'should not enable at boot Service[zabbix_agent]' do should contain_service('zabbix_agent').with_enable('false') end
    it 'should remove zabbix_agent configuration file' do should contain_file('zabbix_agent.conf').with_ensure('absent') end
    it { should contain_monitor__process('zabbix_agent_process').with_enable('false') }
    it { should contain_firewall('zabbix_agent_tcp_42').with_enable('false') }
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:install => 'package', :disable => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it { should contain_package('zabbix_agent').with_ensure('present') }
    it 'should stop Service[zabbix_agent]' do should contain_service('zabbix_agent').with_ensure('stopped') end
    it 'should not enable at boot Service[zabbix_agent]' do should contain_service('zabbix_agent').with_enable('false') end
    it { should contain_file('zabbix_agent.conf').with_ensure('present') }
    it { should contain_monitor__process('zabbix_agent_process').with_enable('false') }
    it { should contain_firewall('zabbix_agent_tcp_42').with_enable('false') }
  end

  describe 'Test decommissioning - disableboot' do
    let(:params) { {:install => 'package', :disableboot => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it { should contain_package('zabbix_agent').with_ensure('present') }
    it { should_not contain_service('zabbix_agent').with_ensure('present') }
    it { should_not contain_service('zabbix_agent').with_ensure('absent') }
    it 'should not enable at boot Service[zabbix_agent]' do should contain_service('zabbix_agent').with_enable('false') end
    it { should contain_file('zabbix_agent.conf').with_ensure('present') }
    it { should contain_monitor__process('zabbix_agent_process').with_enable('false') }
    it { should contain_firewall('zabbix_agent_tcp_42').with_enable('true') }
  end

  describe 'Test noops mode' do
    let(:params) { {:install => 'package', :noops => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it { should contain_package('zabbix_agent').with_noop('true') }
    it { should contain_service('zabbix_agent').with_noop('true') }
    it { should contain_file('zabbix_agent.conf').with_noop('true') }
    it { should contain_monitor__process('zabbix_agent_process').with_noop('true') }
    it { should contain_monitor__process('zabbix_agent_process').with_noop('true') }
    it { should contain_monitor__port('zabbix_agent_tcp_42').with_noop('true') }
    it { should contain_firewall('zabbix_agent_tcp_42').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "zabbix_agent/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
      content = catalogue.resource('file', 'zabbix_agent.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'zabbix_agent.conf').send(:parameters)[:content]
      content.should match "value_a"
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet:///modules/zabbix_agent/spec"} }
    it { should contain_file('zabbix_agent.conf').with_source('puppet:///modules/zabbix_agent/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/zabbix_agent/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('zabbix_agent.dir').with_source('puppet:///modules/zabbix_agent/dir/spec') }
    it { should contain_file('zabbix_agent.dir').with_purge('true') }
    it { should contain_file('zabbix_agent.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "zabbix_agent::spec" , :options => { 'opt_a' => 'value_a' } } }
    it { should contain_file('zabbix_agent.conf').with_content(/rspec.example42.com/) }
  end

  describe 'Test service autorestart' do
    let(:params) { {:service_autorestart => "no" } }
    it 'should not automatically restart the service, when service_autorestart => false' do
      content = catalogue.resource('file', 'zabbix_agent.conf').send(:parameters)[:notify]
      content.should be_nil
    end
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }
    it { should contain_puppi__ze('zabbix_agent').with_helper('myhelper') }
  end

  describe 'Test Monitoring Tools Integration' do
    let(:params) { {:monitor => true, :monitor_tool => "puppi" } }
    it { should contain_monitor__process('zabbix_agent_process').with_tool('puppi') }
  end

  describe 'Test Firewall Tools Integration' do
    let(:params) { {:firewall => true, :firewall_tool => "iptables" , :protocol => "tcp" , :port => "42" } }
    it { should contain_firewall('zabbix_agent_tcp_42').with_tool('iptables') }
  end

  describe 'Test OldGen Module Set Integration' do
    let(:params) { {:monitor => "yes" , :monitor_tool => "puppi" , :firewall => "yes" , :firewall_tool => "iptables" , :puppi => "yes" , :port => "42" , :protocol => 'tcp' } }
    it { should contain_monitor__process('zabbix_agent_process').with_tool('puppi') }
    it { should contain_firewall('zabbix_agent_tcp_42').with_tool('iptables') }
    it { should contain_puppi__ze('zabbix_agent').with_ensure('present') }
  end

  describe 'Test params lookup' do
    let(:facts) { 
    { :ipaddress => '10.42.42.42' ,
      :operatingsystem => 'Debian' ,
      :monitor => true ,
      :kernel    => 'Linux' }
    }
    let(:params) { { :port => '42' } }
    it 'should honour top scope global vars' do should contain_monitor__process('zabbix_agent_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { 
    { :ipaddress => '10.42.42.42' ,
      :operatingsystem => 'Debian' ,
      :zabbix_agent_monitor => false ,
      :kernel    => 'Linux' }
    }
    let(:params) { { :port => '42' } }
    it 'should honour module specific vars' do should contain_monitor__process('zabbix_agent_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { 
    { :ipaddress => '10.42.42.42' ,
      :operatingsystem => 'Debian' ,
      :_monitor => false ,
      :zabbix_agent_monitor => true ,
      :kernel    => 'Linux' }
    }
    let(:params) { { :port => '42' } }
    it 'should honour top scope module specific over global vars' do should contain_monitor__process('zabbix_agent_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) {
    { :ipaddress => '10.42.42.42' ,
      :operatingsystem => 'Debian' ,
      :monitor => false ,
      :kernel    => 'Linux' }
    }
    let(:params) { { :monitor => true , :firewall => true, :port => '42' } }
    it 'should honour passed params over global vars' do should contain_monitor__process('zabbix_agent_process').with_enable('true') end
  end

end

