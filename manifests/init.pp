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
# @param download_archive_type
#   The archive type of the downloaded tarball.
#
# @param download_checksum
#   The expected checksum of the downloaded tarball. This is used for
#   verifying the integrity of the downloaded tarball.
#
# @param download_checksum_type
#   The checksum type of the downloaded tarball. This is used for
#   verifying the integrity of the downloaded tarball.
#
# @param download_tmp_dir
#   Temporary directory for downloading the tarball.
#
# @param install_root
#   The root directory of the nifi registry installation.
#
# @param var_directory
#   The root of the writable paths used by NiFi Registry. NiFi Registry will
#   create directories beneath this path.  This will implicitly add
#   nifi registry properties for working directories and repositories.
#
# @param log_directory
#   The directory where NiFi stores its user, app and bootstrap logs. Nifi will
#   create log files beneath this path and take care of log rotation and
#   deletion.
#
# @param config_directory
#   Directory for NiFi Registry version independent configuration files to be
#   kept across NiFi Registry version upgrades. NiFi Registry will also write
#   generated configuration files to this directory. This is used in addition
#   to the "./conf" directory within each NiFi Registry installation.
#
# @param nifi_registry_properties
#   Hash of parameter key/values to be added to conf/nifi-registry.properties.
#
# @param cluster
#   If true, the cluster_nodes parameter is used to configure authorization for
#   the nodes.
#
# @param cluster_nodes
#   A hash of NiFi Registry cluster nodes and their ID. The ID must be an
#   integer between 1 and 255, unique in the cluster, and must not be
#   changed once set.
#
#   The hash must be structured like { 'fqdn.example.com' => { 'id' => 1 },... }
#
#   The identity of the NiFi nodes that will have access to this NiFi Registry
#   and will be able to act as a proxy on behalf of a NiFi Registry end user.
#
# @param initial_admin_identity
#   The initial admin identity used in the authorizers.xml file by NiFi Registry
#   This is useful when connecting NiFi Registry to an external authentication
#   source.
#
# @example Defaults
#   include nifi_registry
#
# @example Downloading from a different repository
#   class { 'nifi_registry':
#     version           => 'x.y.z',
#     download_url      => 'https://my.local.repo.example.com/apache/nifi-registry/nifi-registry-x.y.z.tar.gz',
#     download_checksum => 'abcde...',
#   }
#
# @example Configuring NiFi Registry with NiFi cluster node access
#   class { 'nifi_registry':
#     cluster       => true,
#     cluster_nodes => {
#       'nifi-1.example.com' => { 'id' => 1 },
#       'nifi-2.example.com' => { 'id' => 2 },
#       'nifi-3.example.com' => { 'id' => 3 },
#     }
#   }
#
class nifi_registry (
  String $version = '1.23.2',
  Enum['zip', 'tar.gz'] $download_archive_type = 'zip',
  String $download_url = "https://dlcdn.apache.org/nifi/${version}/nifi-registry-${version}-bin.${download_archive_type}",
  String $download_checksum = 'b6609c1e06e270b54c58b1a5cfabe1b9239db1a12142c27949f37c96f9f7880e',
  String $download_checksum_type = 'sha256',
  Stdlib::Absolutepath $download_tmp_dir = '/var/tmp',
  String $user = 'nifiregistry',
  String $group = 'nifiregistry',
  Hash[String,Nifi::Property] $nifi_registry_properties = {},
  Stdlib::Absolutepath $install_root = '/opt/nifi-registry',
  Stdlib::Absolutepath $var_directory = '/var/opt/nifi-registry',
  Stdlib::Absolutepath $log_directory = '/var/log/nifi-registry',
  Stdlib::Absolutepath $config_directory = '/opt/nifi-registry/config',
  Boolean $cluster = false,
  Hash[
    Stdlib::Fqdn, Struct[{ id => Integer[1,255] }]
  ] $cluster_nodes = {},
  Optional[String] $initial_admin_identity = undef,
) {
  class { 'nifi_registry::install':
    install_root           => $install_root,
    version                => $version,
    user                   => $user,
    group                  => $group,
    download_archive_type  => $download_archive_type,
    download_url           => $download_url,
    download_checksum      => $download_checksum,
    download_checksum_type => $download_checksum_type,
    download_tmp_dir       => $download_tmp_dir,
    config_directory       => $config_directory,
    var_directory          => $var_directory,
    log_directory          => $log_directory,
  }

  class { 'nifi_registry::config':
    install_root             => $install_root,
    user                     => $user,
    group                    => $group,
    config_directory         => $config_directory,
    var_directory            => $var_directory,
    nifi_registry_properties => $nifi_registry_properties,
    version                  => $version,
    cluster                  => $cluster,
    cluster_nodes            => $cluster_nodes,
    initial_admin_identity   => $initial_admin_identity,
    log_directory            => $log_directory,
  }

  class { 'nifi_registry::service':
    install_root => $install_root,
    version      => $version,
    user         => $user,
  }

  Class['nifi_registry::install'] -> Class['nifi_registry::config'] ~> Class['nifi_registry::service']
}
