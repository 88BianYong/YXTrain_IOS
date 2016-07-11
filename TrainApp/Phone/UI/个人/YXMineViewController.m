//
//  YXMineViewController.m
//  TrainApp
//
//  Created by 李五民 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXMineViewController.h"
#import "YXUserImageTableViewCell.h"
#import "YXUserInfoTableViewCell.h"
#import "YXSchoolSearchViewController.h"
#import "YXUserTextFieldTableViewCell.h"
#import "YXUserProfileRequest.h"
#import "YXStageAndSubjectRequest.h"
#import "YXPickerViewController.h"
#import "YXProvinceList.h"
#import "YXUpdateProfileRequest.h"
#import "YXImagePickerController.h"
//#import "YXActionSheet.h"
#import "UIImage+YXImage.h"
#import "YXUploadHeadImgRequest.h"
#import "HJCActionSheet.h"


@interface YXMineViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,HJCActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXUserProfile *profile;

@property (nonatomic, strong) YXStageAndSubjectRequest *stageAndSubjectRequest;
@property (nonatomic, strong) YXStageAndSubjectItem *stageAndSubjectItem;
@property (nonatomic, assign) YXPickerType pickerType;
@property (nonatomic, strong) NSArray *selectedSubjects;
@property (nonatomic, strong) YXStageAndSubjectItem_Stage *selectedStage;
@property (nonatomic, strong) YXStageAndSubjectItem_Stage_Subject *selectedSubject;
@property (nonatomic, strong) YXPickerViewController *pickerViewController;

@property (nonatomic, strong) NSArray *selectedCitys;
@property (nonatomic, strong) NSArray *selectedCounties;
@property (nonatomic, strong) YXProvince *selectedProvince;
@property (nonatomic, strong) YXCity *selectedCity;
@property (nonatomic, strong) YXCounty *selectedCounty;
@property (nonatomic, strong) YXProvinceList *provinceList;

@property (nonatomic, strong) YXImagePickerController *imagePickerController;
@property (nonatomic, strong) HJCActionSheet *actionSheet;
@property (nonatomic, strong) YXUploadHeadImgRequest *uploadHeadImgRequest;


@end

@implementation YXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self reloadUserProfileData];
    // Do any additional setup after loading the view.
}

- (void)reloadUserProfileData
{
    self.profile = [YXUserManager sharedManager].userModel.profile;
    if (!self.profile) {
        [self requestUserProfile];
    } else {
        [self reloadDataWithProfile:self.profile];
        [self.tableView reloadData];
    }
}

- (void)requestUserProfile
{
    [self startLoading];
    @weakify(self);
    [[YXUserProfileHelper sharedHelper] requestCompeletion:^(NSError *error) {
        @strongify(self);
        [self stopLoading];
        [self reloadDataWithProfile:self.profile];
        [self.tableView reloadData];
    }];
}

- (void)setupUI {
    self.title = @"个人信息";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    [self.tableView registerClass:[YXUserImageTableViewCell class] forCellReuseIdentifier:@"YXUserImageTableViewCell"];
    [self.tableView registerClass:[YXUserInfoTableViewCell class] forCellReuseIdentifier:@"YXUserInfoTableViewCell"];
    [self.tableView registerClass:[YXUserTextFieldTableViewCell class] forCellReuseIdentifier:@"YXUserTextFieldTableViewCell"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark --TabelViewDelegate, TabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YXUserImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXUserImageTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setImageWithUrl:self.profile.headDetail];
        cell.userImageTap = ^(){
            [self changeAvatar];
        };
        return cell;
    } else if(indexPath.section == 1){
        YXUserTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXUserTextFieldTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setUserName:self.profile.realName];
        cell.startUpdateUserName = ^(NSString *name){
            [self updateUserNameWithString:name];
        };
        return cell;
    } else {
        YXUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXUserInfoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 2) {
            NSString *content = self.profile.stage;
            if ([self.profile.subject yx_isValidString]) {
                if ([content yx_isValidString]) {
                    content = [NSString stringWithFormat:@"%@ / %@", content, self.profile.subject];
                } else {
                    content = self.profile.subject;
                }
            }
            [cell configUIwithTitle:@"学科 | 学段" content:content];
            cell.userInfoButtonClickedBlock = ^() {
                [self showStageAndSubjectPicker];
            };
        }
        if (indexPath.section == 3) {
            [cell configUIwithTitle:@"地区" content:self.profile.area];
            cell.userInfoButtonClickedBlock = ^() {
                [self showProvinceListPicker];
            };
        }
        if (indexPath.section == 4) {
            [cell configUIwithTitle:@"学校" content:self.profile.school];
            cell.userInfoButtonClickedBlock = ^() {
                YXSchoolSearchViewController *vc = [[YXSchoolSearchViewController alloc] init];
                vc.areaId = self.profile.regionId;
                vc.addSchoolNameSuccessBlock = ^(NSString *schoolName){
                    YXUserInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
                    [cell configUIwithTitle:@"学校" content:schoolName];
                    if (self.schoolModifySuccess) {
                        self.schoolModifySuccess(schoolName);
                    }
                };
                [self.navigationController pushViewController:vc animated:NO];
            };
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 190;
    } else {
        return 43;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma private 

- (void)reloadDataWithProfile:(YXUserProfile *)profile
{
    [self resetSelectedSubjectsWithProfile:profile];
    [self resetSelectedProvinceDataWithProfile:profile];
}

- (void)resetSelectedSubjectsWithProfile:(YXUserProfile *)profile
{
    if (!profile) {
        return;
    }
    [self loadLocalStagesAndSubjects];
    [self.stageAndSubjectItem.stages enumerateObjectsUsingBlock:^(YXStageAndSubjectItem_Stage *stage, NSUInteger idx, BOOL *stop) {
        if ([profile.stageId isEqualToString:stage.sid]) {
            self.selectedStage = stage;
            self.selectedSubjects = self.selectedStage.subjects;
            *stop = YES;
        }
    }];
    [self.selectedSubjects enumerateObjectsUsingBlock:^(YXStageAndSubjectItem_Stage_Subject *subject, NSUInteger idx, BOOL *stop) {
        if ([profile.subjectId isEqualToString:subject.sid]) {
            self.selectedSubject = subject;
            *stop = YES;
        }
    }];
}

- (void)resetSelectedProvinceDataWithProfile:(YXUserProfile *)profile
{
    if (!profile) {
        return;
    }
    [self parseProvinceList];
    [self.provinceList.provinces enumerateObjectsUsingBlock:^(YXProvince *province, NSUInteger idx, BOOL *stop) {
        if ([profile.province isEqualToString:province.name]) {
            self.selectedProvince = province;
            self.selectedCitys = self.selectedProvince.citys;
            *stop = YES;
        }
    }];
    [self.selectedCitys enumerateObjectsUsingBlock:^(YXCity *city, NSUInteger idx, BOOL *stop) {
        if ([profile.city isEqualToString:city.name]) {
            self.selectedCity = city;
            self.selectedCounties = city.counties;
            *stop = YES;
        }
    }];
    [self.selectedCounties enumerateObjectsUsingBlock:^(YXCounty *county, NSUInteger idx, BOOL *stop) {
        if ([profile.region isEqualToString:county.name]) {
            self.selectedCounty = county;
            *stop = YES;
        }
    }];
}

- (void)showProvinceListPicker
{
    self.pickerType = YXPickerTypeProvince;
    if (!self.provinceList || !self.provinceList.provinces) {
        [self parseProvinceList];
    }
    [self reloadPickerViewWithResetSelectedProvinceData];
}

- (void)parseProvinceList
{
    if (!self.provinceList || !self.provinceList.provinces) {
        self.provinceList = [[YXProvinceList alloc] init];
        [self.provinceList startParse];
    }
}

- (void)reloadPickerViewWithResetSelectedProvinceData
{
    NSInteger selectedRowInComponent0 = 0;
    NSInteger selectedRowInComponent1 = 0;
    NSInteger selectedRowInComponent2 = 0;
    if ([self.provinceList.provinces containsObject:self.selectedProvince]) {
        selectedRowInComponent0 = [self.provinceList.provinces indexOfObject:self.selectedProvince];
    } else if (self.provinceList.provinces.count > 0) {
        self.selectedCitys = ((YXProvince *)self.provinceList.provinces[0]).citys;
    }
    
    if ([self.selectedCitys containsObject:self.selectedCity]) {
        selectedRowInComponent1 = [self.selectedCitys indexOfObject:self.selectedCity];
    } else if (self.selectedCitys.count > 0) {
        self.selectedCounties = ((YXCity *)self.selectedCitys[0]).counties;
    }
    
    if ([self.selectedCounties containsObject:self.selectedCounty]) {
        selectedRowInComponent2 = [self.selectedCounties indexOfObject:self.selectedCounty];
    }
    
    [self.pickerViewController reloadPickerView];
    [self.pickerViewController.pickerView selectRow:selectedRowInComponent0 inComponent:0 animated:NO];
    [self.pickerViewController.pickerView selectRow:selectedRowInComponent1 inComponent:1 animated:NO];
    [self.pickerViewController.pickerView selectRow:selectedRowInComponent2 inComponent:2 animated:NO];
}

- (YXPickerViewController *)pickerViewController
{
    if (!_pickerViewController) {
        _pickerViewController = [[YXPickerViewController alloc] init];
        _pickerViewController.view.frame = self.view.bounds;
        _pickerViewController.pickerView.delegate = self;
        _pickerViewController.pickerView.dataSource = self;
        @weakify(self);
        _pickerViewController.confirmBlock = ^{
            @strongify(self);
            switch (self.pickerType) {
                case YXPickerTypeStageAndSubject:
                {
                    NSInteger row = [self.pickerViewController.pickerView selectedRowInComponent:0];
                    self.selectedStage = self.stageAndSubjectItem.stages[row];
                    row = [self.pickerViewController.pickerView selectedRowInComponent:1];
                    self.selectedSubject = self.selectedSubjects[row];
                    [self updateStageAndSubject];
                }
                    break;
                case YXPickerTypeProvince:
                {
                    NSInteger row = [self.pickerViewController.pickerView selectedRowInComponent:0];
                    self.selectedProvince = self.provinceList.provinces[row];
                    row = [self.pickerViewController.pickerView selectedRowInComponent:1];
                    self.selectedCity = self.selectedCitys[row];
                    row = [self.pickerViewController.pickerView selectedRowInComponent:2];
                    self.selectedCounty = self.selectedCounties[row];
                    [self updateArea];
                }
                    break;
                case YXPickerTypeDefault:
                default:
                    break;
            }
        };
        [self.view addSubview:_pickerViewController.view];
        [self addChildViewController:_pickerViewController];
    }
    return _pickerViewController;
}

- (void)updateUserNameWithString:(NSString *)name {
    if ([name isEqualToString:[YXUserManager sharedManager].userModel.profile.realName]) {
        return;
    }
    @weakify(self);
    [self startLoading];
    [[YXUpdateProfileHelper instance] requestWithType:YXUpdateProfileTypeRealname param:@{@"realName":name} completion:^(NSError *error) {
        @strongify(self);
        [self stopLoading];
        YXUserTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        if (!error) {
            [cell setUserName:name];
            if (self.nameModifySuccess) {
                self.nameModifySuccess(name);
            }
        } else {
            [cell setUserName:self.profile.realName];
            [self showToast:error.localizedDescription];
        }
    }];
}

- (void)updateStageAndSubject
{
    if ([self.selectedStage.sid isEqualToString:[YXUserManager sharedManager].userModel.profile.stageId]
        && [self.selectedSubject.sid isEqualToString:[YXUserManager sharedManager].userModel.profile.subjectId]) {
        return;
    }
    
    NSDictionary *param = @{@"stageId": self.selectedStage.sid,
                            @"subjectId": self.selectedSubject.sid,
                            @"stage": self.selectedStage.name,
                            @"subject": self.selectedSubject.name};
    @weakify(self);
    [self startLoading];
    [[YXUpdateProfileHelper instance] requestWithType:YXUpdateProfileTypeStage param:param completion:^(NSError *error) {
        @strongify(self);
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
        } else {
            YXUserInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            [cell configUIwithTitle:@"学科 | 学段" content:[NSString stringWithFormat:@"%@ / %@", self.selectedStage.name, self.selectedSubject.name]];
        }
    }];
}

- (void)updateArea
{
    if ([self.selectedCounty.zipcode isEqualToString:[YXUserManager sharedManager].userModel.profile.regionId]) {
        return;
    }
    
    NSDictionary *param = @{@"areaId":self.selectedCounty.zipcode,
                            @"province":self.selectedProvince.name,
                            @"city":self.selectedCity.name,
                            @"region":self.selectedCounty.name};
    @weakify(self);
    [self startLoading];
    [[YXUpdateProfileHelper instance] requestWithType:YXUpdateProfileTypeArea param:param completion:^(NSError *error) {
        @strongify(self);
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
        } else {
            YXUserInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
            [cell configUIwithTitle:@"地区" content:[NSString stringWithFormat:@"%@%@%@", self.selectedProvince.name, self.selectedCity.name,self.selectedCounty.name]];
        }
    }];
}

- (void)showStageAndSubjectPicker
{
    self.pickerType = YXPickerTypeStageAndSubject;
    if (self.stageAndSubjectItem) {
        [self reloadPickerViewWithResetSelectedSubjects];
    } else {
        [self requestStageAndSubject];
    }
}

- (void)requestStageAndSubject
{
    if (self.stageAndSubjectRequest) {
        [self.stageAndSubjectRequest stopRequest];
    }
    self.stageAndSubjectRequest = [[YXStageAndSubjectRequest alloc] init];
    @weakify(self);
    [self startLoading];
    [self.stageAndSubjectRequest startRequestWithRetClass:[YXStageAndSubjectItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self);
        [self stopLoading];
        YXStageAndSubjectItem *item = retItem;
        if (item) {
            self.stageAndSubjectItem = item;
        } else {
            [self loadLocalStagesAndSubjects];
        }
        [self reloadPickerViewWithResetSelectedSubjects];
    }];
}

- (void)loadLocalStagesAndSubjects
{
    if (self.stageAndSubjectItem) {
        return;
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"stagesSubjects" ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ([json isKindOfClass:[NSDictionary class]]) {
        self.stageAndSubjectItem = [[YXStageAndSubjectItem alloc] initWithDictionary:json error:&error];
    }
}

- (void)reloadPickerViewWithResetSelectedSubjects
{
    NSInteger selectedRowInComponent0 = 0;
    NSInteger selectedRowInComponent1 = 0;
    if ([self.stageAndSubjectItem.stages containsObject:self.selectedStage]) {
        selectedRowInComponent0 = [self.stageAndSubjectItem.stages indexOfObject:self.selectedStage];
    } else if (self.stageAndSubjectItem.stages.count > 0) {
        self.selectedSubjects = ((YXStageAndSubjectItem_Stage *)self.stageAndSubjectItem.stages[0]).subjects;
    }
    
    if ([self.selectedSubjects containsObject:self.selectedSubject]) {
        selectedRowInComponent1 = [self.selectedSubjects indexOfObject:self.selectedSubject];
    }
    
    [self.pickerViewController reloadPickerView];
    [self.pickerViewController.pickerView selectRow:selectedRowInComponent0 inComponent:0 animated:NO];
    [self.pickerViewController.pickerView selectRow:selectedRowInComponent1 inComponent:1 animated:NO];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (self.pickerType) {
        case YXPickerTypeStageAndSubject:
            return 2;
        case YXPickerTypeProvince:
            return 3;
        case YXPickerTypeDefault:
        default:
            return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (self.pickerType) {
        case YXPickerTypeStageAndSubject:
        {
            switch (component) {
                case 0:
                    return self.stageAndSubjectItem.stages.count;
                case 1:
                    return self.selectedSubjects.count;
                default:
                    return 0;
            }
        }
        case YXPickerTypeProvince:
        {
            switch (component) {
                case 0:
                    return self.provinceList.provinces.count;
                case 1:
                    return self.selectedCitys.count;
                case 2:
                    return self.selectedCounties.count;
                default:
                    return 0;
            }
        }
        case YXPickerTypeDefault:
        default:
            return 0;
    }
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    NSInteger count = [self numberOfComponentsInPickerView:pickerView];
    if (count <= 0) {
        return 0;
    }
    
    return (CGRectGetWidth(self.view.bounds)) / count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 36.f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (self.pickerType) {
        case YXPickerTypeStageAndSubject:
        {
            switch (component) {
                case 0:
                    return ((YXStageAndSubjectItem_Stage *)self.stageAndSubjectItem.stages[row]).name;
                case 1:
                    return ((YXStageAndSubjectItem_Stage_Subject *)self.selectedSubjects[row]).name;
                default:
                    return nil;
            }
        }
        case YXPickerTypeProvince:
        {
            switch (component) {
                case 0:
                    return ((YXProvince *)self.provinceList.provinces[row]).name;
                case 1:
                    return ((YXCity *)self.selectedCitys[row]).name;
                case 2:
                    return ((YXCounty *)self.selectedCounties[row]).name;
                default:
                    return nil;
            }
        }
        case YXPickerTypeDefault:
        default:
            return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (self.pickerType) {
        case YXPickerTypeStageAndSubject:
            switch (component) {
                case 0:
                {
                    self.selectedSubjects = ((YXStageAndSubjectItem_Stage *)self.stageAndSubjectItem.stages[row]).subjects;
                    [pickerView reloadComponent:1];
                    [pickerView selectRow:0 inComponent:1 animated:NO];
                }
                    break;
                case 1:
                default:
                    break;
            }
            break;
        case YXPickerTypeProvince:
            switch (component) {
                case 0:
                {
                    self.selectedCitys = ((YXProvince *)self.provinceList.provinces[row]).citys;
                    self.selectedCounties = ((YXCity *)self.selectedCitys[0]).counties;
                    [pickerView reloadComponent:1];
                    [pickerView reloadComponent:2];
                    [pickerView selectRow:0 inComponent:1 animated:NO];
                    [pickerView selectRow:0 inComponent:2 animated:NO];
                }
                    break;
                case 1:
                {
                    self.selectedCounties = ((YXCity *)self.selectedCitys[row]).counties;
                    [pickerView reloadComponent:2];
                    [pickerView selectRow:0 inComponent:2 animated:NO];
                }
                    break;
                case 2:
                default:
                    break;
            }
            break;
        case YXPickerTypeDefault:
        default:
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor whiteColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
        pickerLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - 更换头像

- (YXImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [[YXImagePickerController alloc] init];
    }
    return _imagePickerController;
}

- (void)changeAvatar
{
    _actionSheet = [[HJCActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    [self.actionSheet show];
}

#pragma mark - HJCActionSheetDelegate
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
        {
            @weakify(self);
            [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera completion:^(UIImage *selectedImage) {
                @strongify(self);
                [self updateWithHeaderImage:selectedImage];
            }];
        }
            break;
        case 2:{
            @weakify(self);
            [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImage *selectedImage) {
                @strongify(self);
                [self updateWithHeaderImage:selectedImage];
            }];
        
        }
            break;
            
        default:
            break;
    }
}

- (void)updateWithHeaderImage:(UIImage *)image
{
    if (!image) {
        return;
    }
    NSData *data = [UIImage compressionImage:image limitSize:2*1024*1024];
    [self.uploadHeadImgRequest stopRequest];
    self.uploadHeadImgRequest = [[YXUploadHeadImgRequest alloc] init];
    [self.uploadHeadImgRequest.request setData:data
                                  withFileName:@"head.jpg"
                                andContentType:nil
                                        forKey:@"newUpload"];
    @weakify(self);
    [self startLoading];
    [self.uploadHeadImgRequest startRequestWithRetClass:[YXUploadHeadImgItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self);
        [self stopLoading];
        if (retItem && !error) {
            YXUploadHeadImgItem *item = retItem;
            self.profile.head = item.url;
            self.profile.headDetail = item.headDetail;
            [YXUserManager sharedManager].userModel.head = item.url;
            [YXUserManager sharedManager].userModel.profile.headDetail = item.headDetail;
            [[YXUserManager sharedManager] saveUserData];
            
            YXUserImageTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell setImageWithDataImage:image];
            
            if (self.userPicModifySuccess) {
                self.userPicModifySuccess(image);
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:YXUpdateHeadImgSuccessNotification object:nil];
        } else {
            [self showToast:error.localizedDescription];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 40;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
