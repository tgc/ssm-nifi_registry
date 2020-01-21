# @summary Manage the Apache Nifi Registry service
#
# Private subclass for running Apache Nifi Registry as a service
#
# @api private
class nifi_registry::service (
  Stdlib::Absolutepath $install_root,
  String $version,
  String $user,
) {

  $service_params = {
    'install_dir' => "${install_root}/nifi-registry-${version}",
    'user'        => $user,
  }

  systemd::unit_file { 'nifi-registry.service':
    content => epp('nifi_registry/nifi-registry.service.epp', $service_params),
    enable  => true,
    active  => true,
  }
}
