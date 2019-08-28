//
//  NSObject+SignalsSlots.h
//  NSObjectSignals
//
//  Created by CmST0us on 2019/4/25.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define signals protocol
#define slots protocol

#define signalSelector selector
#define slotSelector selector

@interface NSObject (SignalsSlots)

- (void)connectSignal:(SEL)aSignal
          forObserver:(NSObject *)observer
                 slot:(SEL)aSlot;

- (void)connectSignal:(SEL)aSignal
          forObserver:(NSObject *)observer
            blockSlot:(void (^)(NSArray *param))blockSlot;

- (void)disconnectSignal:(SEL)aSignal
             forObserver:(NSObject *)observer;

- (void)disconnectAllSignalForObserver:(NSObject *)observer;

- (void)disconnectAllSignal;

- (void)emitSignal:(SEL)aSignal withParams:(nullable NSArray *)obj1;

@end

NS_ASSUME_NONNULL_END
