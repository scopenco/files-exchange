shared_examples 'application' do
  describe yumrepo('epel') do
    it { should exist }
    it { should be_enabled }
  end

  describe file('/opt/files-exchange') do
    it { should be_symlink }
  end

  describe command('pip show flask') do
    its(:stdout) { should match(/Version: 0.10.1/) }
  end

  describe command('pip show crowd') do
    its(:stdout) { should match(/Version: 0.9.0/) }
  end

  describe command('pip show flask-mail') do
    its(:exit_status) { should eq 0 }
  end

  describe command('pip show passlib') do
    its(:exit_status) { should eq 0 }
  end

  describe command('pip show python-ldap') do
    its(:exit_status) { should eq 0 }
  end

  describe user('fs') do
    it { should exist }
    it { should have_uid 498 }
  end

  describe group('fs') do
    it { should exist }
    it { should have_gid 498 }
  end

  describe file('/opt/fe_deploy/shared/database.db') do
    it { should be_file }
    it { should be_owned_by 'fs' }
    it { should be_grouped_into 'fs' }
    it { should be_mode 640 }
  end

  describe file('/opt/fe_deploy/shared/config.py') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match(%r{HOMEDIR = '/opt/data'}) }
    its(:content) { should match(/UID = 498/) }
    its(:content) { should match(/GID = 48/) }
    its(:content) { should match(/RO_GID = 498/) }
    its(:content) { should match(%r{DATABASE = '/opt/fe_deploy/shared/database.db'}) }
    its(:content) { should match(%r{AUTH_BASIC_FILE = '/opt/files-exchange/htpasswd'}) }
  end

  describe file('/opt/fe_deploy/shared/wsgi.py') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match(%r{/opt/files-exchange}) }
  end

  describe command('curl -v http://localhost/') do
    its(:stderr) { should match(%r{HTTP/1.1 302 Found}) }
  end

  describe command('curl -u test01:test01 -v http://localhost/fe/') do
    its(:stderr) { should match(%r{HTTP/1.1 200 OK}) }
    its(:stdout) { should match(%r{<h4>Dear test01,</h4>}) }
  end
end
