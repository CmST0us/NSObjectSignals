//
//  NSObject+SignalsSlots.m
//  NSObjectSignals
//
//  Created by CmST0us on 2019/4/25.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+SignalsSlots.h"
#import "NSObjectSignalsObserver.h"

#define GetSignalObserver(__name__) objc_getAssociatedObject(self, signalObserverKey);\
if (__name__ == nil) { \
__name__ = [[NSObjectSignalsObserver alloc] initWithSender:self];\
objc_setAssociatedObject(self, signalObserverKey, __name__, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

static char *signalObserverKey = "_K_SignalObserverKey_K_";

@implementation NSObject (SignalsSlots)

- (void)connectSignal:(SEL)signal forObserver:(NSObject *)observer slot:(SEL)slot {
    NSObjectSignalsObserver *signalObserver = GetSignalObserver(signalObserver);
    [signalObserver connectSignal:signal forObserver:observer slot:slot];
}

- (void)connectSignal:(SEL)signal forObserver:(NSObject *)observer blockSlot:(BlockSlot)blockSlot {
    NSObjectSignalsObserver *signalObserver = GetSignalObserver(signalObserver);
    [signalObserver connectSignal:signal forObserver:observer blockSlot:blockSlot];
}

- (void)disconnectSignal:(SEL)signal {
    NSObjectSignalsObserver *signalObserver = GetSignalObserver(signalObserver);
    [signalObserver disconnectSignal:signal];
}

- (void)disconnectSignal:(SEL)signal forObserver:(NSObject *)observer {
    NSObjectSignalsObserver *signalObserver = GetSignalObserver(signalObserver);
    [signalObserver disconnectSignal:signal forObserver:observer];
}

- (void)emitSignal:(SEL)signal withParams:(NSArray *)obj1 {
    NSObjectSignalsObserver *signalObserver = GetSignalObserver(signalObserver);
    [signalObserver emitSignal:signal withParams:obj1];
}

@end
