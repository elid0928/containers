# MySQL Server Exporter packaged by Pacloud

## What is MySQL Server Exporter?

> MySQL Server Exporter gathers MySQL Server metrics for Prometheus consumption.

[Overview of MySQL Server Exporter](https://github.com/prometheus/mysqld_exporter)

Trademarks: This software listing is packaged by Pacloud. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run --name mysqld-exporter pacloud/mysqld-exporter:latest
```

## Why use Pacloud Images?

* Pacloud closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Pacloud images the latest bug fixes and features are available as soon as possible.
* Pacloud containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/pacloud/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Pacloud images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Pacloud container images are released on a regular basis with the latest distribution packages available.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.pacloud.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Pacloud tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.pacloud.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `pacloud/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [pacloud/containers GitHub repo](https://github.com/pacloud/containers).

## Get this image

The recommended way to get the Pacloud MySQL Server Exporter Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/pacloud/mysqld-exporter).

```console
$ docker pull pacloud/mysqld-exporter:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/pacloud/mysqld-exporter/tags/) in the Docker Hub Registry.

```console
$ docker pull pacloud/mysqld-exporter:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/pacloud/containers.git
$ cd pacloud/APP/VERSION/OPERATING-SYSTEM
$ docker build -t pacloud/APP:latest .
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
$ docker network create mysqld-exporter-network --driver bridge
```

#### Step 2: Launch the mysqld-exporter container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `mysqld-exporter-network` network.

```console
$ docker run --name mysqld-exporter-node1 --network mysqld-exporter-network pacloud/mysqld-exporter:latest
```

#### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Configuration

Find all the configuration flags in [the MySQL Server Exporter official documentation](https://github.com/prometheus/mysqld_exporter#collector-flags).

## Logging

The Pacloud MySQL Server Exporter Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs mysqld-exporter
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Pacloud provides up-to-date versions of MySQL Server Exporter, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull pacloud/mysqld-exporter:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop mysqld-exporter
```

#### Step 3: Remove the currently running container

```console
$ docker rm -v mysqld-exporter
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name mysqld-exporter pacloud/mysqld-exporter:latest
```

## Notable Changes

### 0.12.1-centos-7-r175

- `0.12.1-centos-7-r175` is considered the latest image based on CentOS.
- Standard supported distros: Debian & OEL.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/pacloud/containers/issues) or submitting a [pull request](https://github.com/pacloud/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/pacloud/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2023 Pacloud

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
