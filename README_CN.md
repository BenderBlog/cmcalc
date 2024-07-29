# cmcalc

cmclac， 也称 "Cirno 的数学教室/计算器", 是一个高级计算器。该计算器使用 Rust 库 kalk 作为计算后端。

将来会引入 numbat 库用于单位转换。

本软件知道9的到底是啥。

## 功能表

 - [ ] 普通计算器
 - [ ] 汇率转换 (可能不会出现在纯开源版本)
 - [ ] 日历时间转换器 (需要从 libqalculate 相关代码重新实现)
 - [ ] 单位转换器
 - [x] BMI 计算器
 - [x] Kalk 的命令行界面
 - [ ] 加入可爱的东方萌妹子

## 使用的库

1. [kalk by PaddiM8](https://github.com/PaddiM8/kalker).
2. [flutter_rust_bridge by fzyzcjy](https://pub.dev/packages/flutter_rust_bridge).

## 打包

大多数打包问题和 gmp-msys-sys 有关，这个库是 kalk 库的可选依赖。

MacOS 平台和 Linux 平台编译运行应该没有问题。

安卓平台需要使用 `./build_apk` 命令来打包，尤其要指出 `NDK_TOOLCHAIN` 环境变量为安卓开发套件中 LLVM 编译器的位置。 比如：`/Users/superbart/Library/Android/sdk/ndk/23.1.7779620/toolchains/llvm/prebuilt/darwin-x86_64`.

目前 iOS 版本无法打包，一个解决方案是使用 kalk 低精度模式。kalk 低精度模式使用 64 位浮点数，个人感觉问题不大……

## 项目背景

苹果出个计算器还大张旗鼓，离谱。

