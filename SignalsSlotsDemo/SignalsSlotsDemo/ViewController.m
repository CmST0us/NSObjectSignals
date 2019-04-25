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
- (NS_SLOT)onViewClickWithParam:(NSString *)p1 withParam:(NSString *)p2 withParam:(NSString *)p3;
@end

@implementation MyObserver
- (void)onViewClick {
    NSLog(@"View Click");
}

- (void)onViewClickWithParam:(NSString *)p1 withParam:(NSString *)p2 withParam:(NSString *)p3 {
    NSLog(@"Multi param: p1->%@ p2->%@ p3->%@", p1, p2, p3);
}

@end

@interface ViewController ()
@property (nonatomic, strong) MyObserver *o;
@end

@implementation ViewController
NS_CLOSE_SIGNAL_WARN(clickView);
NS_CLOSE_SIGNAL_WARN(clickViewWithParam:(NSString *)p1 withParam:(NSString *)p2 withParam:(NSString *)p3);

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"connecting...");
    self.o = [[MyObserver alloc] init];
    [self connectSignal:@selector(clickView) forObserver:self.o slot:@selector(onViewClick)];
    [self connectSignal:@selector(clickView) forObserver:self.o blockSlot:^(NSArray * _Nonnull param) {
        NSLog(@"Block Click");
    }];
    [self connectSignal:@selector(clickViewWithParam:withParam:withParam:) forObserver:self.o slot:@selector(onViewClickWithParam:withParam:withParam:)];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self emitSignal:@selector(clickView) withParams:nil];
    [self emitSignal:@selector(clickViewWithParam:withParam:withParam:) withParams:@[@"1", @"2", @"3"]];
}

@end
