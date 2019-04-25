//
//  NSObject+SignalsSlots.h
//  NSObjectSignals
//
//  Created by CmST0us on 2019/4/25.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define NS_SIGNAL void
#define NS_SLOT void
#define NS_CLOSE_SIGNAL_WARN(signal) - (void)signal { \
\
}

@interface NSObject (SignalsSlots)

- (void)connectSignal:(SEL)signal
          forObserver:(NSObject *)observer
                 slot:(SEL)slot;

- (void)connectSignal:(SEL)signal
          forObserver:(NSObject *)observer
            blockSlot:(void (^)(NSArray *param))blockSlot;

- (void)disconnectSignal:(SEL)signal
             forObserver:(NSObject *)observer;

- (void)disconnectSignal:(SEL)signal;

- (void)emitSignal:(SEL)signal withParams:(nullable NSArray *)obj1;

@end

NS_ASSUME_NONNULL_END
