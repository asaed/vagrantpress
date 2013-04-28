class wordpress::install{
  
  # Create the wordpress database
  exec{"create-database":
    unless=>"/usr/bin/mysql -u root -pvagrant wordpress",
    command=>"/usr/bin/mysql -u root -pvagrant --execute=\"create database wordpress\"",
  }
  
  # Create a MySQL user for wordpress.
  exec{"create-user":
    unless=>"/usr/bin/mysql -u wordpress -pwordpress",
    command=>"/usr/bin/mysql -u root -pvagrant --execute=\"GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'wordpress' \"",
  }
  
  # Get a new copy of wordpress from github
  exec{"git-wordpress": #tee hee
    command=>"/usr/bin/git clone git://github.com/WordPress/WordPress.git wordpress",
    cwd=>"/vagrant/",
    creates => "/vagrant/wordpress"
  }
  
  exec{"git-35":
    command=>"/usr/bin/git checkout 3.5.1",
    cwd=>"/vagrant/wordpress",
    creates => "/vagrant/wordpress"
  }
  
  # Import a MySQL database for a basic wordpress site.
  file{
    "/tmp/wordpress-db.sql":
    source=>"puppet:///modules/wordpress/wordpress-db.sql"
  }
  
  exec{"load-db":
    command=>"/usr/bin/mysql -u wordpress -pwordpress wordpress < /tmp/wordpress-db.sql"
  }
  
  # Copy a working wp-config.php file for the vagrant setup.
  file{
    "/vagrant/wordpress/wp-config.php":
    source=>"puppet:///modules/wordpress/wp-config.php"
  }
  
  # create an empty log file 
  file { 
    "/vagrant/logs/": 
    ensure => directory 
  }
  file { 
	"/vagrant/logs/php-errors.log":
	source=>"puppet:///modules/wordpress/php-errors.log"
  }
  
}