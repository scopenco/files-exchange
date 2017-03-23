require 'spec_helper'
require 'shared/application'
require 'shared/httpd'
require 'shared/vsftpd'
require 'shared/rsync'
require 'shared/iptables'

describe 'application' do
  include_examples 'application'
end

describe 'httpd' do
  include_examples 'httpd'
end

describe 'vsftpd' do
  include_examples 'vsftpd'
end

describe 'rsync' do
  include_examples 'rsync'
end

describe 'iptables' do
  include_examples 'iptables'
end
