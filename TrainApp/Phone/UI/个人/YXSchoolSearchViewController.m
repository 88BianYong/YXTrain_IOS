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
    YXEmptyView *_emptyView;
    
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
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}
#pragma mark - UI setting
- (void)setupUI{
    //TD:嘉伦要求去掉学校添加按键 0901
    _addButton = [[UIButton alloc] init];
    [_addButton addTarget:self action:@selector(schoolAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    _addButton.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    _addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _addButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _addButton.hidden = YES;
    [self.view addSubview:_addButton];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.placeholder = @"输入查找学校";
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    _searchBar.backgroundImage = [[UIImage alloc] init];
//    [_searchBar setImage:[UIImage imageNamed:@"输入搜索学校名称icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    //    _searchBar.barTintColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.view addSubview:_searchBar];
    
    UITextField *searchField = [_searchBar valueForKey:@"searchField"];
    if (searchField) {
        searchField.layer.cornerRadius = 2.0f;
        searchField.font = [UIFont systemFontOfSize:14.0f];
//        [searchField setValue:[UIColor colorWithHexString:@"dfe2e6"] forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setValue:[UIFont systemFontOfSize:14.0f] forKeyPath:@"_placeholderLabel.font"];
    }
    _rangeLabel = [[UILabel alloc] init];
    _rangeLabel.text = [NSString stringWithFormat:@"范围:  %@ ",self.areaName];
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
    
    _emptyView = [[YXEmptyView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 40.0f - 64.0f)];
    _emptyView.title = @"没有符合条件的学校";
    _emptyView.imageName = @"没有合适的学校";
    _emptyView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yx_hideKeyboard)];
    [_emptyView addGestureRecognizer:recognizer];    
}

- (void)layoutInterace{
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0.0f);
        make.height.mas_equalTo(40.0f);
        make.width.equalTo(self.view.mas_width);
    }];
//    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_searchBar.mas_right).offset(-10.0f);
//        make.right.equalTo(self.view.mas_right);
//        make.height.equalTo(_searchBar.mas_height);
//        make.width.mas_equalTo(57.0f);
//    }];
    
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
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
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
            if (error) {
                [self showToast:error.localizedDescription];
            }
            else{
                YXSchoolSearchItem *item = retItem;
                if (item.schools.count > 0) {
                    self ->_item = item;
                    [self ->_tableView reloadData];
                    [self ->_emptyView removeFromSuperview];
                }
                else{
                    [self.view addSubview:self ->_emptyView];
                }
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
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSDictionary *param = @{@"schoolName": school.name,
                            @"schoolId": school.sid?:@""};
    WEAK_SELF
    [self startLoading];
    [[YXUpdateProfileHelper instance] requestWithType:YXUpdateProfileTypeSchool param:param completion:^(NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
        } else {
            if (self.addSchoolNameSuccessBlock) {
                self.addSchoolNameSuccessBlock(school.name);
            }
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
