shared_examples 'vsftpd' do
  describe package('vsftpd') do
    it { should be_installed }
  end

  describe service('vsftpd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(21) do
    it { should be_listening }
  end

  describe file('/etc/vsftpd/vsftpd.conf') do
    it { should be_file }
    its(:content) { should match(%r{anon_root=/opt/data}) }
  end
end
