class nginx (
$root = undef
) inherits nginx::params {

  if $root == undef {
    $master_docroot = $docroot
  } else {
    $master_docroot = $root
  }
  
  File {
    mode => '0644',
    owner => $owner,
    group => $group,
  }
  
  package {$package:
    ensure => present,
  }
  file {'doc_root':
    path => $master_docroot,
    ensure => directory,
    before => File['index.html'],
  }
  file {'index.html':
    path => "${master_docroot}/index.html",
    ensure => present,
    source => 'puppet:///modules/nginx/index.html',
    before => Service[$service]
  }
  file {'conf_dir':
    path => $confdir,
    ensure => directory,
    require => Package[$package],
  }
  file {'conf_subdir':
    path => $blockdir,
    ensure => directory,
    require => File['conf_dir'],
  }
  file {'main_server':
    path => "${confdir}/nginx.conf",
    ensure => present,
    content => template('nginx/nginx.conf.erb'),
    require => File['conf_dir'],
  }
  file {'server_block':
    path => "${blockdir}/default.conf",
    ensure => present,
    content => template('nginx/default.conf.erb'),
    require => File['conf_subdir'],
  }
  service {'nginx':
    ensure => running,
    enable => true,
    subscribe => [ File['main_server'],File['server_block']],
  }

}
