

## Cross Compile for Linux

    brew install --cask docker
    docker --version
>     Docker version 27.1.1, build 6312585

Want to start with a Docker image from Conan: `conanio/gcc9`

When you run docker build, the Docker daemon reads the Dockerfile and executes each instruction in order, generating a layered image.

docker build -f [DockerfileName]

mkdir docker-demo
cd docker-demo

create

* [index.html]()
```file
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>Simple App</title>
  </head>
  <body>
    <h1>Hello World</h1>
    <p>This is running in a docker container</p>
  </body>
</html>
```

* [Dockerfile]()
```file
FROM nginx:stable-alpine3.17-slim
COPY index.html /usr/share/nginx/html

EXPOSE 80 
CMD ["nginx", "-g", "daemon off;"]
```


    docker build -t sampleapp:v1 .


>    Cannot connect to the Docker daemon at unix:///var/run/docker.sock.
>    Is the docker daemon running?

on macOS, I needed to launch the Docker application and sign in

    open -a Docker

## Build and Run

    docker build -t sampleapp:v1 .
    docker run -p 8080:80 sampleapp:v1
    open http://localhost:8080/

## Conan

`-v$(pwd):/somewhere`
Shares current directory with the docker containe, to be mounted at /somewhere


Running the container gave a warning, but also gave me a prompt in the running container:

    docker run -it -v$(pwd):/fictionmachine --rm --name conangcc11 conanio/gcc11-ubuntu16.04 /bin/bash
>     WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
> conan@6171096f75ca:~$

    cd /fictionmachine/; ls
>     dictionaries  dockerbuild  fonts  reference  src

    pip install --force-reinstall -v "conan==1.65.0"
    ./build.sh Release
    ./build/bin/hero hero/dictionary/fasthero.lexi 
>     ...
>     The Sublime Brain Boy
>     The Holy Nunchuck
>     Truly Irretrievable Woman
>     The Unsurvivable Catapult Girl


    file build/bin/hero 
>     ELF 64-bit LSB executable, x86-64, ..., not stripped

    strip --strip-all hero
    file build/bin/hero
>     ELF 64-bit LSB executable, x86-64, ..., stripped

Whereas building on macOS, I get

    file build/bin/hero                         
>     Mach-O 64-bit executable arm64


### Running on the Server


[bluehost]]# ./hero.elf64 
./hero.elf64: /lib64/libstdc++.so.6: version `GLIBCXX_3.4.20' not found
./hero.elf64: /lib64/libstdc++.so.6: version `CXXABI_1.3.9' not found
./hero.elf64: /lib64/libstdc++.so.6: version `GLIBCXX_3.4.29' not found


kznhgsmy@kzn.hgs.mybluehost.me [/lib64]# strings /lib64/libstdc++.so.6 | grep CXX
GLIBCXX_3.4
GLIBCXX_3.4.1
...
GLIBCXX_3.4.19
CXXABI_1.3
CXXABI_1.3.1
...
CXXABI_1.3.7

# gcc11 too new?

conanio/gcc48

docker run -it -v$(pwd):/fictionmachine --rm --name conangcc11 conanio/gcc48 /bin/bash

