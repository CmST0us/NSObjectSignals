//
//  NSObjectSignalsObserver.m
//  NSObjectSignals
//
//  Created by CmST0us on 2019/4/25.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import "NSObjectSignalsObserver.h"

@interface NSObjectSignalsReceiver : NSObject
@property (nonatomic, weak) NSObject *receiver;
@property (nonatomic, assign) SEL signal;
@property (nonatomic, assign, nullable) SEL slot;
@property (nonatomic, copy, nullable) BlockSlot blockSlot;
@end
@implementation NSObjectSignalsReceiver
@end

@interface NSObjectSignalsObserver ()
@property (nonatomic, weak) NSObject *sender;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<NSObjectSignalsReceiver *> *> *signalMap;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *keypathSignalMap;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation NSObjectSignalsObserver
- (instancetype)initWithSender:(NSObject *)sender {
    self = [super init];
    if (self) {
        _sender = sender;
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (NSMutableDictionary *)signalMap {
    if (_signalMap == NULL) {
        _signalMap = [[NSMutableDictionary alloc] init];
    }
    return _signalMap;
}

- (NSMutableDictionary<NSString *,NSString *> *)keypathSignalMap {
    if (_keypathSignalMap == nil) {
        _keypathSignalMap = [[NSMutableDictionary alloc] init];
    }
    return _keypathSignalMap;
}

- (void)connectSignal:(SEL)signal forObserver:(NSObject *)observer slot:(SEL)slot {
    [self connectSignal:signal forObserver:observer slot:slot blockSlot:NULL];
}

- (void)connectSignal:(SEL)signal forObserver:(NSObject *)observer blockSlot:(BlockSlot)blockSlot {
    [self connectSignal:signal forObserver:observer slot:NULL blockSlot:blockSlot];
}

- (void)connectSignal:(SEL)signal forObserver:(NSObject *)observer slot:(nullable SEL)slot blockSlot:(nullable BlockSlot)blockSlot {
    [self.lock lock];
    NSString *signalSelString = NSStringFromSelector(signal);
    NSObjectSignalsReceiver *receiver = [[NSObjectSignalsReceiver alloc] init];
    receiver.signal = signal;
    receiver.receiver = observer;
    receiver.slot = slot;
    receiver.blockSlot = blockSlot;
    
    NSMutableArray *receivers = self.signalMap[signalSelString];
    if (receivers == NULL) {
        receivers = [[NSMutableArray alloc] init];
        [self.signalMap setValue:receivers forKey:signalSelString];
    }
    [receivers addObject:receiver];
    [self.lock unlock];
}

- (void)disconnectSignal:(SEL)signal {
    [self.lock lock];
    NSString *signalSelString = NSStringFromSelector(signal);
    [self.signalMap removeObjectForKey:signalSelString];
    [self.lock unlock];
}

- (void)disconnectSignal:(SEL)signal forObserver:(NSObject *)observer {
    NSString *signalSelString = NSStringFromSelector(signal);
    NSMutableArray *observers = self.signalMap[signalSelString];
    if (observers != NULL) {
        NSMutableArray *disconnectObjs = [NSMutableArray array];
        for (NSObjectSignalsReceiver *receiver in observers) {
            if (receiver.receiver == observer) {
                [disconnectObjs addObject:receiver];
            }
        }
        [self.lock lock];
        [observers removeObjectsInArray:disconnectObjs];
        [self.lock unlock];
    }
}

- (void)disconnectAllSignalForObserver:(NSObject *)observer {
    NSArray *observers = self.signalMap.allValues;
    if (observers != nil) {
        for (NSMutableArray *receivers in observers) {
            NSMutableArray *removeArray = [NSMutableArray array];
            for (NSObjectSignalsReceiver *receive in receivers) {
                if (receive.receiver == observer) {
                    [removeArray addObject:receive];
                }
            }
            [self.lock lock];
            [receivers removeObjectsInArray:removeArray];
            [self.lock unlock];
        }
    }
}

- (void)emitSignal:(SEL)signal withParams:(nullable NSArray *)obj1 {
    NSString *signalSelString = NSStringFromSelector(signal);
    NSMutableArray *observers = self.signalMap[signalSelString];
    if (observers != NULL) {
        NSMutableArray *disconnectObjs = [NSMutableArray array];
          for (NSObjectSignalsReceiver *receiver in observers) {
            if (receiver.receiver == NULL) {
                [disconnectObjs addObject:receiver];
            } else {
                if (receiver.slot != NULL) {
                    NSMethodSignature *signature = [[receiver.receiver class] instanceMethodSignatureForSelector:receiver.slot];
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    invocation.target = receiver.receiver;
                    invocation.selector = receiver.slot;
                    NSInteger paramtersCount = signature.numberOfArguments - 2;
                    if (obj1 == nil) {
                        paramtersCount = MIN(0, paramtersCount);
                    } else {
                        paramtersCount = MIN(obj1.count, paramtersCount);
                        for (int i = 0; i < paramtersCount; i++) {
                            id obj = obj1[i];
                            if ([obj isKindOfClass:[NSNull class]]) continue;
                            [invocation setArgument:&obj atIndex:i + 2];
                        }
                    }
                    [invocation invoke];
                }
                if (receiver.blockSlot != NULL) {
                    if (obj1 != nil) {
                        receiver.blockSlot(obj1);
                    } else {
                        receiver.blockSlot(@[]);
                    }
                }
            }
        }
        [self.lock lock];
        [observers removeObjectsInArray:disconnectObjs];
        [self.lock unlock];
    }
}

- (void)listenKeypath:(NSString *)aKeypath pairWithSignal:(SEL)signal forObserver:(NSObject *)observer slot:(SEL)slot {
    [self.lock lock];
    NSString *signalSelectorString = NSStringFromSelector(signal);
    [self.keypathSignalMap setObject:signalSelectorString forKey:aKeypath];
    [self.lock unlock];
    [self connectSignal:signal forObserver:observer slot:slot];
    [self.sender addObserver:self forKeyPath:aKeypath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSString *selStrig = [self.keypathSignalMap objectForKey:keyPath];
    if (selStrig != nil && [selStrig isKindOfClass:[NSString class]]) {
        SEL sel = NSSelectorFromString(selStrig);
        if (sel) {
            [self emitSignal:sel withParams:@[change[NSKeyValueChangeNewKey], change[NSKeyValueChangeOldKey]]];
            return;
        }
    }
}

@end
