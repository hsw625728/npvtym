//
//  AppDelegate.m
//  VpnTest
//
//  Created by Pellet Mo on 15/12/14.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import "AppDelegate.h"
#import "MLBUserHomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    MLBUserHomeViewController *rootView;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _gStatue = VPN_DISCONNECTED;
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    _window.backgroundColor = [UIColor whiteColor];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : MLBNavigationBarTitleTextColor}];
    [[UINavigationBar appearance] setTintColor:MLBLightGrayTextColor];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    NSString *version = [MLBUtilities appCurrentVersion];
    NSString *build = [MLBUtilities appCurrentBuild];
    NSString *versionAndBuild = [NSString stringWithFormat:@"%@_%@", version, build];
    //if (![[UserDefaults objectForKey:MLBLastShowIntroduceVersionAndBuild] isEqualToString:versionAndBuild]) {
    //    _window.rootViewController = [[MLBIntroduceViewController alloc] init];
    //} else {
    rootView = [[MLBUserHomeViewController alloc] init];
    _window.rootViewController = rootView;
    //}
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)updateStatue:(VPNSTATUE)s{
    _gStatue = s;
    switch (_gStatue) {
        case VPN_DISCONNECTED:
            [rootView updateTitleAndIcon:@"点击连接" iconName:@"personal"];
            break;
        case VPN_CONNECTING:
            [rootView updateTitleAndIcon:@"正在连接..." iconName:@"more_highlighted"];
            break;
        case VPN_CONNECTED:
            [rootView updateTitleAndIcon:@"VPN已连接" iconName:@"more_link"];
            break;
        case VPN_DISCONNECTING:
            [rootView updateTitleAndIcon:@"正在断开..." iconName:@"more_highlighted"];
            break;
            
        default:
            break;
    }
}
@end
