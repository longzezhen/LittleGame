//
//  RankViewController.m
//  XYXJump
//
//  Created by df on 2019/12/24.
//  Copyright © 2019 cons. All rights reserved.
//

#import "RankViewController.h"
#import "Masonry.h"
#import "RankTableViewCell.h"
#import <GameKit/GameKit.h>
@interface RankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * scoreLabel;
@property (nonatomic,strong)UILabel * rankLabel;
@property (nonatomic,strong)UILabel * numberLabel;
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * rankList;
@end

@implementation RankViewController
-(void)dealloc
{
    NSLog(@"dealloc");
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self authPlayer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self saveHighScore];
    [self downLoadGameCenter];
}

#pragma mark - private
//验证授权
-(void)authPlayer{
    GKLocalPlayer * play = [GKLocalPlayer localPlayer];
    play.authenticateHandler = ^(UIViewController * _Nullable viewController, NSError * _Nullable error) {
        if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
            [self saveHighScore];
            [self downLoadGameCenter];
            NSLog(@"已经授权");
        }else if (viewController){
            [self presentViewController:viewController animated:YES completion:nil];
        }else{
            if (!error) {
                NSLog(@"授权OK");
            }else{
                [MBProgressHUD showText:Klang(@"Sign in to Game Center for the full list") toView:self.view];
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

-(void)downLoadGameCenter
{
    if ([GKLocalPlayer localPlayer].isAuthenticated == NO) {
        NSLog(@"没有授权，无法获取更多信息");
        return;
    }
    GKLeaderboard * leaderboardRequest = [GKLeaderboard new];
    //设置好友的范围
    leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
    NSString * timeType = @"all";
    if ([timeType isEqualToString:@"all"]) {
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
    }else if ([timeType isEqualToString:@"week"]){
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeWeek;
    }else if ([timeType isEqualToString:@"today"]){
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeToday;
    }
    
    NSString * rankID = @"edwardRankID";
    leaderboardRequest.identifier = rankID;
    //从哪个排名到哪个排名
    NSInteger location = 1;
    NSInteger length = 100;
    leaderboardRequest.range = NSMakeRange(location, length);
    //请求数据
    [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray<GKScore *> * _Nullable scores, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求分数失败");
        }else{
            NSLog(@"请求分数成功");
            self.nameLabel.text = leaderboardRequest.localPlayerScore.player.displayName;
            self.scoreLabel.text = [NSString stringWithFormat:@"%@%lld",Klang(@"Score:"),leaderboardRequest.localPlayerScore.value];
            self.rankLabel.text = [NSString stringWithFormat:@"%ld",leaderboardRequest.localPlayerScore.rank];
            self.numberLabel.text = [NSString stringWithFormat:@"%ld",self.rankList.count];
            self.rankList = scores;
            [self.tableView reloadData];
        }
    }];
}

//Private method 弹框
-(void)popShowViewWithTitileName:(NSString *)tittleName andInfo:(NSString*)info{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tittleName message:info preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}


-(void)initView
{
    self.view.backgroundColor = ColorRBG(0xa94ab6);
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:ImageName(@"back") forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10+KTopHeight);
        make.left.mas_equalTo(0);
    }];
    
    UILabel * topTipLabel = [UILabel new];
    topTipLabel.backgroundColor = ColorRBG(0x783e82);
    topTipLabel.textAlignment = NSTextAlignmentCenter;
    topTipLabel.layer.cornerRadius = 39/2.0;
    topTipLabel.layer.masksToBounds = YES;
    topTipLabel.text = Klang(@"Score Leader board");
    topTipLabel.textColor = ColorRBG(0xffffff);
    topTipLabel.font = KFont(17);
    [self.view addSubview:topTipLabel];
    [topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftButton);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(352/2,39));
    }];
    
    UIView * lineView1 = [UIView new];
    lineView1.backgroundColor = ColorRBG(0x9a3ea7);
    [self.view addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(topTipLabel.mas_bottom).mas_equalTo(9);
        make.height.mas_equalTo(3);
    }];
    
    UIView * infoView = [UIView new];
    infoView.backgroundColor = ColorRBG(0x641E69);
    infoView.layer.cornerRadius = 65/2.0;
    infoView.layer.masksToBounds = YES;
    [self.view addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView1.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(65);
    }];
    
    UIImageView * iconImageView = [[UIImageView alloc] initWithImage:ImageName(@"userScore_icon")];
    [infoView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(6);
    }];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.text = @"--";
    self.nameLabel.textColor = ColorRBG(0xffffff);
    self.nameLabel.font = [UIFont boldSystemFontOfSize:17];
    [infoView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(infoView.mas_centerY).mas_equalTo(-4);
        make.left.mas_equalTo(iconImageView.mas_right).mas_equalTo(10);
    }];
    
    self.scoreLabel = [UILabel new];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@%@",Klang(@"Score:"),@"0"];
    self.scoreLabel.textColor = ColorRBG(0xe2d6e4);
    self.scoreLabel.font = KFont(15);
    [infoView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoView.mas_centerY).mas_equalTo(4);
        make.left.mas_equalTo(iconImageView.mas_right).mas_equalTo(10);
    }];
    
    self.rankLabel = [UILabel new];
    self.rankLabel.textAlignment = NSTextAlignmentCenter;
    self.rankLabel.backgroundColor = ColorRBG(0xb646c7);
    self.rankLabel.text = @"--";
    self.rankLabel.textColor = ColorRBG(0xffffff);
    self.rankLabel.font = [UIFont boldSystemFontOfSize:16];
    self.rankLabel.textAlignment = NSTextAlignmentCenter;
    self.rankLabel.layer.cornerRadius = 20;
    self.rankLabel.layer.masksToBounds = YES;
    [infoView addSubview:self.rankLabel];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-6);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    UIView * lineView2 = [UIView new];
    lineView2.backgroundColor = ColorRBG(0x9a3ea7);
    [self.view addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(infoView.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(3);
    }];
    
    UIImageView * lastImageView;
    for (int i = 0; i<7; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:ImageName(@"star_num")];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView2.mas_bottom).mas_equalTo(8);
            make.left.mas_equalTo(27+(15/2.0+7)*i);
            make.size.mas_equalTo(CGSizeMake(15/2.0, 15/2.0));
        }];
        lastImageView = imageView;
    }
    
    UILabel * numberTipLabel = [UILabel new];
    numberTipLabel.text = Klang(@"Number of players");
    numberTipLabel.textColor = ColorRBG(0xed93f7);
    numberTipLabel.font = KFont(11);
    [self.view addSubview:numberTipLabel];
    [numberTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27);
        make.top.mas_equalTo(lineView2.mas_bottom).mas_equalTo(18);
    }];
    
    self.numberLabel = [UILabel new];
    self.numberLabel.text = @"0";
    self.numberLabel.textColor = ColorRBG(0xed93f7);
    self.numberLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lastImageView.mas_right).mas_equalTo(10);
        make.bottom.mas_equalTo(numberTipLabel);
    }];
    
    UIView * lineView3 = [UIView new];
    lineView3.backgroundColor = ColorRBG(0x9a3ea7);
    [self.view addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(numberTipLabel.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];
    
    self.tableView = [UITableView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[RankTableViewCell class] forCellReuseIdentifier:@"RANKCELL"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView3.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

-(void)clickLeftButton
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RANKCELL"];
    cell.score = self.rankList[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

@end
