//
//  YXProjectSelectionView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXProjectSelectionView.h"
#import "YXProjectSelectionBgView.h"
#import "YXProjectSelectionCell.h"

static const CGFloat kImageWidth = 30;

@interface YXProjectSelectionView()
//@property (nonatomic, strong) NSMutableArray *projectArray;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation YXProjectSelectionView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDynamicNotification:) name:kYXTrainCurrentProjectIndex object:nil];
    }
    return self;
}
- (void)setupUI {
    self.bgButton = [[UIButton alloc]initWithFrame:self.bounds];
    self.bgButton.userInteractionEnabled = NO;
    WEAK_SELF
    [[self.bgButton rac_signalForControlEvents:UIControlEventAllEvents] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.showProjectChangeBlock);
    }];
    [self addSubview:self.bgButton];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.titleLabel];
    
    self.rightImageView = [[UIImageView alloc]init];
    self.rightImageView.image = [UIImage imageNamed:@"切换标题模块的按钮"];
    self.rightImageView.contentMode = UIViewContentModeCenter;
    self.rightImageView.hidden = YES;
    [self addSubview:self.rightImageView];
    [self setupTitleWithProject:[LSTSharedInstance sharedInstance].trainManager.currentProject.name];

}
- (void)setupTitleWithProject:(NSString *)projectName {
    CGSize size = [projectName sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGFloat titleWidth = MIN(ceilf(size.width), self.bounds.size.width-kImageWidth);
    self.titleLabel.frame = CGRectMake((self.bounds.size.width-titleWidth-kImageWidth)/2, 0, titleWidth, self.bounds.size.height);
    self.titleLabel.text = projectName;
    if ([LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trains.count > 1) {
        self.bgButton.userInteractionEnabled = YES;
        self.rightImageView.frame = CGRectMake(self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width, (self.bounds.size.height-kImageWidth)/2, kImageWidth, kImageWidth);
        self.rightImageView.hidden = NO;
    }else {
        self.rightImageView.hidden = YES;
    }
}
- (void)receiveDynamicNotification:(NSNotification *)aNotification {
    NSString *pid = aNotification.object;
    [[LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trains enumerateObjectsUsingBlock:^(YXTrainListRequestItem_body_train * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.pid isEqualToString:pid]) {
            [self setupTitleWithProject:obj.name];
            *stop = YES;
        }
    }];
}
@end
