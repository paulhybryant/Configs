# Add cross-build capability to a Centos 7 image.

## Intro

If you are like me and you are interested in building containers for the aarch64/arm64 chip architecture then you have come to the right place. This git repo adds qemu to an aarch64 Alpine 3.5 image. It also contains a go based script that allows you do start intercepting all shell commands and start executing them on qemu. This allows you to build aarch64 images on a x86 machine like dockerhub!

## Use the cross-build container

We've already done the work below and our container can be found here:

https://hub.docker.com/r/project31/aarch64-centos-qemu/

Now you can start using it in your Dockerfile. Simply use

```
FROM docker.io/project31/aarch64-centos-qemu
RUN [ "cross-build-start" ]
...
whatever you need to do in your Dockerfile
...
RUN [ "cross-build-end" ]
```

For a working example see: https://hub.docker.com/r/project31/aarch64-docker-openvpn/~/dockerfile/
That's it! Or you can read on if you want to build it yourself. 

## Build the static aarch64 qemu binary

Feel free to skip this if you don't want to build your own qemu as a static qemu binary is already provided in the bin directory. This binary emulates a aarch64 architure while running on x86.  To build it, we added a build script in the qemu directory. This script is meant to be executed inside a debian container, so use

```
docker run -it debian bash
```

and then run the build script. If you want to build a static qemu image for plain arm, you should change the `--target-list=aarch64-linux-user` configuration option to `--target-list=arm-linux-user`. Make sure to only ship one qemu library in your docker container, or the resin-xbuild.go script may get tripped up. Finally copy the qemu binary into the bin directory of this project.

## Build the cross-build scripts.

Feel free to skip this step if you don't want to compile your own scripts. The cross-build scripts are meant to be executed on x86. So if you want to rebuild this script please use GOARCH=amd64. A compiled version is already supplied in the bin directory.

## Build the Docker base container.

To build the docker container use

```
docker build . 
```

## Reference

[1] Build ARM container on x86: https://resin.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/

