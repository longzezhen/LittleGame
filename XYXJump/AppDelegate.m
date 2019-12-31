//
//  AppDelegate.m
//  XYXJump
//
//  Created by df on 2019/11/1.
//  Copyright © 2019 cons. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <GameKit/GameKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController * vc = [ViewController new];
    [self.window setRootViewController:vc];
    self.window.backgroundColor = ColorRBG(0xFFFFFF);
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self saveHighScore];
}

// 上传分数给 gameCenter
-(void)saveHighScore{
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        //得到分数的报告
        GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:@"edwardRankID"];
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
        NSString * string = [userDefaults objectForKey:@"gameScore"];
        scoreReporter.value = [string integerValue];
        NSArray<GKScore*> *scoreArray = @[scoreReporter];
        //上传分数
        if ([string integerValue] != 0) {
            [GKScore reportScores:scoreArray withCompletionHandler:^(NSError * _Nullable error) {
                [userDefaults removeObjectForKey:@"gameScore"];
            }];
        }
    }
}

#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}


//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([url.scheme isEqualToString:@"JumpWidget"]) {
        return YES;
    }
    return NO;
}
@end
