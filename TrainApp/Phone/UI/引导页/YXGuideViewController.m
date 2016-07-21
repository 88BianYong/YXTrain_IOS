//
//  YXGuideViewController.m
//  TrainApp
//
//  Created by 李五民 on 16/7/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGuideViewController.h"
#import "YXGuideCustomView.h"
#import "YXGuideModel.h"
#import "YXPageControl.h"
@interface YXGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, strong) YXPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign)int tempPage;

@end

@implementation YXGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPageScrollView];
    [self setupPageControl];
    // Do any additional setup after loading the view.
}

- (void)setupPageScrollView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.pages = self.guideDataArray.count;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    CGFloat viewW = scrollView.frame.size.width;
    CGFloat viewH = scrollView.frame.size.height;
    for (int i=0; i< self.pages; i++) {
        YXGuideCustomView *guideView = [[YXGuideCustomView alloc] init];
        [guideView configWithGuideModel:[self.guideDataArray objectAtIndex:i]];
        @weakify(self);
        guideView.startButtonClickedBlock = ^(){
            @strongify(self);
            if (self.startMainVCBlock) {
                self.startMainVCBlock();
            }
        };
        [scrollView addSubview:guideView];
        CGRect frame = guideView.frame;
        frame.size = CGSizeMake(viewW, viewH);
        frame.origin.x = i * viewW;
        frame.origin.y = 0;
        guideView.frame = frame;
    }
    scrollView.contentSize = CGSizeMake(viewW*self.pages, viewH);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor clearColor];
}

- (void)setupPageControl {
    YXPageControl *pageControl = [[YXPageControl alloc] init];
    pageControl.backgroundColor = [UIColor lightGrayColor];
    pageControl.numberOfPages = self.pages;
    pageControl.center = CGPointMake(self.view.center.x, self.view.frame.size.height-30);
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"3592e0"];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //获得页码
    CGFloat doublePage = scrollView.contentOffset.x/scrollView.frame.size.width;
    int intPage = (int)(doublePage + 0.5);   //滑过当前页一半时换页
    //设置页码
    self.pageControl.currentPage = intPage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
