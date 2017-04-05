//
//  VideoClassworkView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoClassworkView.h"
#import "UITableView+TemplateLayoutHeaderView.h"
#import "VideoClassworkCell.h"
#import "VideoClassworkHeaderView.h"
#import "YXNoFloatingHeaderFooterTableView.h"

@interface VideoClassworkView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, assign) VideoClassworkAnswerStatus answerStatus;
@property (nonatomic, assign) VideoClassworkCellStatus classworkStatus;
@property (nonatomic, strong) NSMutableArray *answerMutableArray;
@end
@implementation VideoClassworkView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.answerMutableArray = [[NSMutableArray alloc] init];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.containerView.layer.cornerRadius = YXTrainCornerRadii;
    [self addSubview:self.containerView];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"随堂测试";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.containerView addSubview:self.titleLabel];
    
    
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.estimatedRowHeight = 44.0f;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedSectionHeaderHeight = 44.0f;
//    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    [self.containerView addSubview:self.tableView];
    [self.tableView registerClass:[VideoClassworkCell class] forCellReuseIdentifier:@"VideoClassworkCell"];
    [self.tableView registerClass:[VideoClassworkHeaderView class] forHeaderFooterViewReuseIdentifier:@"VideoClassworkHeaderView"];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.9f, 65.0f)];
    self.tableView.tableFooterView = footerView;
    
    self.confirmButton = [[UIButton alloc] init];
    self.confirmButton.layer.cornerRadius = YXTrainCornerRadii;
    self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"f3f7fa"].CGColor;
    self.confirmButton.layer.borderWidth = 1.0f;
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
    
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f3f7fa"]] forState:UIControlStateDisabled];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"]
                            forState:UIControlStateDisabled];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.confirmButton.enabled = NO;
    WEAK_SELF
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.answerStatus == VideoClassworkAnswerStatus_Normal) {
            [self.answerMutableArray removeAllObjects];
            [self.question.answerJson enumerateObjectsUsingBlock:^(YXVideoQuestionsRequestItem_Result_Questions_Question_AnswerJson *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isChoose.boolValue) {
                    [self.answerMutableArray addObject:obj.no];
                }
            }];
            BLOCK_EXEC(self.videoClassworkButtonActionBlock,self.answerStatus,self.answerMutableArray);
        }else {
            BLOCK_EXEC(self.videoClassworkButtonActionBlock,self.answerStatus,nil);
        }
    }];
    [footerView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(25.0f);
        make.centerX.equalTo(footerView.mas_centerX);
        make.size.mas_offset(CGSizeMake(160.0f, 39.0f));
    }];
    self.classworkStatus = VideoClassworkCellStatus_Normal;
}

- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self).multipliedBy(9.0f/10.0f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.height.mas_offset(50.0f);
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
}
#pragma mark - UITableViewDelegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.question.answerJson.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoClassworkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoClassworkCell" forIndexPath:indexPath];
    cell.answer = self.question.answerJson[indexPath.row];
    if ([self isFirstChooseAnswer:cell.answer.no.integerValue]) {
        cell.classworkStatus = self.answerStatus == VideoClassworkAnswerStatus_Right ? VideoClassworkCellStatus_Right : VideoClassworkCellStatus_Error;
    }else {
       cell.classworkStatus = VideoClassworkCellStatus_Normal;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.answerStatus == VideoClassworkAnswerStatus_Normal) {
        [self classworkChooseLogic:indexPath.row];
    }
}
- (BOOL)isFirstChooseAnswer:(NSInteger)integer {
    if (self.answerMutableArray.count == 0 || self.answerStatus == VideoClassworkAnswerStatus_Normal) {
        return NO;
    }
    if ([self.answerMutableArray[0] integerValue] == integer) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VideoClassworkHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"VideoClassworkHeaderView"];
    headerView.question = self.question;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [tableView yx_heightForHeaderWithIdentifier:@"VideoClassworkHeaderView" configuration:^(VideoClassworkHeaderView *headerView) {
        headerView.question = self.question;
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"VideoClassworkCell" configuration:^(VideoClassworkCell *cell) {
        cell.answer = self.question.answerJson[indexPath.row];
        if ([self isFirstChooseAnswer:cell.answer.no.integerValue]) {
            cell.classworkStatus = self.answerStatus == VideoClassworkAnswerStatus_Right ? VideoClassworkCellStatus_Right : VideoClassworkCellStatus_Error;
        }else {
            cell.classworkStatus = VideoClassworkCellStatus_Normal;
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
#pragma mark choose
- (void)classworkChooseLogic:(NSInteger)row {
    YXVideoQuestionsRequestItem_Result_Questions_Question_AnswerJson *temp = self.question.answerJson[row];
    if (self.question.types.integerValue == 2) {//多选允许取消
        temp.isChoose = [NSString stringWithFormat:@"%d",![temp.isChoose boolValue]];
       __block BOOL isChoose = NO;
        [self.question.answerJson enumerateObjectsUsingBlock:^(YXVideoQuestionsRequestItem_Result_Questions_Question_AnswerJson  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isChoose.boolValue) {
                isChoose = YES;
                return ;
            }
        }];
        if (isChoose) {
            self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
            self.confirmButton.enabled = YES;
        }else {
            self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"334466"].CGColor;
            self.confirmButton.enabled = NO;
        }
    }else {
        [self.question.answerJson enumerateObjectsUsingBlock:^(YXVideoQuestionsRequestItem_Result_Questions_Question_AnswerJson  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isChoose = @"0";
        }];
        temp.isChoose = @"1";
        self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
        self.confirmButton.enabled = YES;
    }    
    [self.tableView reloadData];
    DDLogDebug(@"1");
}
#pragma mark - set
- (void)setQuestion:(YXVideoQuestionsRequestItem_Result_Questions_Question *)question {
    _question = question;
    if (_question.types.integerValue == 4) {
        [_question.answerJson enumerateObjectsUsingBlock:^(YXVideoQuestionsRequestItem_Result_Questions_Question_AnswerJson *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.no.integerValue == 2) {
                obj.no = @"0";
            }
        }];
    }
}
- (void)setAnswerStatus:(VideoClassworkAnswerStatus)answerStatus {
    _answerStatus = answerStatus;
    switch (_answerStatus) {
        case VideoClassworkAnswerStatus_Normal:
        {
            [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        }
            break;
        case VideoClassworkAnswerStatus_Right:
        {
            [self.confirmButton setTitle:@"继续学习" forState:UIControlStateNormal];

        }
            break;
        case VideoClassworkAnswerStatus_Error:
        {
            [self.confirmButton setTitle:@"继续学习" forState:UIControlStateNormal];

        }
            break;
        case VideoClassworkAnswerStatus_ForceError:
        {
            [self.confirmButton setTitle:@"返回当前章节" forState:UIControlStateNormal];

        }
            break;
            
        default:
            break;
    }
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        self.answerStatus = VideoClassworkAnswerStatus_Normal;
        self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"f3f7fa"].CGColor;
        self.confirmButton.enabled = NO;
    }else {
        [self.answerMutableArray removeAllObjects];
        [self.tableView reloadData];
    }

}
- (void)refreshClassworkViewAnsewr:(BOOL)isTrue quizCorrect:(BOOL)isForce {
    if (isTrue) {
        self.answerStatus = VideoClassworkAnswerStatus_Right;
    }else {
        if (isForce) {
            self.answerStatus = VideoClassworkAnswerStatus_ForceError;
        }else {
            self.answerStatus = VideoClassworkAnswerStatus_Error;
        }
    }
    [self.tableView reloadData];
}

@end
