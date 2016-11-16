//
//  ActivityStepTableCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityStepTableCell.h"
@interface ActivityStepIconView :UIView
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UILabel *iconLabel;
@end
@implementation ActivityStepIconView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconButton.backgroundColor = [UIColor redColor];
    self.iconButton.layer.cornerRadius = 25.0f;
    [self addSubview:self.iconButton];
    
    self.iconLabel = [[UILabel alloc] init];
    self.iconLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.iconLabel.font = [UIFont systemFontOfSize:12.0f];
    self.iconLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.iconLabel];
    
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(self.iconButton.mas_width);
    }];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.top.equalTo(self.iconButton.mas_bottom).offset(7.0f);
    }];
}

@end


@interface ActivityStepTableCell ()
@property (nonatomic, strong) ActivityStepIconView *firstStepView;
@property (nonatomic, strong) ActivityStepIconView *secondStepView;
@property (nonatomic, strong) ActivityStepIconView *thirdStepView;
@property (nonatomic, strong) ActivityStepIconView *fourthStepView;
@property (nonatomic, copy) ActivityStepTableCellBlock toolBlock;
@end
@implementation ActivityStepTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.firstStepView = [[ActivityStepIconView alloc] init];
    self.firstStepView.iconButton.tag = 1;
    [self.firstStepView.iconButton addTarget:self action:@selector(stepToolButonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.firstStepView];
    
    self.secondStepView = [[ActivityStepIconView alloc] init];
    self.secondStepView.iconButton.tag = 2;
    [self.secondStepView.iconButton addTarget:self action:@selector(stepToolButonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.secondStepView];
    
    self.thirdStepView = [[ActivityStepIconView alloc] init];
    self.thirdStepView.iconButton.tag = 3;
    [self.thirdStepView.iconButton addTarget:self action:@selector(stepToolButonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.thirdStepView];
    
    self.fourthStepView = [[ActivityStepIconView alloc] init];
    self.fourthStepView.iconButton.tag = 4;
    [self.fourthStepView.iconButton addTarget:self action:@selector(stepToolButonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.fourthStepView];
}
- (void)setupLayout {
    [self.firstStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth * 27.0f/375.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(self.firstStepView.mas_width).multipliedBy(158.0f/120.0f).priority(999);
    }];
    [self.secondStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstStepView.mas_right).offset(kScreenWidth*27.0f/375.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.height.equalTo(self.firstStepView.mas_height);
        make.width.equalTo(self.firstStepView.mas_width);
        make.bottom.equalTo(self.contentView.mas_bottom);

    }];
    [self.thirdStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondStepView.mas_right).offset(kScreenWidth*27.0f/375.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.height.equalTo(self.firstStepView.mas_height);
        make.width.equalTo(self.firstStepView.mas_width);
        make.bottom.equalTo(self.contentView.mas_bottom);

    }];
    [self.fourthStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thirdStepView.mas_right).offset(kScreenWidth*27.0f/375.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-kScreenWidth*27.0f/375.0f);
        make.height.equalTo(self.firstStepView.mas_height);
        make.width.equalTo(self.firstStepView.mas_width);
        make.bottom.equalTo(self.contentView.mas_bottom);

    }];
}

#pragma mark - set
- (void)setFirstTool:(ActivityListRequestItem_Body_Activity_Steps_Tools *)firstTool {
    _firstTool = firstTool;
    if (_firstTool) {
        self.firstStepView.hidden = NO;
        self.firstStepView.iconLabel.text = _firstTool.title;
    }else {
        self.firstStepView.hidden =  YES;
    }
}
- (void)setSecondTool:(ActivityListRequestItem_Body_Activity_Steps_Tools *)secondTool {
    _secondTool = secondTool;
    if (_secondTool) {
        self.secondStepView.hidden = NO;
        self.secondStepView.iconLabel.text = _firstTool.title;
    }else {
        self.secondStepView.hidden = YES;
    }
}
- (void)setThirdTool:(ActivityListRequestItem_Body_Activity_Steps_Tools *)thirdTool {
    _thirdTool = thirdTool;
    if (_thirdTool) {
        self.thirdStepView.hidden = NO;
        self.thirdStepView.iconLabel.text = _firstTool.title;
    }else {
        self.thirdStepView.hidden = YES;
    }
}
- (void)setFourthTool:(ActivityListRequestItem_Body_Activity_Steps_Tools *)fourthTool {
    _fourthTool = fourthTool;
    if (_fourthTool) {
        self.fourthStepView.hidden = NO;
        self.fourthStepView.iconLabel.text = _firstTool.title;
    }else {
        self.fourthStepView.hidden = YES;
    }
}
- (void)setActivityStepTableCellBlock:(ActivityStepTableCellBlock)block {
    self.toolBlock = block;
}

#pragma mark - button Action
- (void)stepToolButonAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            BLOCK_EXEC(self.toolBlock,self.firstTool);
        }
            break;
        case 2:
        {
            BLOCK_EXEC(self.toolBlock,self.secondTool);
        }
            break;
        case 3:
        {
            BLOCK_EXEC(self.toolBlock,self.thirdTool);
        }
            break;
        case 4:
        {
            BLOCK_EXEC(self.toolBlock,self.fourthTool);
        }
            break;
        default:
            break;
    }
    
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
