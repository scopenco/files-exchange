shared_examples 'httpd' do
  describe package('httpd') do
    it { should be_installed }
  end

  describe service('httpd') do
    it { should be_enabled }
    it { should be_running }
  end

  context 'Apache config correct' do
    describe command('httpd -t') do
      its(:exit_status) { should eq 0 }
    end
  end

  describe port(80) do
    it { should be_listening }
  end

  describe file('/etc/httpd/mods-enabled/wsgi.load') do
    it { should be_symlink }
  end

  describe file('/etc/httpd/mods-enabled/dav.load') do
    it { should be_symlink }
  end

  describe file('/etc/httpd/mods-enabled/dav_fs.load') do
    it { should be_symlink }
  end

  describe file('/etc/httpd/mods-enabled/rewrite.load') do
    it { should be_symlink }
  end

  describe user('fs') do
    it { should belong_to_group 'apache' }
  end

  describe file('/etc/httpd/conf-enabled/fileexchange.conf') do
    it { should be_symlink }
  end

  describe file('/etc/httpd/conf-available/fileexchange.conf') do
    it { should be_file }
    its(:content) { should match(%r{DocumentRoot "/opt/data"}) }
    its(:content) { should match(%r{CustomLog /var/log/httpd/access.log combined}) }
    its(:content) { should match(%r{Alias /header.html /opt/files-exchange/static/header.html}) }
    its(:content) { should match(/WSGIDaemonProcess fileshare user=fs group=fs threads=5/) }
  end

  describe file('/opt/files-exchange/htpasswd') do
    it { should be_file }
    its(:content) { should match(/test01:test01/) }
    its(:content) { should match(/test02:test02/) }
  end
end
