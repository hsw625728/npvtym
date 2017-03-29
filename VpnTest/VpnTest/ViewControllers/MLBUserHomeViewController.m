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
    sectionTitles = @[@"服务时长", @"关于梦游兔"];
    rowTitles = @[@[@"邀请好友", @"时长续费"], @[@"帮助说明", @"联系我们", @"评价"]];
    rowImageNames = @[@[@"nav_me_normal", @"tab_read_normal"], @[@"center_setting", @"tab_home_normal", @"tab_movie_normal"]];
}

- (void)setupViews {
    _headerView = [[MLBUserHomeHeaderView alloc] initWithUserType:MLBUserTypeMe];
    [_headerView configureHeaderViewForTestMe];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = MLBViewControllerBGColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[MLBUserHomeCell class] forCellReuseIdentifier:kUserHomeCellID];
        [tableView registerClass:[MLBSettingsSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kSettingsSectionHeaderViewID];
        tableView.rowHeight = [MLBUserHomeCell cellHeight];
        
        UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage mlb_imageWithName:@"personalBackgroundImage" cached:NO]];
        headerImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 256);
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        ParallaxHeaderView *parallaxHeaderView = [ParallaxHeaderView parallaxHeaderViewWithSubView:headerImageView];
        
        UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movie_shadow"]];
        [parallaxHeaderView addSubview:shadowView];
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.left.bottom.right.equalTo(parallaxHeaderView);
        }];
        
        [parallaxHeaderView addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([_headerView viewHeight]));
            make.left.bottom.right.equalTo(parallaxHeaderView);
        }];
        
        tableView.tableHeaderView = parallaxHeaderView;
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
    {
        nav = [[UINavigationController alloc] initWithRootViewController:[[MLBFriendViewController alloc] init]];
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

@end
