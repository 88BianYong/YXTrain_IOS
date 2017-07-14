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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
-(void)setupUI {
    UIColor *color = [UIColor colorWithHexString:@"f1f1f1"];
    self.gradientView = [[YXGradientView alloc]initWithStartColor:color endColor:[color colorWithAlphaComponent:0] orientation:YXGradientTopToBottom];
    self.gradientView.tag = 5;
    [self.contentView addSubview:self.gradientView];
    for (int i = 1; i < 4; i ++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
        lineView.tag = i + 1;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth/4.0f * i - 0.5f/[UIScreen mainScreen].scale);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.mas_offset(1.0f/[UIScreen mainScreen].scale);
        }];
    }
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
        if ((idx / 4 % 2) == 0) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView.mas_top).offset(idx/4 * 80.0f + 40.0f);
                make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth/4.0f * (idx % 4));
                make.width.mas_offset(kScreenWidth/4.0f);
                make.height.mas_offset(80.0f);
            }];
            if (idx + 1 != toolButtons.count) {
                if ((idx+1) % 4 != 0) {
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下一步"]];
                    imageView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
                    imageView.layer.cornerRadius = 7.5f;
                    imageView.tag = 20086+ idx;
                    [self.contentView addSubview:imageView];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_offset(CGSizeMake(15.0f, 15.0f));
                        make.centerX.equalTo(obj.mas_right);
                        make.centerY.equalTo(obj.mas_centerY);
                    }];
                }else {
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下一步"]];
                    imageView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
                    imageView.layer.cornerRadius = 7.5f;
                    imageView.tag = 20086+ idx;
                    imageView.transform=CGAffineTransformMakeRotation(M_PI/2);
                    [self.contentView addSubview:imageView];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_offset(CGSizeMake(15.0f, 15.0f));
                        make.centerX.equalTo(obj.mas_centerX);
                        make.centerY.equalTo(self.contentView.mas_top).offset(idx/4 * 80.0f + 80.0f);
                    }];
                }
            }

        }else {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView.mas_top).offset(idx/4 * 80.0f + 40.0f);
                make.right.equalTo(self.contentView.mas_right).offset(-kScreenWidth/4.0f * (idx % 4));
                make.width.mas_offset(kScreenWidth/4.0f);
                make.height.mas_offset(80.0f);
            }];
            if (idx + 1 != toolButtons.count) {
                if ((idx+1) % 4 != 0) {
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下一步"]];
                    imageView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
                    imageView.layer.cornerRadius = 7.5f;
                    imageView.tag = 20086+ idx;
                    imageView.transform=CGAffineTransformMakeRotation(-M_PI);
                    [self.contentView addSubview:imageView];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_offset(CGSizeMake(15.0f, 15.0f));
                        make.centerX.equalTo(obj.mas_left);
                        make.centerY.equalTo(obj.mas_centerY);
                    }];
                    
                }else {
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下一步"]];
                    imageView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
                    imageView.layer.cornerRadius = 7.5f;
                    imageView.tag = 20086+ idx;
                    imageView.transform=CGAffineTransformMakeRotation(M_PI/2);
                    [self.contentView addSubview:imageView];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_offset(CGSizeMake(15.0f, 15.0f));
                        make.centerX.equalTo(obj.mas_right);
                        make.centerY.mas_offset(idx/4 * 80.0f + 80.0f);
                    }];
                }
            }
        }
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
        if ([obj isKindOfClass:[UIView class]]) {
            if (obj.tag >= 10086) {
                [obj removeFromSuperview];
            }
        }
        if ([obj isKindOfClass:[UIImageView class]]) {
            if (obj.tag >= 20086) {
                [obj removeFromSuperview];
            }
        }
    }];
    [tools enumerateObjectsUsingBlock:^(__kindof ExamineDetailRequest_17Item_Stages_Tools * _Nonnull tool, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx + 1;
        WEAK_SELF
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG_SELF;
            BLOCK_EXEC(self.learningStageToolCompleteBlock,tool);
        }];
        [self.contentView addSubview:button];
        YXLearningToolView *toolView = [[YXLearningToolView alloc] init];
        toolView.userInteractionEnabled = NO;
        toolView.nameLable.text = tool.name;
        if (tool.status.integerValue == 0) {
            toolView.imageView.image = [UIImage imageNamed:@"未解锁"];
        }else if (tool.status.integerValue == 1) {
            toolView.imageView.image = [UIImage imageNamed:@"当前"];
        }else {
            toolView.imageView.image = [UIImage imageNamed:@"已完成"];
        }
        [button addSubview:toolView];
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(button);
            make.width.equalTo(button.mas_width);
        }];
        [buttonMutableArray addObject:button];
    }];
    for (int i = 1; i * 4 <= tools.count; i ++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
        lineView.tag = 10086 + i;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_top).offset(i * 80.0f);
            make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
        }];
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
