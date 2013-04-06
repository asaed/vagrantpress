class apache2::install{
  
  package { "apache2": ensure => present,}

    service { "apache2":
      ensure => running,
      require => Package["apache2"],
    }

    file { '/var/www':
      ensure => link,
      target => "/vagrant",
      notify => Service['apache2'],
      force  => true
    }
	
	# create an empty log file 
  file { 
	"/etc/apache2/ports.conf":
	source=>"puppet:///modules/apache2/ports.conf"
  }
  }
