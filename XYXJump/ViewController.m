//
//  ViewController.m
//  XYXJump
//
//  Created by df on 2019/11/1.
//  Copyright © 2019 cons. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "MallViewController.h"
#import "RankViewController.h"
#import <GameKit/GameKit.h>
@interface ViewController ()<GKGameCenterControllerDelegate>

@property (nonatomic,strong)UIView * helpView;
@property (nonatomic,strong)UIView * scoreView;
@property (nonatomic,strong)UILabel * scoreLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
    [userDefaults objectForKey:@"maxscore"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self saveHighScore];
}

//验证授权
-(void)authPlayer{
    GKLocalPlayer * play = [GKLocalPlayer localPlayer];
    play.authenticateHandler = ^(UIViewController * _Nullable viewController, NSError * _Nullable error) {
        if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
            NSLog(@"已经授权");
        }else if (viewController){
            [self presentViewController:viewController animated:YES completion:nil];
        }else{
            if (!error) {
                NSLog(@"授权OK");
            }else{
                NSLog(@"没有授权");
            }
        }
    };
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

-(void)initView
{
    UIImageView * backImageView = [[UIImageView alloc] initWithImage:ImageName(@"backgroundView")];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIImageView * zhantaiImageView = [[UIImageView alloc] initWithImage:ImageName(Klang(@"zhantai"))];
    [self.view addSubview:zhantaiImageView];
    [zhantaiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo([UIScreen mainScreen].bounds.size.height >= 812?363/2.0+24:363/2.0);
    }];
    
    UIButton * helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpButton setImage:ImageName(Klang(@"help")) forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(clickHelpButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helpButton];
    [helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(zhantaiImageView.mas_bottom).mas_equalTo(22);
    }];
    
    UIButton * mallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mallButton setImage:ImageName(Klang(@"mall")) forState:UIControlStateNormal];
    [mallButton addTarget:self action:@selector(clickMallButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mallButton];
    [mallButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(helpButton.mas_bottom).mas_equalTo(22);
    }];
    
    UIButton * scoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scoreButton setImage:ImageName(Klang(@"rankButton")) forState:UIControlStateNormal];
    [scoreButton addTarget:self action:@selector(clickScoreButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scoreButton];
    [scoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(mallButton.mas_bottom).mas_equalTo(22);
    }];
}


-(void)clickHelpButton
{
    self.helpView.hidden = NO;
}

-(void)closeHelpView
{
    self.helpView.hidden = YES;
}

- (void)clickMallButton{
    MallViewController *mallVC = [[MallViewController alloc] init];
    mallVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:mallVC animated:NO completion:nil];;
}

- (void)clickScoreButton{
    [self jumpToCustomRank];
}

//跳转系统排行榜
-(void)jumpToSystemRank
{
    [self authPlayer];
    if ([GKLocalPlayer localPlayer].isAuthenticated == NO) {
        NSLog(@"没有授权，无法获取展示中心");
        return;
    }
    UIViewController *vc = [self.view.window rootViewController];
    GKGameCenterViewController *GCVC = [GKGameCenterViewController new];
    //跳转指定的排行榜中
    [GCVC setLeaderboardIdentifier:@"edwardRankID"];
    //跳转到那个时间段
    NSString *type = @"all";
    if ([type isEqualToString:@"today"]) {
        [GCVC setLeaderboardTimeScope:GKLeaderboardTimeScopeToday];
    }else if([type isEqualToString:@"week"]){
        [GCVC setLeaderboardTimeScope:GKLeaderboardTimeScopeWeek];
    }else if ([type isEqualToString:@"all"]){
        [GCVC setLeaderboardTimeScope:GKLeaderboardTimeScopeAllTime];
    }
    GCVC.gameCenterDelegate = self;
    [vc presentViewController:GCVC animated:YES completion:nil];
}

//跳转自定义排行榜
-(void)jumpToCustomRank
{
    [self saveHighScore];
    RankViewController * rankVC = [RankViewController new];
    rankVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:rankVC animated:NO completion:nil];
}

//实现代理：
#pragma mark -  GKGameCenterControllerDelegate
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)closeScoreView{
    self.scoreView.hidden = YES;
}


-(UIView *)helpView
{
    if (!_helpView) {
        _helpView = [UIView new];
        _helpView.backgroundColor = ColorRGBA(0x000000, 0.5);
        [self.view addSubview:_helpView];
        [_helpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:ImageName(Klang(@"detail_help"))];
        [_helpView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        
        UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:ImageName(@"closeButton") forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeHelpView) forControlEvents:UIControlEventTouchUpInside];
        [_helpView addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView.mas_right);
            make.centerY.mas_equalTo(imageView.mas_top);
        }];
    }
    return _helpView;
}

-(UIView *)scoreView
{
    if (!_scoreView) {
        _scoreView = [UIView new];
        _scoreView.backgroundColor = ColorRGBA(0x000000, 0.5);
        [self.view addSubview:_scoreView];
        [_scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:ImageName(@"highScore")];
        [_scoreView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        
        UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:ImageName(@"closeButton") forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeScoreView) forControlEvents:UIControlEventTouchUpInside];
        [_scoreView addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView.mas_right);
            make.centerY.mas_equalTo(imageView.mas_top);
        }];

        self.scoreLabel = [[UILabel alloc] init];
        self.scoreLabel.font = [UIFont boldSystemFontOfSize:30];
        self.scoreLabel.textColor = ColorRBG(0xffffff);
        [imageView addSubview:self.scoreLabel];
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(151);
        }];
    }
    return _scoreView;
}
@end
