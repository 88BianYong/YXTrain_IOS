//
//  StudentsLearnFilterView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StudentsLearnFilterView.h"
#import "MasterSchoolTableView.h"
#import "YXCourseFilterBgView.h"
#import "MasterConditionTableView.h"
@interface StudentsLearnFilterView ()
@property (nonatomic, strong) UIButton *masterButton;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) MasterSchoolTableView *schoolTableView;
@property (nonatomic, strong) MasterConditionTableView *conditionTableView;
@end
@implementation StudentsLearnFilterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
#pragma mark - setup UI
- (void)setupUI {
    self.masterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.masterButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.masterButton.frame = CGRectMake(15.0f, 0.0f, kScreenWidth - 125.0f - 30.0f, 44.0f);
    [self.masterButton setTitle:@"16年陕西学前交易的小奔放很骄傲和第三方哈酒咖啡" forState:UIControlStateNormal];
    [self.masterButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    [self.masterButton setImage:[UIImage imageNamed:@"筛选箭头选择下"] forState:UIControlStateNormal];
    [self.masterButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.masterButton.tag = 1001;
    self.masterButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self exchangeTitleImagePositionForButton:self.masterButton];
    [self addSubview:self.masterButton];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(kScreenWidth - 125.0f, 14.5f, 1.0f, 15.0f);
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:self.lineView];
    
    self.filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filterButton.frame = CGRectMake(kScreenWidth - 125.0f, 0.0f, 125.0f , 44.0f);
    self.filterButton.tag = 1002;
    [self.filterButton setTitleColor:[UIColor colorWithHexString:@"505f84"] forState:UIControlStateNormal];
    [self.filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [self.filterButton setImage:[UIImage imageNamed:@"筛选箭头默认下"] forState:UIControlStateNormal];
    self.filterButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.filterButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self exchangeTitleImagePositionForButton:self.filterButton];
    [self addSubview:self.filterButton];
    
    self.schoolTableView = [[MasterSchoolTableView alloc] init];
    WEAK_SELF
    [self.schoolTableView setMasterSchoolTableViewBlock:^(NSString *baridString) {
        STRONG_SELF
        [self.masterButton setTitle:self.groups[self.schoolTableView.chooseInteger].name forState:UIControlStateNormal];
        [self exchangeTitleImagePositionForButton:self.masterButton];
        [self.masterButton setImage:[UIImage imageNamed:@"筛选箭头选择下"] forState:UIControlStateNormal];
        BLOCK_EXEC(self.StudentsLearnFilterSchoolBlock,baridString);
        [self hideFilterSelectionView];
    }];
    self.conditionTableView = [[MasterConditionTableView alloc] init];
    [self.conditionTableView setMasterConditionChooseBlock:^(NSDictionary *dictionary) {
        STRONG_SELF
        BLOCK_EXEC(self.StudentsLearnFilterConditionBlock,dictionary);
        [self hideFilterSelectionView];
    }];
    self.maskView = [[UIView alloc]init];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.maskView addGestureRecognizer:tap];
}

- (void)exchangeTitleImagePositionForButton:(UIButton *)button{
    NSString *title = [button titleForState:UIControlStateNormal];
    CGFloat titleWidth = ceilf([title sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width+2);
    titleWidth = MIN(titleWidth, button.frame.size.width - 22);//防止文字过多
    UIImage *image = [button imageForState:UIControlStateNormal];
    CGFloat imageWidth = image.size.width+2;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
}
#pragma mark - button Action
- (void)chooseButtonAction:(UIButton *)sender {
    if (sender.tag == 1001) {
       [self.masterButton setImage:[UIImage imageNamed:@"筛选箭头选择上"] forState:UIControlStateNormal];
       [self showFilterSelectionViewWithIndex:self.schoolTableView.chooseInteger];
    }else {
        if (self.conditionTableView.isChooseBool) {
            [self.filterButton setImage:[UIImage imageNamed:@"筛选箭头选择上"]
                               forState:UIControlStateNormal];
            [self.filterButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
        }else {
            [self.filterButton setImage:[UIImage imageNamed:@"筛选箭头默认上"]
                               forState:UIControlStateNormal];
            [self.filterButton setTitleColor:[UIColor colorWithHexString:@"505f84"] forState:UIControlStateNormal];
        }
        [self showMasterConditionTableView];
    }
}

- (void)tapAction{
    [self hideFilterSelectionView];
}
- (void)hideFilterSelectionView{
    [self.schoolTableView.superview removeFromSuperview];
    [self.conditionTableView.superview removeFromSuperview];
    [self.maskView removeFromSuperview];
    if (self.conditionTableView.isChooseBool) {
        [self.filterButton setImage:[UIImage imageNamed:@"筛选箭头选择下"]
                           forState:UIControlStateNormal];
        [self.filterButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
        
    }else {
        [self.filterButton setImage:[UIImage imageNamed:@"筛选箭头默认下"]
                           forState:UIControlStateNormal];
        [self.filterButton setTitleColor:[UIColor colorWithHexString:@"505f84"] forState:UIControlStateNormal];
    }
}

#pragma mark - Show & Hide
- (void)showFilterSelectionViewWithIndex:(NSInteger)index{
    self.schoolTableView.groups = self.groups;
    UIView *superview = self.window;
    self.maskView.frame = superview.bounds;
    [superview addSubview:self.maskView];
    
    CGRect rect = [self convertRect:self.bounds toView:superview];
    CGFloat tableHeight = 0.0;
    if (self.groups.count == 0) {//服务端数据返回为空时 显示
        tableHeight = 44;
    }else {
        for (MasterManageListRequestItem_Body_Group *object in self.groups) {
            CGRect rect = [object.name boundingRectWithSize:CGSizeMake(kScreenWidth - 35.0f - 12.0f, 80.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            tableHeight = tableHeight + (44.0f + rect.size.height - kSingleLineTextHeight);
        }
        tableHeight = MIN(tableHeight , 242);
    }
    YXCourseFilterBgView *bgView = [[YXCourseFilterBgView alloc]initWithFrame:CGRectMake(6, rect.origin.y+rect.size.height-5, rect.size.width-6-6, tableHeight+8) triangleX:(kScreenWidth - 125.0f) /2.0f];
    self.schoolTableView.frame = CGRectMake(0, 8, bgView.bounds.size.width, tableHeight);
    [bgView addSubview:self.schoolTableView];
    [superview addSubview:bgView];
    [self.schoolTableView reloadData];
}

- (void)showMasterConditionTableView {
    UIView *superview = self.window;
    self.maskView.frame = superview.bounds;
    [superview addSubview:self.maskView];
    CGRect rect = [self convertRect:self.bounds toView:superview];
    CGFloat tableHeight = 150 * 3 / 2 + 88/2;
    YXCourseFilterBgView *bgView = [[YXCourseFilterBgView alloc]initWithFrame:CGRectMake(6, rect.origin.y+rect.size.height-5, rect.size.width-6-6, tableHeight+8) triangleX:kScreenWidth - 125.0f + 125.0f / 2.0f];
    self.conditionTableView.frame = CGRectMake(0, 8, bgView.bounds.size.width, tableHeight);
    [bgView addSubview:self.conditionTableView];
    [superview addSubview:bgView];
    [self.conditionTableView reloadData];
}
- (void)setGroups:(NSMutableArray<__kindof MasterManageListRequestItem_Body_Group *> *)groups {
    if (groups.count < 1){
        return;
    }
    _groups = groups;
    self.schoolTableView.groups = _groups;
    [self.masterButton setTitle:self.groups[self.schoolTableView.chooseInteger].name forState:UIControlStateNormal];
    [self exchangeTitleImagePositionForButton:self.masterButton];
}

@end
