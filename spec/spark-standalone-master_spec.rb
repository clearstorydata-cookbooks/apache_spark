require 'spec_helper'

describe 'apache_spark::spark-standalone-master' do
  context 'with default settings' do
    cached(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

    it 'adds the master runner script' do
      expect(chef_run).to create_template('/usr/share/spark/bin/master_runner.sh').with(
        source: 'spark_master_runner.sh.erb',
        mode: 0744,
        owner: 'spark',
        group: 'spark'
      )
    end
  end
end
