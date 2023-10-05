# @summary Manage configuration for Apache NiFi Registry
#
# Private subclass for Apache NiFi Registry configuration
#
# @api private
class nifi_registry::config (
  Stdlib::Absolutepath $install_root,
  Stdlib::Absolutepath $var_directory,
  Stdlib::Absolutepath $config_directory,
  Stdlib::Absolutepath $log_directory,
  String $user,
  String $group,
  String $version,
  Boolean $cluster = false,
  Hash[
    Stdlib::Fqdn, Struct[{ id => Integer[1,255] }]
  ] $cluster_nodes = {},
  Optional[String] $initial_admin_identity = undef,
  Hash[String,Nifi::Property] $nifi_registry_properties = {},
) {
  $software_directory = "${install_root}/nifi-registry-${version}"

  $nifi_registry_properties_file = "${software_directory}/conf/nifi-registry.properties"

  # lint:ignore:140chars
  $path_properties = {
    'nifi.registry.extensions.working.directory'   => "${var_directory}/work/extensions/",
    'nifi.registry.web.jetty.working.directory'    => "${var_directory}/work/jetty",
    'nifi.registry.db.url'                         => "jdbc:h2:${var_directory}/database/nifi-registry-primary;AUTOCOMMIT=OFF;DB_CLOSE_ON_EXIT=FALSE;LOCK_MODE=3;LOCK_TIMEOUT=25000;WRITE_DELAY=0;AUTO_SERVER=FALSE",
  }
  # lint:endignore

  $_nifi_properties = $path_properties + $nifi_registry_properties

  $_nifi_properties.each |String $key, Nifi::Property $value| {
    ini_setting { "nifi registry property ${key}":
      ensure  => present,
      path    => $nifi_registry_properties_file,
      setting => $key,
      value   => $value,
    }
  }

  $authorizers_properties = {
    'cluster' => $cluster,
    'cluster_nodes' => $cluster_nodes,
    'config_directory' => $config_directory,
    'initial_admin_identity' => $initial_admin_identity,
  }

  file { "${config_directory}/authorizers.xml":
    ensure  => file,
    content => epp('nifi_registry/authorizers.xml.epp', $authorizers_properties),
    owner   => 'root',
    group   => $group,
    mode    => '0640',
  }

  file { "${var_directory}/database":
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0750',
  }

  # Unfortunately NiFi Registry is not setup like NiFi and there is no way to
  # override the log directory without modifying the env script (as of 1.23.2)
  shellvar { 'NIFI_REGISTRY_LOG_DIR':
    ensure  => exported,
    target  => "${software_directory}/bin/nifi-registry-env.sh",
    value   => $log_directory,
  }
}
