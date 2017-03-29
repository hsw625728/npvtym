//
//  MLBUserHomeHeaderView.m
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBUserHomeHeaderView.h"
#import "MoVPNManage.h"
#import <NetworkExtension/NEVPNManager.h>
#import <NetworkExtension/NEVPNConnection.h>

@interface MLBUserHomeHeaderView ()

@property (strong, nonatomic) MLBTapImageView *userAvatarView;
@property (strong, nonatomic) UILabel *nicknameLabel;
@property (strong, nonatomic) UILabel *oneCoinCountLabel;

@property (nonatomic, assign) MLBUserType userType;

@end

@implementation MLBUserHomeHeaderView

#pragma mark - LifeCycle

- (instancetype)initWithUserType:(MLBUserType)userType {
    self = [super init];
    
    if (self) {
        _userType = userType;
        [self setupViews];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)setupViews {
    if (_userType == MLBUserTypeMe) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 206);
    } else if (_userType == MLBUserTypeOthers) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 386);
    }
    
    _userAvatarView = ({
        MLBTapImageView *imageView = [MLBTapImageView new];
        imageView.layer.cornerRadius = 30;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:singleTap];
        
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@60);
            make.top.equalTo(self).offset(64);
            make.centerX.equalTo(self);
        }];
        
        imageView;
    });
    
    _nicknameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = FontWithSize(15);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userAvatarView.mas_bottom).offset(8);
            make.left.right.equalTo(self);
        }];
        
        label;
    });
    
    _oneCoinCountLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = FontWithSize(11);
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nicknameLabel.mas_bottom).offset(8);
            make.left.equalTo(_nicknameLabel.mas_centerX);
            make.right.lessThanOrEqualTo(self).offset(-8);
            make.bottom.lessThanOrEqualTo(self).offset(-30);
        }];
        
        label;
    });
    
    MoVPNManage * vpnManage = [MoVPNManage shareVPNManage];
    [vpnManage setVpnTitle:@"梦游兔VPN"];
    [vpnManage setServer:@"47.89.38.166" ID:@"myUserName" pwd:@"myUserPass" privateKey:@"myPSKkey"];
    [vpnManage setReconnect:NO];
    [vpnManage saveConfigCompleteHandle:^(BOOL success, NSString *returnInfo) {
        NSLog(@"%@",returnInfo);
        if (success) {
            [vpnManage loadFromPreferences:nil];
            [vpnManage vpnStart];
        }
    }];
    
}

#pragma mark - Public Method

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    switch (appDelegate.gStatue) {
        case VPN_DISCONNECTED:
            [[MoVPNManage shareVPNManage] vpnStart];
            _nicknameLabel.text = @"点击断开";
            break;
        case VPN_CONNECTING:
            [[MoVPNManage shareVPNManage] vpnStart];
            _nicknameLabel.text = @"正在连接中...";
            break;
        case VPN_CONNECTED:
            [[MoVPNManage shareVPNManage] vpnStop];
            _nicknameLabel.text = @"点击连接";
            break;
        default:
            break;
    }
    //[[MoVPNManage shareVPNManage] vpnStart];
    
    //[[MoVPNManage shareVPNManage] vpnStop];
    //_nicknameLabel.text = @"连接成功";
    //do something....
}

- (void)updateUI{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NEVPNManager * p = NEVPNManager.sharedManager;
    switch (p.connection.status) {
        case NEVPNStatusInvalid:
            NSLog(@"NEVPNStatusInvalid The VPN is not configured.");
            appDelegate.gStatue = VPN_DISCONNECTED;
            break;
        case NEVPNStatusDisconnected:
            NSLog(@"NEVPNStatusDisconnected The VPN is disconnected.");
            appDelegate.gStatue = VPN_DISCONNECTED;
            break;
        case NEVPNStatusConnecting:
            NSLog(@"NEVPNStatusConnecting The VPN is connecting.");
            appDelegate.gStatue = VPN_CONNECTING;
            break;
        case NEVPNStatusConnected:
            NSLog(@"NEVPNStatusConnected The VPN is connected.");
            appDelegate.gStatue = VPN_CONNECTED;
            break;
        case NEVPNStatusReasserting:
            NSLog(@"NEVPNStatusReasserting The VPN is reconnecting following loss of underlying network connectivity.");
            appDelegate.gStatue = VPN_DISCONNECTED;
            break;
        case NEVPNStatusDisconnecting:
            NSLog(@"NEVPNStatusDisconnecting The VPN is disconnecting.");
            appDelegate.gStatue = VPN_DISCONNECTED;
            break;
        default:
            break;
    }
}

- (CGFloat)viewHeight {
    return CGRectGetHeight(self.frame);
}

- (void)configureHeaderViewForTestMe {
    _userAvatarView.image = [UIImage imageNamed:@"personal"];
    _nicknameLabel.text = @"点击连接";
    _oneCoinCountLabel.text = @"这个是什么？";
}

@end