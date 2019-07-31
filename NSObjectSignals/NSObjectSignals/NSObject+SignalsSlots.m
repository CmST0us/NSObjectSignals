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

static char *signalObserverKey = "_K_SignalObserverKey_K_";

@implementation NSObject (SignalsSlots)

- (NSObjectSignalsObserver *)signalObserver {
    NSObjectSignalsObserver *obj = objc_getAssociatedObject(self, signalObserverKey);
    if (obj == nil) { \
        obj = [[NSObjectSignalsObserver alloc] initWithSender:self];
        objc_setAssociatedObject(self, signalObserverKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

- (void)connectSignal:(SEL)signal forObserver:(NSObject *)observer slot:(SEL)slot {
    [self.signalObserver connectSignal:signal forObserver:observer slot:slot];
}

- (void)connectSignal:(SEL)signal forObserver:(NSObject *)observer blockSlot:(BlockSlot)blockSlot {
    [self.signalObserver connectSignal:signal forObserver:observer blockSlot:blockSlot];
}

- (void)disconnectSignal:(SEL)signal {
    [self.signalObserver disconnectSignal:signal];
}

- (void)disconnectSignal:(SEL)signal forObserver:(NSObject *)observer {
    [self.signalObserver disconnectSignal:signal forObserver:observer];
}

- (void)disconnectAllSignalForObserver:(NSObject *)observer {
    [self.signalObserver disconnectAllSignalForObserver:observer];
}

- (void)emitSignal:(SEL)signal withParams:(NSArray *)obj1 {
    [self.signalObserver emitSignal:signal withParams:obj1];
}

- (void)listenKeypath:(NSString *)aKeypath pairWithSignal:(SEL)signal forObserver:(NSObject *)observer slot:(SEL)slot {
    [self.signalObserver listenKeypath:aKeypath pairWithSignal:signal forObserver:observer slot:slot];
}

@end
