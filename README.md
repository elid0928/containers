[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://github.com/pacloud/containers/blob/main/CONTRIBUTING.md)
[![[CI/CD] CD Pipeline](https://github.com/pacloud/containers/actions/workflows/cd-pipeline.yml/badge.svg)](https://github.com/pacloud/containers/actions/workflows/cd-pipeline.yml)

# The Pacloud Containers Library

Popular applications, provided by [Pacloud](https://pacloud.com), containerized and ready to launch.

## Why use Pacloud Images?

* Pacloud closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Pacloud images the latest bug fixes and features are available as soon as possible.
* Pacloud containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/pacloud/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Pacloud images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Pacloud container images are released on a regular basis with the latest distribution packages available.

## Get an image

The recommended way to get any of the Pacloud Images is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/pacloud/).

```console
$ docker pull pacloud/APP
```

To use a specific version, you can pull a versioned tag.

```console
$ docker pull pacloud/APP:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command.

```console
$ git clone https://github.com/pacloud/containers.git
$ cd pacloud/APP/VERSION/OPERATING-SYSTEM
$ docker build -t pacloud/APP .
```

> Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` placeholders in the example command above with the correct values.

## Run the application using Docker Compose

The main folder of each application contains a functional `docker-compose.yml` file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/pacloud/containers/main/pacloud/APP/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

> Remember to replace the `APP` placeholder in the example command above with the correct value.

## Vulnerability scan in Pacloud container images

As part of the release process, the Pacloud container images are analyzed for vulnerabilities. At this moment, we are using two different tools:

* [Trivy](https://github.com/aquasecurity/trivy)
* [Grype](https://github.com/anchore/grype)

This scanning process is triggered via a GH action for every PR affecting the source code of the containers, regardless of its nature or origin.

## Contributing

We'd love for you to contribute to those container images. You can request new features by creating an [issue](https://github.com/pacloud/containers/issues/new/choose), or submit a [pull request](https://github.com/pacloud/containers/pulls) with your contribution.

## License

Copyright &copy; 2023 Pacloud

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
