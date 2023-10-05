# @summary Manage Apache NiFi Registry
#
# Install, configure and run Apache NiFi Registry
#
# @param version
#   The version of Apache NiFi Registry. This must match the version
#   in the tarball. This is used for managing files, directories and
#   paths in the service.
#
# @param user
#   The user owning the nifi registry installation files, and running
#   the service.
#
# @param group
#   The group owning the nifi registry installation files, and running
#   the service.
#
# @param download_url
#   Where to download the binary installation tarball from.
#
# @param download_checksum
#   The expected checksum of the downloaded tarball. This is used for
#   verifying the integrity of the downloaded tarball.
#
# @param download_checksum_type
#   The checksum type of the downloaded tarball. This is used for
#   verifying the integrity of the downloaded tarball.
#
# @param install_root
#   The root directory of the nifi registry installation.
#
# @example Defaults
#   include nifi_registry
#
# @example Downloading from a different repository
#   class { 'nifi_registry':
#     version                => 'x.y.z',
#     download_url           => 'https://my.local.repo.example.com/apache/nifi-registry/nifi-registry-x.y.z.tar.gz',
#     download_checksum      => 'abcde...',
#   }
#
class nifi_registry (
  String $version = '1.15.1',
  String $download_url = 'https://dlcdn.apache.org/nifi/1.15.1/nifi-registry-1.15.1-bin.tar.gz',
  String $download_checksum = '862e6071a39fe94485a90a69637dccf594d319d8f98739a63828bb2d74af840e',
  Stdlib::Absolutepath $download_tmp_dir = '/var/tmp',
  String $user = 'nifiregistry',
  String $group = 'nifiregistry',
  String $download_checksum_type = 'sha256',
  Stdlib::Absolutepath $install_root = '/opt/nifi-registry',
) {
  class { 'nifi_registry::install':
    install_root           => $install_root,
    version                => $version,
    user                   => $user,
    group                  => $group,
    download_url           => $download_url,
    download_checksum      => $download_checksum,
    download_checksum_type => $download_checksum_type,
    download_tmp_dir       => $download_tmp_dir,
  }

  include nifi_registry::config

  class { 'nifi_registry::service':
    install_root => $install_root,
    version      => $version,
    user         => $user,
  }

  Class['nifi_registry::install'] -> Class['nifi_registry::config'] ~> Class['nifi_registry::service']
}
