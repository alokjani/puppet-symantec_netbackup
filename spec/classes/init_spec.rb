require 'spec_helper'
describe 'symantec_netbackup' do

  context 'with defaults for all parameters' do
    it { should contain_class('symantec_netbackup') }
  end
end
