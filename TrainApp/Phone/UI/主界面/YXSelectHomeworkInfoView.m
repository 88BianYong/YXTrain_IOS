//
//  YXSelectHomeworkInfoView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
@interface YXSelectHomeworkInfoCell : UITableViewCell
@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) UIImageView *selectionImageView;
@property (nonatomic, strong) UIView *cellSeperatorView;
@property (nonatomic, assign) BOOL isSelectBool;
@end

@implementation YXSelectHomeworkInfoCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.orderLabel = [[UILabel alloc]init];
    self.orderLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.orderLabel];
    
    self.selectionImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.selectionImageView];
    
    self.cellSeperatorView = [[UIView alloc]init];
    self.cellSeperatorView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.cellSeperatorView];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.selectionImageView.mas_left).mas_offset(-10);
    }];
    
    [self.selectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.cellSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderLabel.mas_left);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

- (void)setIsSelectBool:(BOOL)isSelectBool{
    _isSelectBool = isSelectBool;
    if (_isSelectBool) {
        self.orderLabel.textColor = [UIColor colorWithHexString:@"0067be"];
        self.selectionImageView.image = [UIImage imageNamed:@"选择对号"];
    }else{
        self.orderLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.selectionImageView.image = nil;
    }
}

@end
#import "YXSelectHomeworkInfoView.h"
@interface YXSelectHomeworkInfoView()
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *itemMutableArray;
@property (nonatomic, assign) YXWriteHomeworkListStatus index;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, copy  ) NSString * selectedId;

@property (nonatomic, strong) UIImageView *topTriangleImageView;
@end
@implementation YXSelectHomeworkInfoView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.itemMutableArray = [[NSMutableArray alloc] initWithCapacity:10];
        [self setupUI];
    }
    return self;
}

- (void)setViewWithDataArray:(NSArray *)itemArray
                  withStatus:(YXWriteHomeworkListStatus)status
              withSelectedId:(NSString *)integerId
                 withOriginY:(CGFloat)y{
    [self.itemMutableArray addObjectsFromArray:itemArray];
    self.index = status;
    self.selectedId = integerId;
    self.originY = y;
    CGFloat tableHeight = 265.0f;
    //MIN(_itemMutableArray.count*44, 242);
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.originY);
        make.left.mas_equalTo(55.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(tableHeight);
    }];
    
    [self.topTriangleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableView.mas_top);
        make.right.equalTo(self.tableView.mas_right).offset(-14.0f);
        make.height.mas_offset(8.0f);
        make.width.mas_offset(18.0f);
        
    }];
    [self.tableView reloadData];
    
}
- (void)setupUI{
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderGesture:)];
    [self.maskView addGestureRecognizer:tapGesture];
    [self addSubview:self.maskView];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 44;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.layer.cornerRadius = YXTrainCornerRadii;
    self.tableView.layer.masksToBounds = YES;
    [self addSubview:self.tableView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.originY);
        make.left.mas_equalTo(55.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(308);
    }];
    [self.tableView registerClass:[YXSelectHomeworkInfoCell class] forCellReuseIdentifier:@"YXSelectHomeworkInfoCell"];
}

- (void)tapHeaderGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.tapCloseView) {
            self.tapCloseView(self.index);
        }
        [self removeFromSuperview];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_itemMutableArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXSelectHomeworkInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXSelectHomeworkInfoCell" forIndexPath:indexPath];
    YXCategoryListRequestItem_Data *data = _itemMutableArray[indexPath.row];
    cell.orderLabel.text = data.name;
    if ([data.categoryId isEqualToString: self.selectedId]) {
        cell.isSelectBool = YES;
    }else{
        cell.isSelectBool = NO;
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self removeFromSuperview];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLOCK_EXEC(self.didSeletedItem,indexPath.row, self.index);
}

- (UIImageView *)topTriangleImageView {
    if (!_topTriangleImageView) {
        _topTriangleImageView = [UIImageView new];
        _topTriangleImageView.image = [UIImage imageNamed:@"切换项目名称的弹窗-尖角"];
        [self addSubview:_topTriangleImageView];
    }
    return _topTriangleImageView;
}
@end
