//
//  ViewController.h
//  SignalsSlotsDemo
//
//  Created by CmST0us on 2019/4/25.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NSObjectSignals/NSObject+SignalsSlots.h>

@signals ViewControllerSignals
- (void)clickView;
- (void)clickViewWithParam;
- (void)changeS;
@end

@interface ViewController : UIViewController

@end
