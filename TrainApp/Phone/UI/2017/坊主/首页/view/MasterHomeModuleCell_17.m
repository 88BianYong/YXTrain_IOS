//
//  MasterHomeModuleCell.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeModuleCell_17.h"
@interface MasterHomeModuleView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLable;
@end
@implementation MasterHomeModuleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.centerX.equalTo(self.mas_centerX);
            make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
        }];
        self.nameLable = [[UILabel alloc] init];
        self.nameLable.font = [UIFont systemFontOfSize:11.0f];
        self.nameLable.textAlignment = NSTextAlignmentCenter;
        self.nameLable.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.nameLable.textColor = [UIColor colorWithHexString:@"334466"];
        [self addSubview:self.nameLable];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.imageView.mas_bottom).offset(4.0f);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}
@end

@interface MasterHomeModuleCell_17 ()
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, strong) NSDictionary *iconDicitionary;
@property (nonatomic, assign) CGSize buttonSize;
@end
@implementation MasterHomeModuleCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.buttonSize = CGSizeMake((kScreenWidth - 3.0f)/4.0f, (kScreenWidth - 3.0f)/4.0f);
        self.iconDicitionary =
        @{@"0":@{@"0":@"预热阶段",@"2":@"预热阶段（待完成）",@"1":@"预热阶段（已完成）"},
          @"4":@{@"0":@"学情统计",@"2":@"学情统计（待完成）",@"1":@"学情统计（已完成）"},
          @"1":@{@"0":@"作业管理",@"2":@"作业管理（待完成）",@"1":@"作业管理（已完成）"},
          @"3":@{@"0":@"简报1",@"2":@"简报1（待完成）",@"1":@"简报1（已完成）"},
          @"2":@{@"0":@"通知",@"2":@"通知（待完成）",@"1":@"通知（已完成）"},
          @"6":@{@"0":@"线上活动",@"2":@"线上活动（待完成）",@"1":@"线上活动（已完成）"},
          @"8":@{@"0":@"线下活动",@"2":@"线下活动（待完成）",@"1":@"线下活动（已完成）"},
          @"5":@{@"0":@"作品集",@"2":@"作品集（待完成）",@"1":@"作品集（已完成）"},
          @"31":@{@"0":@"综合评定",@"2":@"综合评定（待完成）",@"1":@"综合评定（已完成）"},
          @"30":@{@"0":@"去看课",@"2":@"去看课（待完成）",@"1":@"去看课（已完成）"}};
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    for (int i = 1; i < 4; i ++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        lineView.tag = i + 1;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(ceil(kScreenWidth/4.0f * i - 1.0f/[UIScreen mainScreen].scale));
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.mas_offset(1.0f);
        }];
    }
}
- (void)setupToolButton:(NSArray<UIButton *> *)toolButtons {
    [toolButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_top).offset(idx/4 * self.buttonSize.width + self.buttonSize.width/2.0f);
            make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth/4.0f * (idx % 4));
            make.width.mas_offset(kScreenWidth/4.0f);
            make.height.mas_offset(kScreenWidth/4.0f);
        }];
    }];
}
#pragma mark - set
- (void)setModules:(NSArray<__kindof MasterIndexRequestItem_Body_Modules *> *)modules {
    _modules = modules;
    NSMutableArray<UIButton *> *buttonMutableArray = [[NSMutableArray<UIButton *> alloc] initWithCapacity:4];
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self setupUI];
    [_modules enumerateObjectsUsingBlock:^(__kindof MasterIndexRequestItem_Body_Modules * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.tag = idx + 1;
        WEAK_SELF
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG_SELF;
            BLOCK_EXEC(self.masterHomeModuleCompleteBlock,obj);
        }];
        [self.contentView addSubview:button];
        MasterHomeModuleView *toolView = [[MasterHomeModuleView alloc] init];
        toolView.backgroundColor = [UIColor clearColor];
        toolView.userInteractionEnabled = NO;
        toolView.nameLable.text = obj.name;
        toolView.imageView.image = [UIImage imageNamed:self.iconDicitionary[obj.code][@"1"]];
        [button addSubview:toolView];
        if (obj.iconStatus.integerValue == 2) {
            UILabel *label = [[UILabel alloc] init];
            label.text = @"未完成";
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [[UIColor colorWithHexString:@"cccccc"] colorWithAlphaComponent:0.5f];
            label.clipsToBounds = YES;
            label.textColor = [UIColor whiteColor];
            label.layer.cornerRadius = 3.0f;
            label.font = [UIFont systemFontOfSize:10.0f];
            [button addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(button.mas_right).offset(-2.0f);
                make.top.equalTo(button.mas_top).offset(2.0f);
                make.size.mas_offset(CGSizeMake(35.0f, 15.0f));
            }];
        }
        
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(button);
            make.width.equalTo(button.mas_width);
        }];
        [buttonMutableArray addObject:button];
    }];
    for (int i = 0; i * 4 <= _modules.count; i ++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        lineView.tag = 10086 + i;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_top).offset(i * self.buttonSize.width + 1.0f);
            make.height.mas_offset(1.0f);
        }];
    }
    [self setupToolButton:buttonMutableArray];
}
@end
