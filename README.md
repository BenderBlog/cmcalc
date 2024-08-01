# cmcalc

cmclac, aka "Cirno Math Classroom/Calculator", is an advanced Flutter calculator. Using kalk as backend.

Maybe use numbat as backend for unit calculation...

It is touhou themed which knows the meaning of 9.

## Function

 - [ ] Cirno's Normal Calculator. (kalk backend)
 - [ ] Reimu Currency Transformer. (May not appear in FOSS version)
 - [ ] (Somebody's) Calendar and Time Transformer. (need to reimplement from libqalculate code)
 - [ ] (Somebody's) Unit Transformer. (numbat backend)
 - [x] Yuyuko's BMI calculator. (plain rust function practise)
 - [x] Marisa's REPL to use kalk directly. (aim to port kalker to Flutter UI)
 - [ ] Lots of cute girl from touhou.

## Library

1. [kalk by PaddiM8](https://github.com/PaddiM8/kalker), currently my fork.
2. [flutter_rust_bridge by fzyzcjy](https://pub.dev/packages/flutter_rust_bridge).

## Packaging

Most of the problem are related to gmp-mpfr-sys, a dependence of kalker.

MacOS and Linux should not enconter much trouble.

For Android, packagers should use `./build_apk` to compile the Android version, with `NDK_TOOLCHAIN` env as the folder of the NDK LLVM toolchains. eg. `/Users/superbart/Library/Android/sdk/ndk/23.1.7779620/toolchains/llvm/prebuilt/darwin-x86_64`.

For iOS, packagers should use `./build_gmp.sh` `./build_mpc.sh` `./build_mpfr.sh` to compile the libs, and copy them to the [cache folder of the gmp_mpfr_sys](https://docs.rs/gmp-mpfr-sys/latest/gmp_mpfr_sys/#caching-the-built-c-libraries). Parameters are identical to the gmp_mpfr_sys, except gmp closed the ams optimization.

## Background

This is a protest project against iPad preinstalled calculator, because Apple is an evil company which stuck every people's creation, wallet, also privacy freedom. No, EU dose not change that. Once, it is a company full of creation and passion, but they have changed, like almost all Internet company in China. Especially when they decide to put the iPad preinstalled calculator as a "highligit" in the Developer Confrence, I am speachless. They should put out that 1200 years earlier, shouldn't they? I can't see the "design difficulties" related to calculator. There are tons of calculator app in Android, Desktop, maybe iOS too.

Although you can write math memorial，that's not in the field of calculator. In my opinion, they should do something fascinating, like Integral calculation, time transformer.

Just don't like Apple. I am drunked.
