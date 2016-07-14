//
//  YXTopFilterView.m
//  TrainApp
//
//  Created by 李五民 on 16/6/28.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTopFilterView.h"
#import "YXFilterCustomButton.h"
#import "YXFilterButton.h"

@interface YXTopFilterView ()

@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) NSArray *nameArray;

@end

@implementation YXTopFilterView

- (void)viewWithNameArray:(NSArray *)nameArray {
    self.btnArray = [[NSMutableArray alloc] init];
    self.nameArray = nameArray;
    __block UIView *lastView = nil;
    CGSize btnSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/nameArray.count, 45);
    [nameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *btnTitleString = obj;
        YXFilterButton *btn = [[YXFilterButton alloc] init];
        btn.tag = idx + 100;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget: self action:@selector(btnBeginTouch:) forControlEvents:UIControlEventTouchDown];
        [btn setButtonTitle:btnTitleString withMaxWidth:[UIScreen mainScreen].bounds.size.width/nameArray.count];
        [self addSubview:btn];
        [self.btnArray addObject:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            } else {
                make.left.mas_equalTo(0);
            }
            make.bottom.top.mas_equalTo(0);
            make.size.mas_equalTo(btnSize);
        }];
        lastView = btn;
        
        if (idx > 0) {
            UIView *middleView = [[UIView alloc] init];
            middleView.backgroundColor = [UIColor colorWithHexString:@"d6d7db"];
            [self addSubview:middleView];
            [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(1);
                make.height.mas_equalTo(15);
                make.left.mas_equalTo([UIScreen mainScreen].bounds.size.width/nameArray.count * idx);
            }];
        }
    }];
}

- (void)btnClicked:(YXFilterButton *)sender {
    [sender btnTitleColor:[UIColor colorWithHexString:@"505f84"]];
    if (self.buttonClicked) {
        self.buttonClicked(sender.tag - 100);
    }
}

- (void)btnBeginTouch:(YXFilterButton *)sender {
    [sender btnTitleColor:[UIColor colorWithHexString:@"0067be"]];
}

- (void)btnTitileWithString:(NSString *)title index:(NSInteger)index {
    YXFilterButton *btn = self.btnArray[index];
    btn.btnLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    [btn setButtonTitle:title withMaxWidth:[UIScreen mainScreen].bounds.size.width/self.nameArray.count];
}

@end
