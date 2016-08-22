//
//  YXAppUpdatePopUpView.m
//  TrainApp
//
//  Created by Lei Cai on 8/18/16.
//  Copyright © 2016 niuzhaowang. All rights reserved.
//

#import "YXAppUpdatePopUpView.h"
#import "YXPopUpContainerView.h"
static const int YXTagBase = 8383;
static const CGFloat YXScrollMargin = 30.f;
@implementation YXAppUpdateData
@end


@interface YXAppUpdatePopUpView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *sepView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *downloadUpdateButton;

@property (nonatomic, strong) YXAppUpdateData *data;
@property (nonatomic, strong) NSArray *actionArray;
@end

@implementation YXAppUpdatePopUpView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3;
    
    
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    [self addSubview:self.contentScrollView];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.contentLabel.numberOfLines = 0;
    [self.contentScrollView addSubview:self.contentLabel];
    
    self.sepView = [[UIView alloc] init];
    self.sepView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:self.sepView];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:[UIColor colorWithHexString:@"f3f7fa"]];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.cancelButton.layer.cornerRadius = 2;
    self.cancelButton.tag = YXTagBase + 0;
    [self.cancelButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    self.downloadUpdateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downloadUpdateButton setTitle:@"下载更新" forState:UIControlStateNormal];
    [self.downloadUpdateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.downloadUpdateButton setBackgroundColor:[UIColor colorWithHexString:@"0070c9"]];
    self.downloadUpdateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.downloadUpdateButton.layer.cornerRadius = 2;
    self.downloadUpdateButton.tag = YXTagBase + 1;
    [self.downloadUpdateButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.downloadUpdateButton];
}

- (void)btnAction:(UIButton *)sender {
    YXAlertAction *action = self.actionArray[sender.tag - YXTagBase];
    action.block();
}

- (void)updateWithData:(YXAppUpdateData *)data actions:(NSArray *)actions {
    if (actions.count != 2) {
        DDLogError(@"两个button，请提供两个action");
        return;
    }
    data.imageName = @"下载版本更新icon";
    self.data = data;
    
    self.imageView.image = [UIImage imageNamed:data.imageName];
    self.titleLabel.text = data.title;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:data.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [data.content length])];
    self.contentLabel.attributedText = attributedString;
    [self updateConstrainsForScrollView];
    
    self.actionArray = actions;
    [self layoutIfNeeded];
}

- (void)updateConstrainsForScrollView {
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(14);
        make.left.mas_equalTo(YXScrollMargin);
        make.right.mas_equalTo(-YXScrollMargin);
    }];
    CGFloat h = [self heightForContent];
    
    if (h <= [self maxContentNonScrollHeight]) {
        NSLog(@"足够");
        [self.contentScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(14);
            make.left.mas_equalTo(YXScrollMargin);
            make.right.mas_equalTo(-YXScrollMargin);
            make.height.mas_equalTo(h);
        }];
    } else {
        NSLog(@"滚动");
        [self.contentScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(14);
            make.left.mas_equalTo(YXScrollMargin);
            make.right.mas_equalTo(-YXScrollMargin);
            make.height.mas_equalTo([self maxContentNonScrollHeight]);
        }];
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, h);
    }
}

- (void)setupConstrainsInContainerView:(YXPopUpContainerView *)v {
    v.popView = self;
    [v addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(270);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(170, 130));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(3);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-60);
        make.top.mas_equalTo(self.contentScrollView.mas_bottom).mas_offset(14);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(95, 29));
        make.left.mas_equalTo(30);
        make.bottom.mas_equalTo(-15.5);
    }];
    [self.downloadUpdateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(95, 29));
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-15.5);
    }];
}

- (YXAppUpdateData *)mockData {
    YXAppUpdateData *data = [[YXAppUpdateData alloc] init];
    data.title = @"V2.1版本更新提示";
    data.content = @"look into my eye, you will see, what you mean to me";
    data.content = @"1.整体结构调整更加精简，全新界面设计更加清晰\n2.增加考核模块，查看学习进度及成绩明细\n3.增加任务模块，完成学习相关任务\n4.增加通知、简报，查看学习群组重要通知信息";
//    data.content = @"1.整体结构调整更加精简，全新界面设计更加清晰\n2.增加考核模块，查看学习进度及成绩明细\n3.增加任务模块，完成学习相关任务\n4.增加通知、简报，查看学习群组重要通知信息\nlook into my eye";
    return data;
}

/**
 *  这个可以根据不同屏幕高度返回不同值，现在拍脑袋给了个 150
 */
- (CGFloat)maxContentNonScrollHeight {
    return 180.f;
}

- (CGFloat)heightForContent {
    UIView *tmpView = [[UIView alloc] init];
    tmpView.backgroundColor = [UIColor redColor];
    [self addSubview:tmpView];
    [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, YXScrollMargin, 0, YXScrollMargin));
    }];
    [tmpView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(tmpView.mas_width);
    }];
    
    [self layoutIfNeeded];
    CGSize fittingSize = [tmpView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [self.contentLabel removeFromSuperview];
    [tmpView removeFromSuperview];
    [self.contentScrollView addSubview:self.contentLabel];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(self.contentScrollView.mas_width);
    }];
    return fittingSize.height;
}

@end
