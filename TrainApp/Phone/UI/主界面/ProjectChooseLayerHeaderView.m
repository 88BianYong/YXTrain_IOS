//
//  ProjectChooseLayerHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//
#import "ProjectChooseLayerHeaderView.h"

@interface ChooseLayerLable : UIView
@property (nonatomic ,strong) UILabel *explainLabel;
@property (nonatomic ,strong) UIView *pointView;
- (instancetype)initWithString:(NSString *)string;
@end

@implementation ChooseLayerLable
- (instancetype)initWithString:(NSString *)string {
    if (self = [super initWithFrame:CGRectZero]) {
        self.pointView =[[UIView alloc] init];
        self.pointView.backgroundColor = [UIColor colorWithHexString:@"dddfe2"];
        self.pointView.clipsToBounds = YES;
        self.pointView.layer.cornerRadius = 1.5f;
        [self addSubview:self.pointView];
        [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top).offset(4.5f);
            make.size.mas_offset(CGSizeMake(3.0f, 3.0f));
        }];
        
        self.explainLabel = [[UILabel alloc] init];
        self.explainLabel.font = [UIFont systemFontOfSize:12.0f];
        self.explainLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
        self.explainLabel.numberOfLines = 0;
        [self addSubview:self.explainLabel];
        [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pointView.mas_right).offset(5.0f);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7.0f;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
        self.explainLabel.attributedText = attrString;
    }
    return self;
}
@end

@interface ProjectChooseLayerHeaderView ()
@property (nonatomic ,strong) UIView *containerView;
@property (nonatomic ,strong) ChooseLayerLable *explainLabel1;
@property (nonatomic ,strong) ChooseLayerLable *explainLabel2;
@property (nonatomic ,strong) ChooseLayerLable *explainLabel3;
@end

@implementation ProjectChooseLayerHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.containerView];
    self.explainLabel1 = [[ChooseLayerLable alloc] initWithString:@"请根据自身情况选择对应层次的课程、活动、作业."];
    [self.containerView addSubview:self.explainLabel1];
    self.explainLabel2 = [[ChooseLayerLable alloc] initWithString:@"请务必慎重选择,一旦选择不可再次变更."];
    [self.containerView addSubview:self.explainLabel2];
    self.explainLabel3 = [[ChooseLayerLable alloc] initWithString:@" 坊主可以根据实际辅导需求切换分层,查看不同层次课程、活动、作业."];
    [self.containerView addSubview:self.explainLabel3];
}

- (void)setupLayout {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self);
    }];
    [self.containerView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10.0f);
        make.right.equalTo(self.contentView.mas_right);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.0f);
    }];
    [self.explainLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
    }];
    [self.explainLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.explainLabel1.mas_bottom).offset(5.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
    }];
    [self.explainLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.explainLabel2.mas_bottom).offset(5.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-15.0f);
    }];
}

- (NSAttributedString *)attributedStringToImage{
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3.0f, 3.0f)];
    pointView.backgroundColor = [UIColor colorWithHexString:@"dddfe"];
    pointView.clipsToBounds = YES;
    pointView.layer.cornerRadius = 1.5f;
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
    textAttachment.image = [self convertViewToImage:pointView];
    textAttachment.bounds = CGRectMake(0, 2.5f, 3.0f, 3.0f);
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    return attrStringWithImage;
}
-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
