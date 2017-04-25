//
//  ProjectChooseLayerView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ProjectChooseLayerView.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "ProjectChooseLayerHeaderView.h"
#import "ProjectChooseLayerCell.h"
#import "UITableView+TemplateLayoutHeaderView.h"
@interface ProjectChooseLayerView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) UIButton *confirmButton;
@end
@implementation ProjectChooseLayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedSectionHeaderHeight = 44.0f;
    [self.tableView registerClass:[ProjectChooseLayerHeaderView class] forHeaderFooterViewReuseIdentifier:@"ProjectChooseLayerHeaderView"];
    [self.tableView registerClass:[ProjectChooseLayerCell class] forCellReuseIdentifier:@"ProjectChooseLayerCell"];
    [self addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100.0f)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
    
    self.confirmButton = [[UIButton alloc] init];
    self.confirmButton.layer.cornerRadius = YXTrainCornerRadii;
    self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"f3f7fa"].CGColor;
    self.confirmButton.layer.borderWidth = 1.0f;
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
    
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f3f7fa"]] forState:UIControlStateDisabled];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"]
                             forState:UIControlStateDisabled];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.confirmButton.enabled = NO;
    WEAK_SELF
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self showAlertView];

    }];
    [footerView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(40.0f);
        make.centerX.equalTo(footerView.mas_centerX);
        make.size.mas_offset(CGSizeMake(160.0f, 39.0f));
    }];

}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)showAlertView {
    __block TrainLayerListRequestItem_Body *item = nil;
    [self.dataMutableArray enumerateObjectsUsingBlock:^(__kindof TrainLayerListRequestItem_Body * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isChoose.boolValue) {
            item = obj;
            *stop = YES;
        }
    }];
    NSString *titleString = [NSString stringWithFormat:@"确定选择【%@】层次\n",item.title];
    NSString *subTitleString = @"注意,选择后不可变更";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",titleString,subTitleString]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} range:NSMakeRange(0,titleString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0f]range:NSMakeRange(4,item.title.length + 2)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"efa280"],NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} range:NSMakeRange(titleString.length,subTitleString.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7.0f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, titleString.length + subTitleString.length)];
    WEAK_SELF
    LSTAlertView *alertView = [[LSTAlertView alloc]init];
    alertView.attributedString = attributedString;
    alertView.imageName = @"失败icon";
    [alertView addButtonWithTitle:@"取消" style:LSTAlertActionStyle_Cancel action:^{
        STRONG_SELF
    }];
    [alertView addButtonWithTitle:@"确定" style:LSTAlertActionStyle_Default action:^{
        STRONG_SELF
        BLOCK_EXEC(self.projectChooseLayerCompleteBlock,item.layerId);
    }];
    [alertView show];
    
}
#pragma make - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataMutableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectChooseLayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectChooseLayerCell" forIndexPath:indexPath];
    cell.item = self.dataMutableArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [tableView yx_heightForHeaderWithIdentifier:@"ProjectChooseLayerHeaderView" configuration:^(ProjectChooseLayerHeaderView *headerView) {
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ProjectChooseLayerHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ProjectChooseLayerHeaderView"];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.5;
};
- (void)setDataMutableArray:(NSMutableArray<__kindof TrainLayerListRequestItem_Body *> *)dataMutableArray {
    _dataMutableArray = dataMutableArray;
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataMutableArray enumerateObjectsUsingBlock:^(__kindof TrainLayerListRequestItem_Body * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isChoose = @"0";
    }];
    self.dataMutableArray[indexPath.row].isChoose = @"1";
    self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
    self.confirmButton.enabled = YES;
    [self.tableView reloadData];
}
@end
