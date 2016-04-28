class nginx {
  package {'nginx':
    ensure => present,
  }
  file {'doc_root':
    path => '/var/www',
    ensure => directory,
    before => File['index.html'],
  }
  file {'index.html':
    path => '/var/www/index.html',
    ensure => present,
    source => 'puppet:///modules/nginx/index.html',
    before => Service['nginx']
  }
  file {'conf_dir':
    path => '/etc/nginx',
    ensure => directory,
    depends => Package['nginx'],
  }
  file {'conf_subdir':
    path => '/etc/nginx/conf.d',
    ensure => directory,
    depends => File['conf_dir'],
  }
  file {'main_server':
    path => '/etc/nginx/nginx.conf',
    ensure => present,
    source => 'puppet:///modules/nginx/nginx.conf',
    require => File['conf_dir'],
  }
  file {'server_block':
    path => '/etc/nginx/conf.d/default.conf',
    ensure => present,
    source => 'puppet:///modules/nginx/default.conf',
    require => File['conf_subdir'],
  }
  service {'nginx':
    ensure => running,
    enable => true,
    subscribe => File['server_block'],
  }

}
