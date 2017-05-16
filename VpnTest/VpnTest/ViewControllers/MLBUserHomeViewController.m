//
//  MLBUserHomeViewController.m
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBUserHomeViewController.h"
#import "ParallaxHeaderView.h"
#import "MLBUserHomeCell.h"
#import "MLBUserHomeHeaderView.h"
#import "MLBSettingsSectionHeaderView.h"
#import "MLBSettingsViewController.h"
#import "MLBContent.h"
#import "MLBHelp.h"
#import "MLBFriend.h"
#import "MLBIAP.h"

@interface MLBUserHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MLBUserHomeHeaderView *headerView;
@property (strong, nonatomic) UIImageView *headerImageViewMoon;
@property (strong, nonatomic) ParallaxHeaderView *parallaxHeaderViewMoon;
@property (strong, nonatomic) UIImageView *headerImageViewSun;
@property (strong, nonatomic) ParallaxHeaderView *parallaxHeaderViewSun;

@end

@implementation MLBUserHomeViewController {
    NSArray *sectionTitles;
    NSArray *rowTitles;
    NSArray *rowImageNames;
}

#pragma mark - Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.hideNavigationBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self initDatas];
    [self setupViews];
}

#pragma mark - Private Method

- (void)initDatas {
    sectionTitles = @[@"邀请好友", @"关于梦游兔"];
    rowTitles = @[@[@"邀请好友"], @[@"帮助说明", @"联系我们", @"评价"]];
    rowImageNames = @[@[@"nav_me_normal"/*, @"tab_read_normal"*/], @[@"center_setting", @"tab_home_normal", @"tab_movie_normal"]];
}

- (void)setupViews {
    _headerView = [[MLBUserHomeHeaderView alloc] initWithUserType:MLBUserTypeMe];
    [_headerView configureHeaderViewForTestMe];
    
    
    
    
    //设置太阳表头背景
    _headerImageViewSun = [[UIImageView alloc] initWithImage:[UIImage mlb_imageWithName:@"middle_full" cached:NO]];
    _headerImageViewSun.frame = CGRectMake(0, 0, SCREEN_WIDTH, 256);
    _headerImageViewSun.contentMode = UIViewContentModeScaleAspectFill;
    _parallaxHeaderViewSun = [ParallaxHeaderView parallaxHeaderViewWithSubView:_headerImageViewSun];
    
    [_parallaxHeaderViewSun addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([_headerView viewHeight]));
        make.left.bottom.right.equalTo(_parallaxHeaderViewSun);
    }];
    
    //设置月亮表头背景
    _headerImageViewMoon = [[UIImageView alloc] initWithImage:[UIImage mlb_imageWithName:@"middle_night_full" cached:NO]];
    _headerImageViewMoon.frame = CGRectMake(0, 0, SCREEN_WIDTH, 256);
    _headerImageViewMoon.contentMode = UIViewContentModeScaleAspectFill;
    _parallaxHeaderViewMoon = [ParallaxHeaderView parallaxHeaderViewWithSubView:_headerImageViewMoon];
    
    [_parallaxHeaderViewMoon addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([_headerView viewHeight]));
        make.left.bottom.right.equalTo(_parallaxHeaderViewMoon);
    }];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = MLBViewControllerBGColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[MLBUserHomeCell class] forCellReuseIdentifier:kUserHomeCellID];
        [tableView registerClass:[MLBSettingsSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kSettingsSectionHeaderViewID];
        tableView.rowHeight = [MLBUserHomeCell cellHeight];
        
        
        tableView.tableHeaderView = _parallaxHeaderViewMoon;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tableView;
    });
}

#pragma mark - Public Method



#pragma mark - Action



#pragma mark - Network Request



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [(ParallaxHeaderView *)_tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = rowTitles[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLBUserHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserHomeCellID forIndexPath:indexPath];
    [cell configureCellWithTitle:rowTitles[indexPath.section][indexPath.row] imageName:rowImageNames[indexPath.section][indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [MLBSettingsSectionHeaderView viewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MLBSettingsSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSettingsSectionHeaderViewID];
    view.titleLabel.text = sectionTitles[section];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *nav = nil;
    if (indexPath.section == 0 && indexPath.row == 0)
    {/*
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *imgFilePath = [paths[0] stringByAppendingPathComponent:@"upload.jpg"];
        
        //这里好像应该写渲染后的图片
        //NSData *imgData = UIImageJPEGRepresentation(_paintView.image, 0.9);
        NSData *imgData = UIImageJPEGRepresentation(_paintView.renderedImage, 0.9);
        
        [imgData writeToFile:imgFilePath atomically:YES];
        
        static __strong UIDocumentInteractionController *documentInteractionController = nil;
        documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imgFilePath]];
        //documentInteractionController.annotation = [NSDictionary dictionaryWithObject:@"Created with the Impression iOS app!" forKey:@"InstagramCaption"];
        BOOL response = [documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        
        if (!response) [self showModalMessage:@"没有安装其他支持的应用。"];
        */
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        nav = [[UINavigationController alloc] initWithRootViewController:[[MLBIAPViewController alloc] init]];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        nav = [[UINavigationController alloc] initWithRootViewController:[[MLBHelpViewController alloc] init]];
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        nav = [[UINavigationController alloc] initWithRootViewController:[[MLBContentViewController alloc] init]];
    }
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
        nav = [[UINavigationController alloc] initWithRootViewController:[[MLBSettingsViewController alloc] init]];
    }
    [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:nav animated:YES completion:NULL];
    //[self.navigationController pushViewController:nav animated:YES];
}

- (void)updateTitleAndIcon:(NSString*)title iconName:(NSString*)icon{
    [_headerView setTitleAndIcon:title iconName:icon];
    if (![title isEqualToString:@"VPN已连接"])
    {
        [_parallaxHeaderViewMoon addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([_headerView viewHeight]));
            make.left.bottom.right.equalTo(_parallaxHeaderViewMoon);
        }];
        _tableView.tableHeaderView = _parallaxHeaderViewMoon;
    }
    else
    {
        [_parallaxHeaderViewSun addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([_headerView viewHeight]));
            make.left.bottom.right.equalTo(_parallaxHeaderViewSun);
        }];
        _tableView.tableHeaderView = _parallaxHeaderViewSun;
    }
}

@end
