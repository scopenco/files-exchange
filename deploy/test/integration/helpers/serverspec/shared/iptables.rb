shared_examples 'iptables' do
  describe iptables do
    it { should have_rule(/-A ftp -p tcp -m multiport --dports 21 -m conntrack --ctstate NEW -m comment --comment ftp -j ACCEPT/) }
    it { should have_rule(/-A rsync -p tcp -m multiport --dports 873 -m conntrack --ctstate NEW -m comment --comment rsync -j ACCEPT/) }
    it { should have_rule(/-A web -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW -m comment --comment web -j ACCEPT/) }
  end
end
