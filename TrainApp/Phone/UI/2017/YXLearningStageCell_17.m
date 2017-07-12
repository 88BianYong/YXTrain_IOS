//
//  YXLearningStageCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXLearningStageCell_17.h"
#import "YXGradientView.h"
@interface YXLearningToolView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLable;
@end
@implementation YXLearningToolView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.centerX.equalTo(self.mas_centerX);
            make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
        }];
        self.nameLable = [[UILabel alloc] init];
        self.nameLable.font = [UIFont systemFontOfSize:12.0f];
        self.nameLable.textAlignment = NSTextAlignmentCenter;
        self.nameLable.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.nameLable.textColor = [UIColor colorWithHexString:@"0070c9"];
        [self addSubview:self.nameLable];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.imageView.mas_bottom).offset(12.0f);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}
@end



@interface YXLearningStageCell_17 ()
@property (nonatomic, strong) YXGradientView *gradientView;
@end


@implementation YXLearningStageCell_17

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
-(void)setupUI {
    UIColor *color = [UIColor colorWithHexString:@"f1f1f1"];
    self.gradientView = [[YXGradientView alloc]initWithStartColor:color endColor:[color colorWithAlphaComponent:0] orientation:YXGradientTopToBottom];
    [self.contentView addSubview:self.gradientView];
}
- (void)setupLayout {
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.right.equalTo(self.contentView);
        make.height.mas_offset(25.0f);
    }];
}
- (void)setupToolButton:(NSArray<UIButton *> *)toolButtons {
    [toolButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth/4.0f * idx);
            make.width.mas_offset(kScreenWidth/4.0f);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }];
}


#pragma mark - set
- (void)setTools:(NSArray<__kindof ExamineDetailRequest_17Item_Stages_Tools *> *)tools {
    _tools = tools;
    NSMutableArray<UIButton *> *buttonMutableArray = [[NSMutableArray<UIButton *> alloc] initWithCapacity:4];
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    for (ExamineDetailRequest_17Item_Stages_Tools *tool in tools) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = tool.toolID.integerValue;
        [self.contentView addSubview:button];
        YXLearningToolView *toolView = [[YXLearningToolView alloc] init];
        toolView.nameLable.text = tool.name;
        if (tool.status.integerValue == 0) {
            toolView.imageView.image = [UIImage imageNamed:@"Q--未展开"];
        }else if (tool.status.integerValue == 1) {
            toolView.imageView.image = [UIImage imageNamed:@"选择"];
        }else {
            toolView.imageView.image = [UIImage imageNamed:@"未选择"];
        }
        [button addSubview:toolView];
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(button);
            make.width.equalTo(button.mas_width);
        }];
        [buttonMutableArray addObject:button];
    }
    [self setupToolButton:buttonMutableArray];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
