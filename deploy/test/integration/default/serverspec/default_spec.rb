require 'spec_helper'
require 'shared/application'
require 'shared/httpd'
require 'shared/vsftpd'
require 'shared/rsync'

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
