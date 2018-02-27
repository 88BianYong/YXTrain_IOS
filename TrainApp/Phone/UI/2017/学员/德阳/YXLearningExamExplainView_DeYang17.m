//
//  YXLearningExamExplainView_DeYang17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/2/26.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXLearningExamExplainView_DeYang17.h"
@interface YXLearningExamExplainView_DeYang17 ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *explainLabel;
@end
@implementation YXLearningExamExplainView_DeYang17


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = YXTrainCornerRadii;
    [self addSubview:self.bgView];
    
    self.explainLabel = [[UILabel alloc] init];
    self.explainLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.explainLabel.font = [UIFont systemFontOfSize:12.0f];
    self.explainLabel.text = @"课程: 17学时  案例: 3学时";
    self.explainLabel.numberOfLines = 0;
    [self.bgView addSubview:self.explainLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)setupLayoutSingle:(BOOL)single {
    [self.explainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15.0f);
        make.right.equalTo(self.bgView.mas_right).offset(-15.0f);
        make.top.equalTo(self.bgView.mas_top).offset(15.0f);
        if (single) {//富文本一行也有行高
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-10.0);
        }else {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-15.0);
        }
    }];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
    }];
}

- (void)tapAction{
    [self removeFromSuperview];
}
- (void)setupOriginRect:(CGRect)rect withToTop:(BOOL)isTop {
    if (isTop) {
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.superview.mas_top).offset(rect.origin.y - 10.0f);
        }];
    }else {
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.superview.mas_top).offset(rect.origin.y + 10.0f + rect.size.height);
        }];
        
    }
}
+ (CGFloat)heightForDescription:(NSString *)desc {
    CGRect rect = [desc boundingRectWithSize:CGSizeMake(kScreenWidth - 60.0f, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } context:NULL];
    return rect.size.height;
}

- (void)showInView:(UIView *)view examExplain:(NSString *)string {
    self.frame = view.bounds;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.explainLabel.attributedText = attrStr;
    [view addSubview:self];
    [self.explainLabel sizeToFit];
    CGRect frame = self.explainLabel.frame;
    if (frame.size.width > kScreenWidth - 40.0f){
        [self setupLayoutSingle:NO];
    }else{
        [self setupLayoutSingle:YES];
    }
}
@end
