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
    [self.signalObserver _connectSignal:signal forObserver:observer slot:slot];
}

- (void)connectSignal:(SEL)signal forObserver:(NSObject *)observer blockSlot:(BlockSlot)blockSlot {
    [self.signalObserver _connectSignal:signal forObserver:observer blockSlot:blockSlot];
}

- (void)disconnectSignal:(SEL)signal forObserver:(NSObject *)observer {
    [self.signalObserver _disconnectSignal:signal forObserver:observer];
}

- (void)disconnectAllSignalForObserver:(NSObject *)observer {
    [self.signalObserver _disconnectAllSignalForObserver:observer];
}

- (void)disconnectAllSignal {
    [self.signalObserver _disconnectAllSignal];
}

- (void)emitSignal:(SEL)signal withParams:(NSArray *)obj1 {
    [self.signalObserver _emitSignal:signal withParams:obj1];
}


@end
