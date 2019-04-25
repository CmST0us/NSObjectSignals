# NSObjectSignals

Qt信号/槽机制在Objective-C上的实现。

## 导入工程
1. 为你的工程使用Xcode Workspace，并添加你的工程与本工程`NSObjectSignals/NSObjectSignals.xcodeproj`
2. 在你的工程`Embedded Binaries`配置下添加本工程的framework
3. `#import <NSObjectSignals/NSObject+SignalsSlots.h>`

## 使用

和Qt下信号槽操作类似，首先为类声明信号

``` Objective-C
- (NS_SIGNAL)clickView;
```

再声明，并实现监听此信号的槽函数

```Objective-C
// xxx.h
- (NS_SLOT)onClickView;

// xxx.m
- (NS_SLOT)onClickView {
    NSLog(@"View clicked;");
}
```

然后连接信号与槽

```Objective-C
[self connectSignal:@selector(clickView) forObserver:observer slot:@selector(onClickView)];
```

触发信号的方式和Qt有些许差别
```Objective-C
[self emitSignal:@selector(clickView) withParams:nil];
```

## 其他说明

- 非线程安全，如果需要线程安全需求，可使用`dispatch_queue`操作。
- 信号声明后，不需要实现。可以使用`NS_CLOSE_SIGNAL_WARN()`宏关闭未实现警告
- 连接同时支持block方法，使用方法见Demo