//
//  MasterFilterTableView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterConditionTableView.h"
#import "MasterConditionCell.h"
@interface MasterConditionTableView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MasterConditionCell *ifcxCell;
@property (nonatomic, strong) MasterConditionCell *ifhgCell;
@property (nonatomic, strong) MasterConditionCell *ifxxCell;
@end
@implementation MasterConditionTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setupUI];
        self.mutableDictionary = [@{@"ifcx":@"0",@"ifhg":@"0",@"ifxx":@"0"} mutableCopy];
        self.scrollEnabled = NO;
    }
    return self;
}
#pragma mark - setupUI
-(void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.delegate = self;
    self.dataSource = self;
    self.layer.cornerRadius = YXTrainCornerRadii;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rowHeight = 75.0f;
    self.ifcxCell = [[MasterConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ifcxCell"];
    self.ifhgCell = [[MasterConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ifhgCell"];
    self.ifxxCell = [[MasterConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ifxxCell"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 12.0f, 44.0f)];
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    resetButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    resetButton.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    resetButton.frame = CGRectMake(0, 0, (kScreenWidth - 12.0f)/2.0f, 44.0f);
    [resetButton addTarget:self action:@selector(resetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:resetButton];
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    confirmButton.backgroundColor = [UIColor colorWithHexString:@"0070c9"];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.frame = CGRectMake((kScreenWidth - 12.0f)/2.0f, 0, (kScreenWidth - 12.0f)/2.0f, 44.0f);
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmButton];
    self.tableFooterView = footerView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.ifcxCell.leftRoundView.nameLabel.text = @"未参训";
        self.ifcxCell.rightRoundView.nameLabel.text = @"已参训";
        self.ifcxCell.chooseInteger = [self.mutableDictionary[@"ifcx"] integerValue];
        return self.ifcxCell;
    }else if (indexPath.row == 1) {
        self.ifxxCell.leftRoundView.nameLabel.text = @"未学习";
        self.ifxxCell.rightRoundView.nameLabel.text = @"已学习";
        self.ifxxCell.chooseInteger = [self.mutableDictionary[@"ifxx"] integerValue];
        return self.ifxxCell;
    }else {
        self.ifhgCell.leftRoundView.nameLabel.text = @"未通过";
        self.ifhgCell.rightRoundView.nameLabel.text = @"已通过";
        self.ifhgCell.chooseInteger = [self.mutableDictionary[@"ifhg"] integerValue];
        return self.ifhgCell;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - button Action
- (void)resetButtonAction:(UIButton *)sender {
    self.ifcxCell.chooseInteger = 0;
    self.ifhgCell.chooseInteger = 0;
    self.ifxxCell.chooseInteger = 0;
}
- (void)confirmButtonAction:(UIButton *)sender {
    self.mutableDictionary[@"ifcx"] = [NSString stringWithFormat:@"%ld",(long)self.ifcxCell.chooseInteger];
    self.mutableDictionary[@"ifhg"] = [NSString stringWithFormat:@"%ld",(long)self.ifhgCell.chooseInteger];
    self.mutableDictionary[@"ifxx"] = [NSString stringWithFormat:@"%ld",(long)self.ifxxCell.chooseInteger];
    BLOCK_EXEC(self.MasterConditionChooseBlock,self.mutableDictionary);
}
- (BOOL)isChooseBool {
    return [self.mutableDictionary[@"ifcx"] integerValue] != 0 ||
           [self.mutableDictionary[@"ifhg"] integerValue] != 0 ||
           [self.mutableDictionary[@"ifxx"] integerValue] != 0;
}
@end
