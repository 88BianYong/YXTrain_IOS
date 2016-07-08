//
//  YXSchoolSearchViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXSchoolSearchViewController.h"
#import "YXSchoolSearchRequest.h"
#import "YXUserProfile.h"
#import "YXUpdateProfileRequest.h"
@interface YXSchoolSearchViewController ()
<
  UITableViewDelegate,
  UITableViewDataSource,
  UISearchBarDelegate
>
{
    UISearchBar *_searchBar;
    UIButton *_addButton;
    UITableView * _tableView;
    UILabel *_rangeLabel;
    
    YXSchoolSearchRequest *_searchRequest;
    YXSchoolSearchItem *_item;
}
@end

@implementation YXSchoolSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"学校名称";
    [self setupUI];
    [self layoutInterace];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_searchRequest stopRequest];
}

#pragma mark - UI setting
- (void)setupUI{
    _addButton = [[UIButton alloc] init];
    [_addButton addTarget:self action:@selector(schoolAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    _addButton.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    _addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _addButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:_addButton];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.placeholder = @"输入查找学校";
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    _searchBar.backgroundImage = [[UIImage alloc] init];
    //    _searchBar.barTintColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.view addSubview:_searchBar];
    
    _rangeLabel = [[UILabel alloc] init];
    _rangeLabel.text = @"范围: 北京市 朝阳区";
    _rangeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _rangeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:_rangeLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 0.0f);
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.separatorColor = [UIColor colorWithHexString:@"eceef2"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"staticString"];
    [self.view addSubview:_tableView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 85.5f, self.view.bounds.size.width - 15.0f, 0.5f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.view addSubview:lineView];
}

- (void)layoutInterace{
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0.0f);
        make.height.mas_equalTo(40.0f);
    }];
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_searchBar.mas_right).offset(-10.0f);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(_searchBar.mas_height);
        make.width.mas_equalTo(57.0f);
    }];
    
    [_rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15.0f);
        make.top.equalTo(_searchBar.mas_bottom);
        make.height.offset(45.0f);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.0f);
        make.top.equalTo(_rangeLabel.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _item.schools.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"staticString" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"334466"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = ((YXSchool *)_item.schools[indexPath.row]).name;;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectedSchool:_item.schools[indexPath.row]];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self requestSchoolSearch:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}
#pragma mark - request
- (void)requestSchoolSearch:(NSString *)searchText
{
    if (_searchRequest) {
        [_searchRequest stopRequest];
    }
    
    searchText = [searchText yx_stringByTrimmingCharacters];
    if (searchText.length <= 0) {
        _item = nil;
        [_tableView reloadData];
    }
    else{
        YXSchoolSearchRequest *request = [[YXSchoolSearchRequest alloc] init];
        if (self.areaId) {
            request.areaId = self.areaId;
        }
        request.schoolName = searchText;
        WEAK_SELF
        [self startLoading];
        [request startRequestWithRetClass:[YXSchoolSearchItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
 //           YXSchoolSearchItem *item = retItem;
            NSString *pathString = [[NSBundle mainBundle] pathForResource:@"search" ofType:@"txt"];
            NSString *string = [NSString stringWithContentsOfFile:pathString encoding:NSUTF8StringEncoding error:nil];
            YXSchoolSearchItem *item = [[YXSchoolSearchItem alloc] initWithString:string error:nil];
            if (item) {
                self ->_item = item;
                [self ->_tableView reloadData];
            }
        }];
        _searchRequest = request;
    }
}

#pragma mark - button Action
- (void)schoolAddButtonAction:(UIButton *)sender{
    NSString *schoolName = [_searchBar.text yx_stringByTrimmingCharacters];
    if ([schoolName yx_isValidString]) {
        NSError *error = nil;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:schoolName forKey:@"name"];
        if (self.areaId) {
            [dict setObject:self.areaId forKey:@"areaId"];
        }
        YXSchool *school = [[YXSchool alloc] initWithDictionary:dict error:&error];
        [self selectedSchool:school];
    }
    
}
- (void)selectedSchool:(YXSchool *)school
{
    [self updateRequestWithSchool:school];
}

#pragma mark -

- (void)updateRequestWithSchool:(YXSchool *)school
{
    if (![school.name yx_isValidString]
        || [school.name isEqualToString:[YXUserManager sharedManager].userModel.profile.school]) {
        return;
    }
    NSDictionary *param = @{@"schoolName": school.name,
                            @"schoolId": school.sid?:@""};
    @weakify(self);
    [self startLoading];
    [[YXUpdateProfileHelper instance] requestWithType:YXUpdateProfileTypeSchool param:param completion:^(NSError *error) {
        @strongify(self);
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}
@end
