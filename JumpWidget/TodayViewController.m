//
//  TodayViewController.m
//  JumpWidget
//
//  Created by df on 2019/11/1.
//  Copyright © 2019 cons. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "Masonry.h"
#import <AVKit/AVKit.h>
#import <SpriteKit/SpriteKit.h>
#define W_VIEW   self.view.frame.size.width
#define H_VIEW   210
#define K_SPACE  W_VIEW/2.0

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic,strong)UIImageView * shadowView;

@property (nonatomic,strong)UIImageView * backImageView;
@property (nonatomic,strong)UIImageView * otherBackImageView;

@property (nonatomic,strong)UIImageView * scoreBackImageView;
@property (nonatomic,strong)UILabel * scoreLabel;
@property (nonatomic,strong)UIImageView * xiaotouImageView;
@property (nonatomic,strong)UIButton * startButton;

@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong)NSTimer * timer2;
@property (nonatomic,strong)NSTimer * timer3;
@property (nonatomic,strong)NSTimer * scoreTimer;
@property (nonatomic,assign)NSInteger timeCount;

@property (nonatomic,assign)BOOL isJumping;
@property (nonatomic,strong)UIView * gameOverView;
@property (nonatomic,strong)UILabel * bottomLabel;

@property (nonatomic,assign)BOOL isGameOver;
@property (nonatomic,assign)CGRect xiaotouFrame;

@property (nonatomic,strong)AVAudioPlayer * bgAudioPlayer;
@property (nonatomic,strong)AVAudioPlayer * clickAudioPlayer;

@property (nonatomic, assign) NSInteger game_level;//1：一倍速   2：1.5倍速   3：2倍速

@property (nonatomic,strong) UIImageView *kengImgv;
@property (nonatomic,strong) UIImageView *kengImgv2;
@property (nonatomic,strong) UIImageView *kengImgv3;

@end

@implementation TodayViewController
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}

#pragma mark - privtate
-(void)initView
{
    self.timeCount = 0;
    self.backImageView.hidden = NO;
    self.otherBackImageView.hidden = NO;
    self.xiaotouImageView.hidden = NO;
    self.startButton.hidden = NO;
    self.scoreBackImageView.hidden = NO;
    self.gameOverView.hidden = YES;
    self.xiaotouFrame = self.xiaotouImageView.frame;
}

- (void)xiaoTouRun{
    
    NSString *str_pifu = @"";
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
    NSString *piFuType = [userDefaults objectForKey:@"PiFuType"];
    if ([piFuType isEqualToString:@"1"]) {
        str_pifu = @"xiaotou";
    }else if ([piFuType isEqualToString:@"2"]) {
        str_pifu = @"xiaochou";
    }else  if ([piFuType isEqualToString:@"3"]){
        str_pifu = @"nvwu";
    }else{
        str_pifu = @"maozi";
    }
    NSMutableArray<UIImage*> * imageArray = [NSMutableArray array];
    for (int i = 1; i < 8; i++) {
        NSString * imageName = [NSString stringWithFormat:@"%@%d", str_pifu, i];
        [imageArray addObject:ImageName(imageName)];
    }
    self.xiaotouImageView.animationImages = imageArray;
    self.xiaotouImageView.animationRepeatCount = 0;
    self.xiaotouImageView.animationDuration = 0.5;
    [self.xiaotouImageView startAnimating];
}

- (void)addYidongBeijing{
    self.otherBackImageView.frame = CGRectMake(W_VIEW, 0, W_VIEW, H_VIEW);
    self.backImageView.frame = CGRectMake(0, 0, W_VIEW, H_VIEW);
    CABasicAnimation *animation1  = [CABasicAnimation animationWithKeyPath:@"position"];
    animation1.duration = 2;
    animation1.fromValue = [NSValue valueWithCGPoint:CGPointMake(W_VIEW/2.0, H_VIEW/2.0)];
    animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(-W_VIEW/2.0, H_VIEW/2.0)];
    animation1.removedOnCompletion = YES;
    animation1.repeatCount = HUGE_VALF;
    animation1.fillMode = kCAFillModeForwards;
    [self.backImageView.layer addAnimation:animation1 forKey:nil];
   
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation2.duration = 2;
    animation2.fromValue = [NSValue valueWithCGPoint:CGPointMake(W_VIEW*3/2.0, H_VIEW/2.0)];
    animation2.toValue = [NSValue valueWithCGPoint:CGPointMake(W_VIEW/2.0, H_VIEW/2.0)];
    animation2.removedOnCompletion = YES;
    animation2.repeatCount = HUGE_VALF;
    animation2.fillMode = kCAFillModeForwards;
    [self.otherBackImageView.layer addAnimation:animation2 forKey:nil];
}

-(void)addKeng{
    if (self.game_level == 2) {
        if (!self.timer2) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.timer2 = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(addKeng2) userInfo:nil repeats:YES];
            });
        }
    }else if (self.game_level == 3){
        if (!self.timer3) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.timer3 = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(addKeng3) userInfo:nil repeats:YES];
            });
        }
    }
    
    NSString * imageStr = @"";
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
    NSString *piFuType = [userDefaults objectForKey:@"PiFuType"];
    if ([piFuType isEqualToString:@"1"]) {
        imageStr = [NSString stringWithFormat:@"keng%d",arc4random()%5+1];
    }else if ([piFuType isEqualToString:@"2"]) {
        imageStr = [NSString stringWithFormat:@"xiaochou_zhanai%d",arc4random()%5+1];
    }else if ([piFuType isEqualToString:@"3"]){
        imageStr = [NSString stringWithFormat:@"nvwu_zhanai%d",arc4random()%5+1];
    }else{
        imageStr = [NSString stringWithFormat:@"maozi_zhanai%d",arc4random()%5+1];
    }
    UIImage * image = ImageName(imageStr);
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    self.kengImgv = [[UIImageView alloc] initWithImage:image];
    self.kengImgv.frame = CGRectMake(W_VIEW+100, H_VIEW-30-height, width, height);
    [self.view addSubview:self.kengImgv];
    
    
    __block CGFloat kengX = W_VIEW+100;
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        kengX = kengX - 0.01*K_SPACE;
        CGRect kengframe = CGRectMake(kengX, H_VIEW-30-height, width, height);
        if (CGRectIntersectsRect(self.xiaotouFrame,kengframe)){
            [self.bgAudioPlayer stop];
            self.isGameOver = YES;
            [timer invalidate];
            [self.kengImgv2.layer removeAllAnimations];
            [self.kengImgv.layer removeAllAnimations];
            [self.kengImgv3.layer removeAllAnimations];
            [self.backImageView.layer removeAllAnimations];
            [self.otherBackImageView.layer removeAllAnimations];
            [self.timer invalidate];
            self.timer = nil;
            [self.timer2 invalidate];
            self.timer2 = nil;
            [self.timer3 invalidate];
            self.timer3 = nil;
            [self.scoreTimer invalidate];
            self.scoreTimer = nil;
            self.gameOverView.hidden = NO;
            self.bottomLabel.text = [NSString stringWithFormat:@"HI %@",self.scoreLabel.text];
            self.xiaotouImageView.hidden = YES;
            
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
            [userDefaults setObject:self.scoreLabel.text forKey:@"gameScore"];
        }
    }];
    [timer setFireDate:[NSDate distantPast]];
    [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.kengImgv.transform = CGAffineTransformMakeTranslation(-2*W_VIEW, 0);
    } completion:^(BOOL finished) {
        [self.kengImgv removeFromSuperview];
        [timer invalidate];
    }];
}

- (void)addKeng2{
        
    NSString * imageStr = @"";
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
    NSString *piFuType = [userDefaults objectForKey:@"PiFuType"];
    if ([piFuType isEqualToString:@"1"]) {
        imageStr = [NSString stringWithFormat:@"keng%d",arc4random()%4+4];
    }else if ([piFuType isEqualToString:@"2"]) {
        imageStr = [NSString stringWithFormat:@"xiaochou_zhanai%d",arc4random()%4+4];
    }else if ([piFuType isEqualToString:@"3"]){
        imageStr = [NSString stringWithFormat:@"nvwu_zhanai%d",arc4random()%4+4];
    }else{
        imageStr = [NSString stringWithFormat:@"maozi_zhanai%d",arc4random()%4+4];
    }
    UIImage * image = ImageName(imageStr);
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    self.kengImgv2 = [[UIImageView alloc] initWithImage:image];
    self.kengImgv2.frame = CGRectMake(W_VIEW+100, H_VIEW-30-height, width, height);
    [self.view addSubview:self.kengImgv2];
    
    
    __block CGFloat kengX = W_VIEW+100;
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        kengX = kengX - 0.01*K_SPACE;
        CGRect kengframe = CGRectMake(kengX, H_VIEW-30-height, width, height);
        if (CGRectIntersectsRect(self.xiaotouFrame,kengframe)){
            [self.bgAudioPlayer stop];
            self.isGameOver = YES;
            [timer invalidate];
            [self.kengImgv.layer removeAllAnimations];
            [self.kengImgv2.layer removeAllAnimations];
            [self.kengImgv3.layer removeAllAnimations];
            [self.backImageView.layer removeAllAnimations];
            [self.otherBackImageView.layer removeAllAnimations];
            [self.timer invalidate];
            self.timer = nil;
            [self.timer2 invalidate];
            self.timer2 = nil;
            [self.timer3 invalidate];
            self.timer3 = nil;
            [self.scoreTimer invalidate];
            self.scoreTimer = nil;
            self.gameOverView.hidden = NO;
            self.bottomLabel.text = [NSString stringWithFormat:@"HI %@",self.scoreLabel.text];
            self.xiaotouImageView.hidden = YES;
            
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
            [userDefaults setObject:self.scoreLabel.text forKey:@"gameScore"];
        }
    }];
    [timer setFireDate:[NSDate distantPast]];
    [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.kengImgv2.transform = CGAffineTransformMakeTranslation(-2*W_VIEW, 0);
    } completion:^(BOOL finished) {
        [self.kengImgv2 removeFromSuperview];
        [timer invalidate];
    }];
}

- (void)addKeng3{
    
    NSString * imageStr = @"";
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
    NSString *piFuType = [userDefaults objectForKey:@"PiFuType"];
    if ([piFuType isEqualToString:@"1"]) {
        imageStr = [NSString stringWithFormat:@"keng%d",arc4random()%5+3];
    }else if ([piFuType isEqualToString:@"2"]) {
        imageStr = [NSString stringWithFormat:@"xiaochou_zhanai%d",arc4random()%5+3];
    }else if ([piFuType isEqualToString:@"3"]){
        imageStr = [NSString stringWithFormat:@"nvwu_zhanai%d",arc4random()%5+3];
    }else{
        imageStr = [NSString stringWithFormat:@"maozi_zhanai%d",arc4random()%5+3];
    }
    UIImage * image = ImageName(imageStr);
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    self.kengImgv3 = [[UIImageView alloc] initWithImage:image];
    self.kengImgv3.frame = CGRectMake(W_VIEW+100, H_VIEW-30-height, width, height);
    [self.view addSubview:self.kengImgv3];
    
    
    __block CGFloat kengX = W_VIEW+100;
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        kengX = kengX - 0.01*K_SPACE;
        CGRect kengframe = CGRectMake(kengX, H_VIEW-30-height, width, height);
        if (CGRectIntersectsRect(self.xiaotouFrame,kengframe)){
            [self.bgAudioPlayer stop];
            self.isGameOver = YES;
            [timer invalidate];
            [self.kengImgv.layer removeAllAnimations];
            [self.kengImgv2.layer removeAllAnimations];
            [self.kengImgv3.layer removeAllAnimations];
            [self.backImageView.layer removeAllAnimations];
            [self.otherBackImageView.layer removeAllAnimations];
            [self.timer invalidate];
            self.timer = nil;
            [self.timer2 invalidate];
            self.timer2 = nil;
            [self.timer3 invalidate];
            self.timer3 = nil;
            [self.scoreTimer invalidate];
            self.scoreTimer = nil;
            self.gameOverView.hidden = NO;
            self.bottomLabel.text = [NSString stringWithFormat:@"HI %@",self.scoreLabel.text];
            self.xiaotouImageView.hidden = YES;
            
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
            [userDefaults setObject:self.scoreLabel.text forKey:@"gameScore"];
        }
    }];
    [timer setFireDate:[NSDate distantPast]];
    [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.kengImgv3.transform = CGAffineTransformMakeTranslation(-2*W_VIEW, 0);
    } completion:^(BOOL finished) {
        [self.kengImgv3 removeFromSuperview];
        [timer invalidate];
    }];
}

-(void)xiaotouJump
{
    [self.clickAudioPlayer play];
    
    self.isJumping = YES;
    [self.xiaotouImageView stopAnimating];
    __block CGFloat H_XT = self.xiaotouImageView.frame.origin.y;
    CGFloat speed = 130/0.55;
    __block CGFloat time = 0;
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        time += 0.01;
        if (time <= 0.55) {
            H_XT = H_XT - speed*0.01;
        }else{
            H_XT = H_XT + speed*0.01;
        }
        self.xiaotouFrame = CGRectMake(20, H_XT, self.xiaotouImageView.frame.size.width, self.xiaotouImageView.frame.size.height);
    }];
    [timer setFireDate:[NSDate distantPast]];
    
    [UIView animateWithDuration:0.55 animations:^{
        self.xiaotouImageView.transform = CGAffineTransformMakeTranslation(0, -130);
        
    } completion:^(BOOL finished) {
         [UIView animateWithDuration:0.55 animations:^{
                   self.xiaotouImageView.transform = CGAffineTransformMakeTranslation(0, 0);
               } completion:^(BOOL finished) {
                   [timer invalidate];
                   self.isJumping = NO;
                   if (!self.isGameOver) {
                       [self.xiaotouImageView startAnimating];
                   }
               }];
    }];
}

#pragma mark - action
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isGameOver||!self.startButton.hidden) {
        return;
    }
    if (self.isJumping) {
        return;
    }
    [self xiaotouJump];
    
}

-(void)addKengTimer
{
    [self addKeng];
}

-(void)addScoreTimer
{
    self.timeCount ++;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)self.timeCount];
    if (self.timeCount == 50) {
        self.game_level = 2;
        [self.bgAudioPlayer stop];
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"escape_bg_1.5" withExtension:@"caf"];
        self.bgAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.bgAudioPlayer.numberOfLoops = -1;
        [self.bgAudioPlayer play];
    }else if (self.timeCount == 100){
        self.game_level = 3;
        [self.bgAudioPlayer stop];
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"escape_bg_2" withExtension:@"caf"];
        self.bgAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.bgAudioPlayer.numberOfLoops = -1;
        [self.bgAudioPlayer play];
    }
}


-(void)clickStartButton
{
    
    self.game_level = 1;
    [self.clickAudioPlayer play];
    
    //播放背景音乐
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"escape_bg" withExtension:@"caf"];
    self.bgAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.bgAudioPlayer.numberOfLoops = -1;
    [self.bgAudioPlayer play];
    [self.bgAudioPlayer play];
    
    self.startButton.hidden = YES;
    [self xiaoTouRun];
    [self addYidongBeijing];
    [self.timer setFireDate:[NSDate distantPast]];
    [self.scoreTimer setFireDate:[NSDate distantPast]];
}

-(void)clickAgainButton
{
    [self.clickAudioPlayer play];
    
    self.isGameOver = NO;
    self.gameOverView.hidden = YES;
    self.scoreLabel.text = @"0";
    self.timeCount = 0;
    self.xiaotouImageView.hidden = NO;
    [self.xiaotouImageView stopAnimating];
    self.startButton.hidden = NO;
}

- (void)clickMallButton{
    NSString *schemeStr = [NSString stringWithFormat:@"JumpWidget://"];
    [self.extensionContext openURL:[NSURL URLWithString:schemeStr] completionHandler:^(BOOL success) {
        
    }];
}


-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake(W_VIEW, 110);
        self.shadowView.hidden = NO;
        [self.bgAudioPlayer stop];
    }else{
        self.preferredContentSize = CGSizeMake(W_VIEW, 210);
        self.shadowView.hidden = YES;
        if (!self.isGameOver && self.startButton.hidden) {
            [self.bgAudioPlayer play];
        }
    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {

    completionHandler(NCUpdateResultNewData);
}

#pragma mark - get
-(UIImageView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [UIImageView new];
        _shadowView.image = ImageName(Klang(@"no_show"));
        _shadowView.userInteractionEnabled = YES;
        [self.view addSubview:_shadowView];
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _shadowView;
}

-(UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
        NSString *piFuType = [userDefaults objectForKey:@"PiFuType"];
        if ([piFuType isEqualToString:@"1"]) {
            _backImageView.image = ImageName(@"game_background");
        }else if ([piFuType isEqualToString:@"2"]) {
            _backImageView.image = ImageName(@"xiaochou_game_bg");
        }else if ([piFuType isEqualToString:@"3"]){
            _backImageView.image = ImageName(@"nvwu_game_bg");
        }else{
            _backImageView.image = ImageName(@"maozi_game_bg");
        }
        _backImageView.frame = CGRectMake(0, 0, W_VIEW, H_VIEW);
        [self.view addSubview:_backImageView];
    }
    return _backImageView;
}

-(UIImageView *)otherBackImageView
{
    if (!_otherBackImageView) {
        _otherBackImageView = [[UIImageView alloc] init];
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
        NSString *piFuType = [userDefaults objectForKey:@"PiFuType"];
        if ([piFuType isEqualToString:@"1"]) {
            _otherBackImageView.image = ImageName(@"game_background");
        }else if ([piFuType isEqualToString:@"2"]) {
            _otherBackImageView.image = ImageName(@"xiaochou_game_bg");
        }else if ([piFuType isEqualToString:@"3"]){
            _otherBackImageView.image = ImageName(@"nvwu_game_bg");
        }else{
            _otherBackImageView.image = ImageName(@"maozi_game_bg");
        }
        _otherBackImageView.frame = CGRectMake(W_VIEW, 0, W_VIEW, H_VIEW);
        [self.view addSubview:_otherBackImageView];
    }
       return _otherBackImageView;
}

-(UIImageView *)scoreBackImageView
{
    if (!_scoreBackImageView) {
        _scoreBackImageView = [[UIImageView alloc] initWithImage:ImageName(@"gameTop_bg")];
        [self.view addSubview:_scoreBackImageView];
        [_scoreBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(10);
        }];
        
        UIImageView * iconImageView = [[UIImageView alloc] initWithImage:ImageName(@"score_icon")];
        [_scoreBackImageView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(20);
        }];
        
        self.scoreLabel = [UILabel new];
        self.scoreLabel.text = @"0";
        self.scoreLabel.textColor = ColorRBG(0xffffff);
        self.scoreLabel.font = KFont(18);
        [_scoreBackImageView addSubview:self.scoreLabel];
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(_scoreBackImageView.mas_centerX);
        }];
        
    }
    return _scoreBackImageView;
}

-(UIImageView *)xiaotouImageView
{
    if (!_xiaotouImageView) {
        _xiaotouImageView = [[UIImageView alloc] init];
        NSString *str_pifu = @"";
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
        NSString *piFuType = [userDefaults objectForKey:@"PiFuType"];
        if ([piFuType isEqualToString:@"1"]) {
            str_pifu = @"xiaotou1";
        }else if ([piFuType isEqualToString:@"2"]) {
            str_pifu = @"xiaochou1";
        }else if ([piFuType isEqualToString:@"3"]){
            str_pifu = @"nvwu1";
        }else{
            str_pifu = @"maozi1";
        }
        _xiaotouImageView.image = ImageName(str_pifu);
        _xiaotouImageView.frame = CGRectMake(20, H_VIEW-30-64, 28, 64);
        [self.view addSubview:_xiaotouImageView];
    }
    return _xiaotouImageView;
}

-(UIButton *)startButton
{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setImage:ImageName(Klang(@"startGame")) forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(clickStartButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_startButton];
        [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return _startButton;
}

-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(addKengTimer) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(NSTimer *)scoreTimer
{
    if (!_scoreTimer) {
        _scoreTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addScoreTimer) userInfo:nil repeats:YES];
    }
    return _scoreTimer;
}

-(UIView *)gameOverView
{
    if (!_gameOverView) {
        _gameOverView = [UIView new];
        _gameOverView.backgroundColor = ColorRGBA(0x000000, 0.5);
        [self.view addSubview:_gameOverView];
        [_gameOverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UILabel * tipLabel = [UILabel new];
        tipLabel.text = Klang(@"GAME OVER");
        tipLabel.textColor = ColorRBG(0xfdf2fe);
        tipLabel.font = [UIFont boldSystemFontOfSize:29];
        [_gameOverView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(35);
        }];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:ImageName(Klang(@"againButton")) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAgainButton) forControlEvents:UIControlEventTouchUpInside];
        [_gameOverView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_gameOverView.mas_centerX).mas_equalTo(-10);
            make.top.mas_equalTo(tipLabel.mas_bottom).mas_equalTo(11);
        }];
        
        UIButton * mallbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mallbutton setImage:ImageName(Klang(@"mallButton")) forState:UIControlStateNormal];
        [mallbutton addTarget:self action:@selector(clickMallButton) forControlEvents:UIControlEventTouchUpInside];
        [_gameOverView addSubview:mallbutton];
        [mallbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_gameOverView.mas_centerX).mas_equalTo(10);
            make.top.mas_equalTo(tipLabel.mas_bottom).mas_equalTo(11);
        }];
        
        self.bottomLabel = [UILabel new];
        self.bottomLabel.layer.cornerRadius = 5;
        self.bottomLabel.layer.masksToBounds = YES;
        self.bottomLabel.text = @"HI 0";
        self.bottomLabel.textColor = ColorRBG(0xd57bdf);
        self.bottomLabel.font = [UIFont boldSystemFontOfSize:15];
        self.bottomLabel.textAlignment = NSTextAlignmentCenter;
        self.bottomLabel.backgroundColor = ColorRBG(0x95439F);
        [_gameOverView addSubview:self.bottomLabel];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(button.mas_bottom).mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(110, 20));
        }];
    }
    return _gameOverView;
}

- (AVAudioPlayer *)bgAudioPlayer{
    if (!_bgAudioPlayer) {
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"escape_bg" withExtension:@"caf"];
        _bgAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _bgAudioPlayer.numberOfLoops = -1;
    }
    return _bgAudioPlayer;
}

- (AVAudioPlayer *)clickAudioPlayer{
    if (!_clickAudioPlayer) {
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"escape_click" withExtension:@"caf"];
        _clickAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    return _clickAudioPlayer;
}

@end
