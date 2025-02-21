### Updating a Really Old Version of Conan
#### To the not-quite-as-old-but-still-legacy Version 1.65
---

#### Error using Conan Version 1.48

I went to build an old C++ project, and got this error:

>      Detected a mismatch for the compiler version
>      between your conan profile settings and CMake:
>        Compiler version specified in your conan profile: 12.0
>        Compiler version detected in CMake: 15.0

Okay, yes I've installed a new version of Xcode since the last time I built with Conan on this machine.

    conan --version
>     Conan version 1.48.0

That is a bit out of date; as of this writing the latest Conan is 2.6, and all of the 1.x versions are legacy. But I'll run with the version I have and see if I can get the build to work.

Looking at my default profile with this command

    conan profile show default
>     [settings]
>     os=Macos
>     os_build=Macos
>     arch=armv8
>     arch_build=armv8
>     compiler=apple-clang
>     compiler.version=12.0
>     compiler.libcxx=libc++
>     build_type=Release
>     [options]
>     [conf]
>     [build_requires]
>     [env]

shows that `compiler.version=12.0`.

    conan profile new xc15 --detect

>     Found apple-clang 15.0
>     ...
>     Profile ...: [~]/.conan/profiles/xc15


    conan profile show xc15
shows exactly one difference from my default profile:
- ~~compiler.version=12.0~~
- compiler.version=15

I edited my default profile

    nano ~/.conan/profiles/default

to use `compiler.version=15` but now I get this error.

    ERROR: Invalid setting '15.0' is not a valid 'settings.compiler.version' value.
    Possible values are ['5.0', '5.1', ..., '13.1']

It would seeem that Conan version 1.48 only supports up to Xcode 13.1.

Let's update Conan to 1.65, the newest legacy 1.x version:

    pip install --upgrade pip
    pip install --force-reinstall -v "conan==1.65.0"
    conan --version
>     Conan version 1.65.0

And with that, I got the build to work again!
