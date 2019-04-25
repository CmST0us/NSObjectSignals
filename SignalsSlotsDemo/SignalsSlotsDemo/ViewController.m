//
//  ViewController.m
//  SignalsSlotsDemo
//
//  Created by CmST0us on 2019/4/25.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import "ViewController.h"

@interface MyObserver: NSObject
- (NS_SLOT)onViewClick;
@end

@implementation MyObserver
- (void)onViewClick {
    NSLog(@"View Click");
}
@end

@interface ViewController ()
@property (nonatomic, strong) MyObserver *o;
@end

@implementation ViewController
NS_CLOSE_SIGNAL_WARN(clickView);


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"connecting...");
    self.o = [[MyObserver alloc] init];
    [self connectSignal:@selector(clickView) forObserver:self.o slot:@selector(onViewClick)];
    [self connectSignal:@selector(clickView) forObserver:self.o blockSlot:^(NSArray * _Nonnull param) {
        NSLog(@"Block Click");
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self emitSignal:@selector(clickView) withParams:nil];
}

@end
