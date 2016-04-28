define users::managed_user (
  $username = $title,
  $homedir = "/home/${title}",
  $group = $title,
  $ensure = 'present',
  
) {
  user { $username:
    ensure => $ensure,
    group => $group,
    home => $homedir
  }
  file { ssh_dir:
    ensure => directory,
    path => "${homedir}/.ssh"
  }
    
}
