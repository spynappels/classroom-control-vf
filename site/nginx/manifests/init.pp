class nginx (
$root = undef
){

case $::osfamily {
  'redhat' : {
    $package = 'nginx'
    $owner = 'root'
    $group = 'root'
    $docroot = '/var/www'
    $confdir = '/etc/nginx'
    $blockdir = '/etc/nginx/conf.d'
    $logdir = '/var/log/nginx'
    $nginxuser = 'nginx'
    }
  'debian' : {
    $package = 'nginx'
    $owner = 'root'
    $group = 'root'
    $docroot = '/var/www'
    $confdir = '/etc/nginx'
    $blockdir = '/etc/nginx/conf.d'
    $logdir = '/var/log/nginx'
    $nginxuser = 'www-data'
    }
  'windows' : {
    $package = 'nginx-service'
    $owner = 'Administrator'
    $group = 'Administrators'
    $docroot = 'C:/ProgramData/nginx/html'
    $confdir = 'C:/ProgramData/nginx'
    $blockdir = 'C:/ProgramData/nginx/conf.d'
    $logdir = 'C:/ProgramData/nginx/logs'
    $nginxuser = 'nobody'
    }
  }
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
    path => "${docroot}/index.html",
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
