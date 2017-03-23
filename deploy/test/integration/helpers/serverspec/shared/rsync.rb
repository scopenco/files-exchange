shared_examples 'rsync' do
  describe package('rsync') do
    it { should be_installed }
  end

  describe package('xinetd') do
    it { should be_installed }
  end

  describe service('xinetd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(873) do
    it { should be_listening }
  end

  describe file('/usr/bin/rsyncd.sh') do
    it { should be_file }
    its(:content) { should match(%r{-d /opt/data}) }
    its(:content) { should match(/uid = apache/) }
    its(:content) { should match(/gid = apache/) }
    its(:content) { should match(%r{find /opt/data -maxdepth 0 -newer /etc/rsyncd.conf}) }
    its(:content) { should match(%r{log file = /var/log/rsync/rsyncd.log}) }
  end

  describe file('/var/log/rsync') do
    it { should be_directory }
    it { should be_owned_by 'apache' }
    it { should be_grouped_into 'apache' }
    it { should be_mode 750 }
  end
end
