//
//  MasterSchemeView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterSchemeView_17.h"
#import "YXExamProgressView.h"
@interface MasterSchemeView_17 ()
@property (nonatomic, strong) UILabel *mainPointLabel;
@property (nonatomic, strong) UILabel *scheduleLabel;
@property (nonatomic, strong) YXExamProgressView *progressView;
@end
@implementation MasterSchemeView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.mainPointLabel = [[UILabel alloc] init];
    self.mainPointLabel.font = [UIFont systemFontOfSize:14.0f];
    self.mainPointLabel.text = @"你熟练度会计分录卡迪夫;拉的屎啦咖啡";
    self.mainPointLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.mainPointLabel];
    
    self.scheduleLabel = [[UILabel alloc] init];
    self.scheduleLabel.font = [UIFont fontWithName:YXFontMetro_DemiBold size:13];
    self.scheduleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.scheduleLabel.text = @"1/2";
    [self addSubview:self.scheduleLabel];
    
    self.progressView = [[YXExamProgressView alloc]init];
    self.progressView.progress = 0.5f;
    [self addSubview:self.progressView];
}
- (void)setupLayout {
    [self.mainPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.top.equalTo(self.mas_top).offset(16.0f);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.top.equalTo(self.mainPointLabel.mas_bottom).offset(15.0f);
        make.height.mas_offset(6.0f);
        make.right.equalTo(self.scheduleLabel.mas_left).offset(-20.0f);
    }];
    [self.scheduleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10.0f);
        make.centerY.equalTo(self.progressView.mas_centerY);
    }];
}
- (void)reloadMasterScheme:(NSString *)title withFinishNum:(NSString *)finish withAmount:(NSString *)amount {
    self.mainPointLabel.text = title;
    self.progressView.progress = finish.floatValue/amount.floatValue;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %@",finish,amount]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0070c9"] range:NSMakeRange(0, finish.length)];
    self.scheduleLabel.attributedText = attributedString;
}

//- (NSString *)mainPointContent:(HomeworkListRequest_17Item_Scheme *)scheme{
//    if (scheme.scheme.toolID.integerValue == 219 || scheme.scheme.toolID.integerValue == 319) {
//        return [NSString stringWithFormat:@"需要互评%@篇同学作业",scheme.scheme.finishNum];
//    }else if (scheme.scheme.toolID.integerValue == 203 || scheme.scheme.toolID.integerValue == 303) {
//        return [NSString stringWithFormat:@"需要完成%@篇作业",scheme.scheme.finishNum];
//    }else if (scheme.scheme.toolID.integerValue == 216 || scheme.scheme.toolID.integerValue == 316) {
//        return [NSString stringWithFormat:@"需要完成%@篇小组作业",scheme.scheme.finishNum];
//    }else if (scheme.scheme.toolID.integerValue == 208 || scheme.scheme.toolID.integerValue == 308) {
//        return [NSString stringWithFormat:@"需要自荐%@篇作业",scheme.scheme.finishNum];
//    }else if (scheme.scheme.toolID.integerValue == 205 || scheme.scheme.toolID.integerValue == 305) {
//        return [NSString stringWithFormat:@"需要完成%@篇研修总结",scheme.scheme.finishNum];
//    }else {
//        return [NSString stringWithFormat:@"需要完成%@篇作业",scheme.scheme.finishNum];
//    }
//}
@end
