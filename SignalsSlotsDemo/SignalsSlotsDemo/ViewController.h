//
//  ViewController.h
//  SignalsSlotsDemo
//
//  Created by CmST0us on 2019/4/25.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NSObjectSignals/NSObject+SignalsSlots.h>

@interface ViewController : UIViewController

- (NS_SIGNAL)clickView;
- (NS_SIGNAL)clickViewWithParam:(NSString *)p1 withParam:(NSString *)p2 withParam:(NSString *)p3;
@end

