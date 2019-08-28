//
//  ViewController.m
//  SignalsSlotsDemo
//
//  Created by CmST0us on 2019/4/25.
//  Copyright © 2019 eric3u. All rights reserved.
//

#import "ViewController.h"


@slots MyObserverSlots
@required
- (void)onViewClick;
- (void)onViewClickWithParam:(NSString *)p1 withParam:(NSString *)p2 withParam:(NSString *)p3;
@end

@interface MyObserver: NSObject <MyObserverSlots>
@property (nonatomic, copy) NSString *s;
@end

@implementation MyObserver
- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)onViewClick {
    NSLog(@"View Click");
}

- (void)onViewClickWithParam:(NSString *)p1 withParam:(NSString *)p2 withParam:(NSString *)p3 {
    NSLog(@"Multi param: p1->%@ p2->%@ p3->%@", p1, p2, p3);
}

@end

@interface ViewController ()
@property (nonatomic, strong) MyObserver *o;
@property (nonatomic, assign) NSInteger count;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"connecting...");
    self.count = 0;
    self.o = [[MyObserver alloc] init];
    [self connectSignal:@signalSelector(clickView) forObserver:self.o slot:@slotSelector(onViewClick)];
    [self connectSignal:@signalSelector(clickViewWithParam) forObserver:self.o blockSlot:^(NSArray * _Nonnull param) {
        NSLog(@"Block Click");
    }];
    [self connectSignal:@signalSelector(clickViewWithParam) forObserver:self.o slot:@selector(onViewClickWithParam:withParam:withParam:)];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self emitSignal:@signalSelector(clickView) withParams:nil];
    [self emitSignal:@signalSelector(clickViewWithParam) withParams:@[@"1", @"2", @"3"]];
    self.o.s = [NSString stringWithFormat:@"count %ld", self.count++];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self disconnectAllSignal];
        self.o = nil;
    });
}

@end
