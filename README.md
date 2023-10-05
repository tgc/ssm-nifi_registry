# nifi_registry

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with nifi_registry](#setup)
    * [What nifi_registry affects](#what-nifi_registry-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nifi_registry](#beginning-with-nifi_registry)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

Install and configure the [Apache NiFi
Registry](https://nifi.apache.org/registry.html) which manages shared
resources for Apache NiFi.

## Setup

### What nifi_registry affects

This module will download the Apache NiFi Registry tarball to
`/var/tmp/`.

The tarball will be unpacked to `/opt/nifi-registry` by default.

NiFi Registry defaults to store logs and state and configuration within the
installation directory. This module changes this behaviour.

The module will create `/var/opt/nifi-registry`, for persistent storage outside
the software install root. This will also configure the following nifi registry
properties to create directories under this path.

- nifi.registry.extensions.working.directory
- nifi.registry.web.jetty.working.directory
- nifi.registry.db.url

The module will create `/var/log/nifi-registry`, and configures NiFi Registry
to write log files to this directory. NiFi Registry handles log rotation by
itself.

### Setup Requirements

NiFi Registry requires Java Runtime Environment. NiFi Registry 1.23.2 runs on
Java 8 or Java 11.

When installing on local infrastructure, consider download the
distribution tarballs, validate them with the Apache distribution
keys, and store it on a local repository. Adjust the configuration
variables to point to your local repository. The [NiFi Registry
download page](https://nifi.apache.org/registry.html) also documents
how to verify the integrity and authenticity of the downloaded files.

### Beginning with nifi_registry

Add dependency modules to your puppet environment:

- puppet/archive
- puppet/augeasproviders_shellvar
- puppet/systemd
- puppetlabs/inifile
- puppetlabs/java (optional, you can install java yourself)
- puppetlabs/stdlib

## Usage

To download and install NiFi Registry, include the module. This will
download nifi registry, unpack it under
`/opt/nifi-registry/nifi-registry-<version>`, and start the service
with default configuration and storage locations.

```puppet
include nifi_registry
```
To host the file locally, add a nifi_registry::download_url variable for the
module.

```yaml
nifi_registry::download_url: "http://my-local-repo.example.com/apache/nifi-registry/0.5.0/nifi-registry-0.5.0-bin.tar.gz"
```

Please keep `nifi_registry::download_url`,
`nifi_registry::download_checksum` and `nifi_registry::version` in
sync. The URL, checksum and version should match. Otherwise, Puppet
will become confused.

## Limitations

This module is under development, and therefore somewhat light on
functionality.

## Development

In the Development section, tell other users the ground rules for
contributing to your project and how they should submit their work.
