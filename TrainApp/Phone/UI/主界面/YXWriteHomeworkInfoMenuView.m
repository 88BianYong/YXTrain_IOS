//
//  YXWriteHomeworkInfoMenuView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
@interface YXMenuHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation YXMenuHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
        _contentLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(14.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        }];
    }
    return self;
}

@end


#import "YXWriteHomeworkInfoMenuView.h"
@interface YXWriteHomeworkInfoMenuView()
<
  UITableViewDelegate,
  UITableViewDataSource
>
{
    UILabel *_titleLabel;
    UIView * _backgroundView;
    UITableView *_tableView;
    UILabel *_errorLabel;
    
}
@end
@implementation YXWriteHomeworkInfoMenuView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"目录";
    _titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
    _backgroundView.layer.cornerRadius = YXTrainCornerRadii;
    [self.contentView addSubview:_backgroundView];
    
    _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[YXMenuHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXMenuHeaderView"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10.0f)];
    _tableView.tableHeaderView = headerView;
    [_backgroundView addSubview:_tableView];
    
    
    _errorLabel = [[UILabel alloc] init];
    _errorLabel.text = @"目录信息获取失败,请点击重试";
    _errorLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _errorLabel.font = [UIFont systemFontOfSize:14.0f];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.hidden = YES;
    _errorLabel.userInteractionEnabled = YES;
    [_backgroundView addSubview:_errorLabel];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(againRequest)];
    [_errorLabel addGestureRecognizer:recognizer];
    
}

- (void)layoutInterface{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.width.mas_offset(55.0f);
        make.top.equalTo(self.contentView.mas_top).offset(10.0f);
        make.height.mas_offset(40.0f);
    }];
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_titleLabel.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(10.0f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_backgroundView.mas_left).offset(0.0f);
        make.right.equalTo(self->_backgroundView.mas_right).offset(0.0f);
        make.top.equalTo(self->_backgroundView.mas_top);
        make.bottom.equalTo(self->_backgroundView.mas_bottom);
    }];
    
    [_errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self->_backgroundView);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 26.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YXMenuHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXMenuHeaderView"];
    YXChapterListRequestItem_sub *sub = _item.data[section];
    view.contentLabel.text = sub.name;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_indexPath){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:_indexPath];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"334466"];
        _indexPath = indexPath;
        cell = [tableView cellForRowAtIndexPath:_indexPath];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    }
    else{
        _indexPath = indexPath;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:_indexPath];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    }
    YXChapterListRequestItem_sub *sub = _item.data[indexPath.section];
    YXChapterListRequestItem_sub *model = sub.sub[indexPath.row];
    NSString *chapterId = [NSString stringWithFormat:@"%@,%@",sub.chapterId,model.chapterId];
    BLOCK_EXEC(self.chapterIdHandler,chapterId?:@"",model.name?:@"");
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _item.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YXChapterListRequestItem_sub *sub = _item.data[section];
    return sub.sub.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    YXChapterListRequestItem_sub *sub = _item.data[indexPath.section];
    YXChapterListRequestItem_sub *model = sub.sub[indexPath.row];
    cell.textLabel.text = model.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([_indexPath compare:indexPath] == NSOrderedSame && _indexPath) {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    }
    else{
        cell.textLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
    return cell;
}
- (void)setItem:(YXChapterListRequestItem *)item{
    _item = item;
    [_tableView reloadData];
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (_indexPath) {
        [_tableView scrollToRowAtIndexPath:_indexPath
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}
- (void)setIsError:(BOOL)isError{
    _isError = isError;
    _errorLabel.hidden = !_isError;
}
- (void)againRequest{
    BLOCK_EXEC(self.errorHandler);
}
@end
