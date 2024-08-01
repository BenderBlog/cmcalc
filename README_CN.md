# cmcalc

cmclac， 也称 "Cirno 的数学教室/计算器", 是一个高级计算器。该计算器使用 Rust 库 kalk 作为计算后端。

将来会引入 numbat 库用于单位转换。

本软件知道9的到底是啥。

## 功能表

 - [ ] 普通计算器界面
 - [ ] 汇率转换 (可能不会出现在纯开源版本)
 - [ ] 日历时间转换器 (需要从 libqalculate 相关代码重新实现)
 - [ ] 单位转换器
 - [x] BMI 计算器
 - [x] Kalk 的命令行界面
 - [ ] 加入可爱的东方萌妹子

本程序暂时不打算支持符号计算，如有需求，请使用 Geogebra CAS。该软件使用了 XCAS/GIAC 库，广泛适用于各种计算器。

## 使用的库

1. [kalk by PaddiM8](https://github.com/PaddiM8/kalker)，目前使用我的修改版。
2. [flutter_rust_bridge by fzyzcjy](https://pub.dev/packages/flutter_rust_bridge).

## 打包

大多数打包问题和 gmp-msys-sys 有关，这个库是 kalk 库的可选依赖。

MacOS 平台和 Linux 平台编译运行应该没有问题。

安卓平台需要使用 `./build_apk` 命令来打包，尤其要指出 `NDK_TOOLCHAIN` 环境变量为安卓开发套件中 LLVM 编译器的位置。 比如：`/Users/superbart/Library/Android/sdk/ndk/23.1.7779620/toolchains/llvm/prebuilt/darwin-x86_64`.

iOS 需要使用 `./build_gmp.sh` `./build_mpc.sh` `./build_mpfr.sh` 三个脚本构建库，然后将产物扔到 gmp_mpfr_sys 提供的[缓存文件夹](https://docs.rs/gmp-mpfr-sys/latest/gmp_mpfr_sys/#caching-the-built-c-libraries)。这些构建大致遵循 gmp_mpfr_sys 的编译参数，除了 gmp 关闭了汇编优化。没办法苹果，你暂时不配拥有这样快的速度。

## 项目背景

苹果出个计算器还大张旗鼓，离谱。

