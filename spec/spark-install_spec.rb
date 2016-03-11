require 'spec_helper'

describe 'apache_spark::spark-install' do
  context 'with default settings' do
    cached(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

    it 'creates the /opt/spark directory' do
      expect(chef_run).to create_directory('/opt/spark')
    end

    it 'gets the spark 1.5.2 binary' do
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/spark-1.5.2-bin-hadoop2.6.tgz")
    end

    it 'creates a link /usr/share/spark' do
      expect(chef_run).to create_link('/usr/share/spark')
    end

    %w(/usr/share/spark /usr/share/spark/conf /var/log/spark-standalone /var/spark-standalone-worker /var/local/spark).each do |directory|
      it "creates the #{directory} directory" do
        expect(chef_run).to create_directory(directory)
      end
    end

    it 'creates the spark-env.sh template in /usr/share/spark/conf' do
      expect(chef_run).to create_template('/usr/share/spark/conf/spark-env.sh')
    end

    it 'creates the log4j.properties template in /usr/share/spark/conf' do
      expect(chef_run).to create_template('/usr/share/spark/conf/log4j.properties')
    end

    it 'creates the spark-defaults.conf template in /usr/share/spark/conf' do
      expect(chef_run).to create_template('/usr/share/spark/conf/spark-defaults.conf')
    end
  end
end
