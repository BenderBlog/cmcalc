# cmcalc

cmclac, aka "Cirno Math Classroom/Calculator", is an advanced Flutter calculator. 

It is touhou themed which knows the meaning of 9.

## Function

 - [ ] Cirno's Normal Calculator. (kalk backend)
 - [ ] Marisa's Scientific Calculator. (kalk backend)
 - [ ] Reimu Currency Transformer. (May not appear in FOSS version)
 - [ ] (Somebody's) Calendar and Time Transformer. (numbat backend)
 - [ ] (Somebody's) Unit Transformer. (numbat backend)
 - [ ] Patchouli's REPL to use kalk directly.
 - And others...

## Library

1. [kalk by PaddiM8](https://github.com/PaddiM8/kalker).
2. [flutter_rust_bridge by fzyzcjy](https://pub.dev/packages/flutter_rust_bridge).

## Packaging

Most of the problem is related to gmp-mpfr-sys, a dependence of kalker.

MacOS and Linux should not enconter much trouble.

For Android, packagers should use `./build_apk` to compile the Android version, with `NDK_TOOLCHAIN` env as the folder of the NDK LLVM toolchains. eg. `/Users/superbart/Library/Android/sdk/ndk/23.1.7779620/toolchains/llvm/prebuilt/darwin-x86_64`.

## Background

This is a protest project against iPad preinstalled calculator, because Apple is an evil company which stuck every people's creation, wallet, also privacy freedom. No, EU dose not change that. Once, it is a company full of creation and passion, but they have changed, like almost all Internet company in China. Especially when they decide to put the iPad preinstalled calculator as a "highligit" in the Developer Confrence, I am speachless. They should put out that 1200 years earlier, shouldn't they? I can't see the "design difficulties" related to calculator. There are tons of calculator app in Android, Desktop, maybe iOS too.

Although you can write math memorial，that's not in the field of calculator. In my opinion, they should do something fascinating, like Integral calculation, time transformer.

Just don't like Apple. I am drunked.
