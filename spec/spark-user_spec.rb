require 'spec_helper'

describe 'apache_spark::spark-user' do
  context 'with default settings' do
    cached(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

    it 'creates the group "spark"' do
      expect(chef_run).to create_group('spark')
    end

    it 'creates the user "spark"' do
      expect(chef_run).to create_user('spark')
    end
  end

  context 'with a defined uid of 1550' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['apache_spark']['uid'] = 1550
      end.converge(described_recipe)
    end

    it 'creates the user "spark" with uid 1550' do
      expect(chef_run).to create_user('spark').with(
        uid: 1550
      )
    end
  end
end
