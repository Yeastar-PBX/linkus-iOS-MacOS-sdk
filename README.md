# Linkus iOS SDK 接入指南

## 一. SDK 集成
Linkus提供两种集成方式供iOS开发者选择：

- CocoaPods
- 手动集成

#### 1.1 CocoaPods集成方式

**命令行下执行`pod search linkus-vivo`,如显示的`linkus-vivo`版本不是最新的，则先执行`pod repo update`操作**

在工程的Podfile里面添加以下代码：
> **pod 'linkus-vivo'**

保存并执行`pod install`,然后用后缀为`.xcworkspace`的文件打开工程。

关于`CocoaPods`的更多信息请查看[CocoaPods官方网站](https://cocoapods.org/)。

#### 1.2 手动集成方式

* 下载[iOS SDK](https://github.com/Yeastar-PBX/linkus-ios-sdk-vivo/tree/main/YeastarLinkus.framework) 
* 拖拽`YeastarLinkus.framework`文件到Xcode工程内(请勾选`Copy items if needed`选项)
* 添加依赖库
    - `libc++.dylib`
    - `libxml2.dylib`

## 二. 初始化SDK

#### 2.1 导入头文件

在工程的`PrefixHeader.pch`文件导入头文件

> `#import <YeastarLinkus/YeastarLinkus.h>`

#### 2.2 初始化SDK

------

# Linkus iOS SDK 使用指南
## 一. 接口声明

### 1. 功能配置
