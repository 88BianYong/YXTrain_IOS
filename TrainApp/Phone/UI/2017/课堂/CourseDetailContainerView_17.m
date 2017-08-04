#import "CourseDetailContainerView_17.h"
@interface ContainerHeaderView : UIView
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *startButton;
@end
@implementation ContainerHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.contentLabel.font = [UIFont systemFontOfSize:13.0f];
        self.contentLabel.text = @"本课程有课程检测,至少学习24分钟开启";
        self.contentLabel.numberOfLines = 1;
        [self addSubview:self.contentLabel];
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.image = [UIImage imageNamed:@""];
        self.iconImageView.backgroundColor = [UIColor redColor];
        [self addSubview:self.iconImageView];
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.text = @"已学习12分钟";
        self.timeLabel.textColor = [UIColor colorWithHexString:@"c2c7ce"];
        self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.timeLabel];
        self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.startButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"dfe2e6"]] forState:UIControlStateDisabled];
        [self.startButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateNormal];
        [self.startButton setTitle:@"开始检测" forState:UIControlStateNormal];
        self.startButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.startButton.layer.cornerRadius = YXTrainCornerRadii;
        self.startButton.clipsToBounds = YES;
        self.startButton.enabled = NO;
        [self addSubview:self.startButton];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"d2d8df"];
        [self addSubview:lineView];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.bottom.equalTo(self.mas_centerY).offset(-7.0f);
        }];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.centerY.equalTo(self.timeLabel.mas_centerY);
            make.size.mas_offset(CGSizeMake(15.0f, 15.0f));
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_centerY).offset(7.0f);
            make.left.equalTo(self.iconImageView.mas_right).offset(10.0f);
        }];
        
        [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-15.0f);
            make.size.mas_offset(CGSizeMake(70.0f, 28.0f));
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_bottom);
            make.height.mas_offset(1.0f);
        }];
    }
    return self;
}

@end
@interface CourseDetailContainerView_17()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) ContainerHeaderView *headerView;
@end
@implementation CourseDetailContainerView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.tabItemArray = @[@"章节",@"简介",@"评论"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set 
- (void)setStartTimeInteger:(NSInteger)startTimeInteger {
    _startTimeInteger = startTimeInteger;
    self.headerView.contentLabel.text = [NSString stringWithFormat:@"本课程有课程检测,至少学习%0.0f分钟开启",ceil((float)_startTimeInteger/60.0f)];
}
- (void)setPlayTimeInteger:(NSInteger)playTimeInteger {
    _playTimeInteger = playTimeInteger;
     self.headerView.timeLabel.text = [NSString stringWithFormat:@"已学习%0.0f分钟",floor((float)_playTimeInteger/60.0f)];
}
- (void)setIsStartBool:(BOOL)isStartBool {
    _isStartBool = isStartBool;
    self.headerView.startButton.enabled = _isStartBool;
}
#pragma mark - setupUI
- (void)setupUI {
    self.headerView = [[ContainerHeaderView alloc] init];
    WEAK_SELF
    [[self.headerView.startButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.courseDetailContainerButtonBlock)
        
    }];
    [self addSubview:self.headerView];
    
    self.topView = [[UIView alloc]init];
    [self addSubview:self.topView];
    
    self.bottomScrollView = [[UIScrollView alloc] init];
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.directionalLockEnabled = YES;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.backgroundColor = [UIColor redColor];
    [self addSubview:self.bottomScrollView];
    
    self.sliderView = [[UIView alloc]init];
    self.sliderView.backgroundColor = [UIColor colorWithHexString:@"0070c9"];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"d2d8df"];
    [self addSubview:self.lineView];
}
- (void)setupLayout {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.size.mas_offset(CGSizeMake(kScreenWidth, 71.0f));
        }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.headerView.mas_bottom);
            make.size.mas_offset(CGSizeMake(kScreenWidth, 45));
        }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
    
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.lineView.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
#pragma mark - set
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    for (UIView *v in self.topView.subviews) {
        [v removeFromSuperview];
    }
    for (UIView *v in self.bottomScrollView.subviews) {
        [v removeFromSuperview];
    }
    [self.sliderView removeFromSuperview];
    NSMutableArray *viewMutableArray = [[NSMutableArray alloc] init];
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.bottomScrollView addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomScrollView.mas_left).offset(kScreenWidth * idx);
            make.top.equalTo(self.bottomScrollView.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.mas_offset(kScreenWidth);
        }];
        // top
        UIButton *b = [self buttonWithTitle:self.tabItemArray[idx]];
        b.tag = 10086 + idx;
        [self.topView addSubview:b];
        [b mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_top);
            make.size.mas_offset(CGSizeMake(30.0f, 45.0f));
        }];
        [viewMutableArray addObject:b];
        if (idx == 0) {
            b.selected = YES;
        }
    }];
    [self distributeSpacingHorizontallyWith:viewMutableArray];
    [self addSubview:self.sliderView];
    UIButton *selectedButton = [self.topView viewWithTag:10086];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(45.0f, 2.0f));
        make.bottom.equalTo(self.topView.mas_bottom);
        make.centerX.equalTo(selectedButton.mas_centerX);
    }];
}
- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *b = [[UIButton alloc]init];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"bbc2c9"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateSelected];
    b.titleLabel.font = [UIFont systemFontOfSize:13];
    [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}
- (void)btnAction:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    for (UIButton *b in self.topView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
        }
    }
    sender.selected = YES;
    NSInteger index = sender.tag - 10086;
    [UIView animateWithDuration:0.3 animations:^{
        [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(45.0f, 2.0f));
            make.bottom.equalTo(self.topView.mas_bottom);
            make.centerX.equalTo(sender.mas_centerX);
        }];
        [self layoutIfNeeded];
    }];
    self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.frame.size.width*index, 0);
}
- (void)layoutSubviews{
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.frame.size.width*self.viewControllers.count, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat sliderX = offsetX/scrollView.contentSize.width*self.topView.frame.size.width;
    CGPoint point = CGPointMake(self.topView.frame.size.width/self.tabItemArray.count/2+sliderX, self.sliderView.center.y);
    UIButton *minButton = [self.topView viewWithTag:10086];
    if (point.x < minButton.center.x) {
        point.x = minButton.center.x;
    }
    UIButton *maxButton = [self.topView viewWithTag:10086 + 2];
    if (point.x > maxButton.center.x) {
        point.x = maxButton.center.x;
    }
    self.sliderView.center = point;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    for (UIButton *b in self.topView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
            if (b.tag-10086 == index) {
                b.selected = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_offset(CGSizeMake(45.0f, 2.0f));
                        make.bottom.equalTo(self.topView.mas_bottom);
                        make.centerX.equalTo(b.mas_centerX);
                        [self layoutIfNeeded];
                    }];
                }];
            }
        }
    }
}
@end
