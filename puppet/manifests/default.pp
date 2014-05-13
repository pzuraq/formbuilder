$ar_databases = ['activerecord_unittest', 'activerecord_unittest2']
$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

# Pick a Ruby version modern enough, that works in the currently supported Rails
# versions, and for which RVM provides binaries.
$ruby_version = '2.1.1'

# Password
$password = 'hDprK5pvXp6FavcAn6c4jUpGXScSK5SrfBFYxU2mrPuwZ2tjQfx9HA7pMu'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':
    unless => "test -e ${home}/.rvm"
  }
}
class { 'apt_get_update':
  stage => preinstall
}

# --- PostgreSQL ---------------------------------------------------------------

class install_postgres {
  class { 'postgresql::globals':
    encoding            => 'UTF8',
    locale              => 'en_NG',
    manage_package_repo => true,
    version             => '9.3',
  }->
  class { 'postgresql::server': }
  class { 'postgresql::server::contrib': }
  class { 'postgresql::lib::devel': }

  postgresql::server::role { "vagrant":
    superuser => true,
  }

  postgresql::server::db { 'formbuilder':
    user => 'vagrant',
    password => "${password}"
  }

  postgresql::server::db { 'formbuilder_test':
    user => 'vagrant',
    password => "${password}"
  }
}
class { 'install_postgres': }

# --- Memcached ----------------------------------------------------------------

class { 'memcached': }

# --- Packages -----------------------------------------------------------------

# Stuff
package { ['curl', 'build-essential', 'zlib1g-dev', 'libssl-dev', 'libreadline-dev']:
  ensure => installed,
}

# Postgres dependencies
package { 'postgresql-server-dev-9.1':
  ensure => installed
}

# RMagick dependencies
package { ['libmagickwand4', 'libmagickwand-dev']:
  ensure => installed
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

# ExecJS runtime.
package { 'nodejs':
  ensure => installed
}

# --- Ruby ---------------------------------------------------------------------

class install_rbenv {
  rbenv::install { 'vagrant': }
  rbenv::compile { "${ruby_version}":
    user => 'vagrant',
    global => true
  }
}
class { 'install_rbenv': }
# --- Locale -------------------------------------------------------------------

# Needed for docs generation.
exec { 'update-locale':
  command => 'update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8'
}
