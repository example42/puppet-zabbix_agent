require 'spec_helper'

describe 'zabbix_agent' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:title) { 'zabbix_agent' }
      let(:node) { 'rspec.example42.com' }

      describe 'Test standard installation' do
        let(:params) do
          {
            package_source: '/opt/package/zabbix_agent.rpm',
          }
        end

        it { is_expected.to contain_package('zabbix_agent') }
        it { is_expected.to contain_service('zabbix_agent').with_ensure('running') }
        it { is_expected.to contain_service('zabbix_agent').with_enable('true') }
        it { is_expected.to contain_file('zabbix_agent.conf').with_ensure('present') }
      end

      describe 'Test installation of a specific version' do
        let(:params) do
          {
            install: 'package',
            version: '1.0.42',
            package_source: '/opt/package/zabbix_agent.rpm',
          }
        end

        it { is_expected.to contain_package('zabbix_agent').with_ensure('1.0.42') }
      end

      describe 'Test decommissioning - absent' do
        let(:params) do
          {
            install: 'package',
            absent: true,
            package_source: '/opt/package/zabbix_agent.rpm',
          }
        end

        it 'does remove Package[zabbix_agent]' do
          is_expected.to contain_package('zabbix_agent').with_ensure('absent')
        end
        it 'does stop Service[zabbix_agent]' do
          is_expected.to contain_service('zabbix_agent').with_ensure('stopped')
        end
        it 'does not enable at boot Service[zabbix_agent]' do
          is_expected.to contain_service('zabbix_agent').with_enable('false')
        end
        it 'does remove zabbix_agent configuration file' do
          is_expected.to contain_file('zabbix_agent.conf').with_ensure('absent')
        end
      end

      describe 'Test decommissioning - disable' do
        let(:params) do
          {
            install: 'package',
            disable: true,
            package_source: '/opt/package/zabbix_agent.rpm',
          }
        end

        it { is_expected.to contain_package('zabbix_agent').with_ensure('present') }
        it 'does stop Service[zabbix_agent]' do
          is_expected.to contain_service('zabbix_agent').with_ensure('stopped')
        end
        it 'does not enable at boot Service[zabbix_agent]' do
          is_expected.to contain_service('zabbix_agent').with_enable('false')
        end
        it { is_expected.to contain_file('zabbix_agent.conf').with_ensure('present') }
      end

      describe 'Test decommissioning - disableboot' do
        let(:params) do
          {
            install: 'package',
            disableboot: true,
            package_source: '/opt/package/zabbix_agent.rpm',
          }
        end

        it { is_expected.to contain_package('zabbix_agent').with_ensure('present') }
        it { is_expected.not_to contain_service('zabbix_agent').with_ensure('present') }
        it { is_expected.not_to contain_service('zabbix_agent').with_ensure('absent') }
        it 'does not enable at boot Service[zabbix_agent]' do
          is_expected.to contain_service('zabbix_agent').with_enable('false')
        end
        it { is_expected.to contain_file('zabbix_agent.conf').with_ensure('present') }
      end

      describe 'Test customizations - template' do
        let(:params) do
          {
            template: 'zabbix_agent/spec.erb',
            options: { 'opt_a' => 'value_a' },
            package_source: '/opt/package/zabbix_agent.rpm',
          }
        end

        it 'does generate a valid template' do
          content = catalogue.resource('file', 'zabbix_agent.conf').send(:parameters)[:content]
          expect(content).to match('fqdn: rspec.example42.com')
        end
        it 'does generate a template that uses custom options' do
          content = catalogue.resource('file', 'zabbix_agent.conf').send(:parameters)[:content]
          expect(content).to match('value_a')
        end
      end

      describe 'Test customizations - source' do
        let(:params) do
          {
            source: 'puppet:///modules/zabbix_agent/spec',
            package_source: '/opt/package/zabbix_agent.rpm',
          }
        end

        it { is_expected.to contain_file('zabbix_agent.conf').with_source('puppet:///modules/zabbix_agent/spec') }
      end

      describe 'Test customizations - source_dir' do
        let(:params) do
          {
            source_dir: 'puppet:///modules/zabbix_agent/dir/spec',
            source_dir_purge: true,
            package_source: '/opt/package/zabbix_agent.rpm',
          }
        end

        it { is_expected.to contain_file('zabbix_agent.dir').with_source('puppet:///modules/zabbix_agent/dir/spec') }
        it { is_expected.to contain_file('zabbix_agent.dir').with_purge('true') }
        it { is_expected.to contain_file('zabbix_agent.dir').with_force('true') }
      end

      describe 'Test customizations - custom class' do
        let(:params) do
          {
            my_class: 'zabbix_agent::spec',
            options: { 'opt_a' => 'value_a' },
            package_source: '/opt/package/zabbix_agent.rpm',
          }
        end

        it { is_expected.to contain_file('zabbix_agent.conf').with_content(%r{rspec.example42.com}) }
      end

      describe 'Test service autorestart' do
        let(:params) do
          {
            service_autorestart: false,
            package_source: '/opt/package/zabbix_agent.rpm',
          }
        end

        it 'does not automatically restart the service, when service_autorestart => false' do
          content = catalogue.resource('file', 'zabbix_agent.conf').send(:parameters)[:notify]
          expect(content).to be_nil
        end
      end
    end
  end
end
