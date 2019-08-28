//
//  NSObjectSignalsObserver.h
//  NSObjectSignals
//
//  Created by CmST0us on 2019/4/25.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BlockSlot)(NSArray *params);

@interface NSObjectSignalsObserver : NSObject
- (instancetype)initWithSender:(NSObject *)sender;

- (void)_connectSignal:(SEL)signal
          forObserver:(NSObject *)observer
                 slot:(SEL)slot;

- (void)_connectSignal:(SEL)signal
          forObserver:(NSObject *)observer
            blockSlot:(BlockSlot)blockSlot;

- (void)_disconnectSignal:(SEL)signal
             forObserver:(NSObject *)observer;

- (void)_disconnectAllSignalForObserver:(NSObject *)observer;

- (void)_disconnectAllSignal;

- (void)_emitSignal:(SEL)signal withParams:(nullable NSArray *)obj1;

@end

NS_ASSUME_NONNULL_END
