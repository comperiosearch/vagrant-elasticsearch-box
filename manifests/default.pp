define append_if_no_such_line($file, $line, $refreshonly = 'false') {
   exec { "/bin/echo '$line' >> '$file'":
      unless      => "/bin/grep -Fxqe '$line' '$file'",
      path        => "/bin",
      refreshonly => $refreshonly,
   }
}

class must-have {
  include yum
   
 
  #package { ['vim', 'curl', 'git', 'bash']:
  #  ensure => present,
  #  require => Exec['yum-update'],
#  }

 

  class { 'puppi': }

  class { 'elasticsearch':
    package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.0.Beta2.noarch.rpm',
    config => {
      'cluster.name' => 'vagrant_elasticsearch',
      'node.name' => $::ipaddress,
      'index' => {
        'number_of_replicas' => '0',
        'number_of_shards' => '1',
      },
      'network' => {
        'host' => $::ipaddress,
      },
      'path' => {
        'conf' => '/elasticsearch_home/config',
        'data' => '/vagrant/sample_data',
        'work' => '/elasticsearch_home/work',
        'logs' => '/elasticsearch_home/logs',
        'plugins' => '/elasticsearch_home/plugins'
      }
    }
  }
}

include oracle_java
include must-have

