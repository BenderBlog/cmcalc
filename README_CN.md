# cmcalc

(中文版简介也许会和英文版有出入，应该大差不差)

CMCalc 旗舰版: Qalculate! 移动版本

本项目是一系列计算器软件的开端，我将其称作 CMCalc。项目目标是将主要的开源计算器代数系统在手机上呈现出来，目前仍在开发，本人尽力将这些库的全部功能提供给用户。

项目预计成果：
- 在手机上用 Flutter 实现计算机代数系统的用户界面
- 在手机上编译这些库文件

计划产品：
- [Qalculate!](http://qalculate.github.io/)
- [eigenmath](https://georgeweigt.github.io/)

Hopes an adorable and cute girl with [pretty blue eyes](https://www.youtube.com/watch?v=r1of21efNtk)
helps me, where is she...

## 授权

GPLv2 或任何以后版本（因为 qalculate 限制）

在 /lib 下的文件可用 LGPLv2 或任何以后版本

# 如何编译？

安卓端没啥困难，我已经在`android/app/lib/qalculate-5.5.0.aar`下放了我编译好的libqalculate库，所以直接编译吧。该库是使用[这个脚本](https://github.com/BenderBlog/libqalculate-android)编译的。

苹果端稍显复杂，您需要先自行编译 libqalculate xcframework。首先，在终端条件下进入`ios/libqalc/`目录，然后执行`compile_libqalculate_ios.sh`。**请不要在别的地方执行这个脚本！**接下来，应该能够成功编译了，希望没有错误……