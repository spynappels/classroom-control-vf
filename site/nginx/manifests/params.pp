class nginx::params {
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
    default: {
     fail("Module ${module_name} is not supported on ${::osfamily}") 
    }
  }
}
