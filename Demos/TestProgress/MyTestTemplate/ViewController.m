//
//  ViewController.m
//  MyTestTemplate
//
//  Created by Lei Cai on 10/30/15.
//  Copyright © 2015 yanxiu. All rights reserved.
//

#import "ViewController.h"
#import "YXStoreLikeProgressView.h"
#import <RACExtScope.h>

@interface ViewController ()

@end

@implementation ViewController {
    YXStoreLikeProgressView *_v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    YXStoreLikeProgressView *v = [[YXStoreLikeProgressView alloc] init];
    v.backgroundColor = [UIColor whiteColor];
    v.progress = 0;
    v.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:v];
    _v = v;
    
    [self dispatchWithNumber:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dispatchWithNumber:(int)num {
    if (num == 0) {
        return;
    }
    num--;
    NSInteger delayInSeconds = arc4random()%3 + 1;
    @weakify(self);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        @strongify(self); if (!self) return;
        if (self->_v.progress < 1) {
            self->_v.progress += 0.1;
        }
        [self dispatchWithNumber:num];
    });
}

@end
