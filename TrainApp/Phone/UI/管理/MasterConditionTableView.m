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
@property (nonatomic, strong) MasterConditionCell *ifxcCell;
@property (nonatomic, strong) MasterConditionCell *ifhgCell;
@property (nonatomic, strong) MasterConditionCell *ifxxCell;
@end
@implementation MasterConditionTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setupUI];
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
    self.ifxcCell = [[MasterConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ifxcCell"];
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
        return self.ifxcCell;
    }else if (indexPath.row == 1) {
        return self.ifhgCell;
    }else {
        return self.ifxxCell;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - button Action
- (void)resetButtonAction:(UIButton *)sender {
    self.ifxcCell.leftRoundView.isChooseBool = NO;
    self.ifxcCell.rightRoundView.isChooseBool = NO;
    self.ifhgCell.leftRoundView.isChooseBool = NO;
    self.ifhgCell.rightRoundView.isChooseBool = NO;
    self.ifxxCell.leftRoundView.isChooseBool = NO;
    self.ifxxCell.rightRoundView.isChooseBool = NO;
}
- (void)confirmButtonAction:(UIButton *)sender {
    NSMutableDictionary *mutableDictionary = [@{@"ifcx":@"0",@"ifhg":@"0",@"ifxx":@"0"} mutableCopy];
    mutableDictionary[@"ifcx"] = [NSString stringWithFormat:@"%ld",self.ifxcCell.chooseInteger];
    mutableDictionary[@"ifhg"] = [NSString stringWithFormat:@"%ld",self.ifhgCell.chooseInteger];
    mutableDictionary[@"ifxx"] = [NSString stringWithFormat:@"%ld",self.ifxxCell.chooseInteger];
    BLOCK_EXEC(self.MasterConditionChooseBlock,mutableDictionary);
}
- (BOOL)isChooseBool {
    return self.ifxcCell.chooseInteger != 0 ||
           self.ifhgCell.chooseInteger != 0 ||
           self.ifxxCell.chooseInteger != 0;
}
@end
