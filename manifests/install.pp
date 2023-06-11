# @summary Install Apache Nifi Registry
#
# Private subclass for installing Apache Nifi Registry.
#
# @api private
class nifi_registry::install (
  Stdlib::Absolutepath $install_root,
  String $version,
  String $download_url,
  String $download_checksum,
  String $download_checksum_type,
  Stdlib::Absolutepath $download_tmp_dir,
  String $user,
  String $group,
) {
  $local_tarball = "${download_tmp_dir}/nifi-registry-${version}.tar.gz"
  $software_directory = "${install_root}/nifi-registry-${version}"

  archive { $local_tarball:
    source        => $download_url,
    checksum      => $download_checksum,
    checksum_type => $download_checksum_type,
    extract       => true,
    extract_path  => $install_root,
    creates       => $software_directory,
    cleanup       => true,
    user          => $user,
    group         => $group,
  }

  file { "${install_root}/current":
    ensure => link,
    target => $software_directory,
  }

  user { $user:
    system => true,
    gid    => $group,
    home   => $install_root,
  }

  group { $group:
    system => true,
  }

  file { $install_root:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0750',
  }
}
