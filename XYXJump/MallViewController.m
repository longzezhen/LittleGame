//
//  MallViewController.m
//  XYXJump
//
//  Created by kim on 2019/12/5.
//  Copyright © 2019 cons. All rights reserved.
//

#import "MallViewController.h"
#import "Masonry.h"
#import "JumpPayManager.h"
#import "ProgressDialog.h"

#define W_VIEW   [UIScreen mainScreen].bounds.size.width
#define H_VIEW   [UIScreen mainScreen].bounds.size.height

@interface MallViewController ()


@property (nonatomic, strong) UILabel *lab_jb;

@property (nonatomic, strong) UIImageView *imgv_head;
@property (nonatomic, strong) UIButton *btn_pf1;
@property (nonatomic, strong) UIImageView *imgv1_sel;
@property (nonatomic, strong) UIButton *btn_pf2;
@property (nonatomic, strong) UIButton *btn_jg2;
@property (nonatomic, strong) UIImageView *imgv2_sel;
@property (nonatomic, strong) UIImageView *imgv_lock2;

@property (nonatomic, strong) UIButton *btn_pf3;
@property (nonatomic, strong) UIButton *btn_jg3;
@property (nonatomic, strong) UIImageView *imgv3_sel;
@property (nonatomic, strong) UIImageView *imgv_lock3;

@property (nonatomic, strong) UIButton *btn_pf4;
@property (nonatomic, strong) UIButton *btn_jg4;
@property (nonatomic, strong) UIImageView *imgv4_sel;
@property (nonatomic, strong) UIImageView *imgv_lock4;

@end

@implementation MallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)clickBackBtn{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)initView{
    
    self.view.backgroundColor = ColorRBG(0x763e80);
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    scrollView.contentSize = CGSizeMake(W_VIEW, 800);
    
    self.imgv_head = [[UIImageView alloc] init];
    [scrollView addSubview:self.imgv_head];
    [self.imgv_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(W_VIEW);
        make.height.mas_equalTo(W_VIEW*550/750);
    }];
    
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_back setBackgroundImage:ImageName(@"back") forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn_back];
    [btn_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(15);
    }];
    
    UIView *view_right = [[UIView alloc] init];
    view_right.backgroundColor = ColorRBG(0x783e82);
    view_right.layer.cornerRadius = 20;
    view_right.layer.masksToBounds = YES;
    [scrollView addSubview:view_right];
    [view_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(W_VIEW - 100);
        make.centerY.mas_equalTo(btn_back);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    
    UIImageView *imgv_jb = [[UIImageView alloc] init];
    imgv_jb.image = ImageName(@"imgv_jinbi");
    [view_right addSubview:imgv_jb];
    [imgv_jb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-30);
    }];
    
    self.lab_jb = [[UILabel alloc] init];
    self.lab_jb.textColor = ColorRBG(0xffffff);
    self.lab_jb.font = KFont(16);
    self.lab_jb.text = @"0";
    [view_right addSubview:self.lab_jb];
    [self.lab_jb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(imgv_jb.mas_left).mas_equalTo(-5);
    }];
    
    NSString *jinBiNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"JinBiNum"] ? : @"0";
    self.lab_jb.text = jinBiNum;
    
    UIImageView *imgv_jc = [[UIImageView alloc] init];
    imgv_jc.image = ImageName(@"imgv_juchi");
    [self.imgv_head addSubview:imgv_jc];
    [imgv_jc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(W_VIEW, W_VIEW*29/1125));
    }];
    
    UIView *view_sp = [[UIView alloc] init];
    view_sp.backgroundColor = ColorRBG(0x8d4192);
    [scrollView addSubview:view_sp];
    [view_sp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.imgv_head.mas_bottom);
        make.width.mas_equalTo(W_VIEW);
        make.height.mas_equalTo(150);
    }];
    
    UIImageView *imgv1 = [[UIImageView alloc] init];
    imgv1.image = ImageName(@"shanpin1");
    imgv1.userInteractionEnabled = YES;
    [view_sp addSubview:imgv1];
    [imgv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(21);
        make.size.mas_equalTo(CGSizeMake(97, 91));
    }];
    
    UIButton *btn_jiage1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_jiage1 setBackgroundImage:ImageName(@"jine_bg") forState:UIControlStateNormal];
    [btn_jiage1 addTarget:self action:@selector(clickJinEBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn_jiage1.tag = 0;
    [btn_jiage1 setTitle:Klang(@"$ 0.99") forState:UIControlStateNormal];
    [btn_jiage1 setTitleColor:ColorRBG(0xffffff) forState:UIControlStateNormal];
    btn_jiage1.titleLabel.font = KFont(14);
    [view_sp addSubview:btn_jiage1];
    [btn_jiage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imgv1);
        make.bottom.mas_equalTo(imgv1.mas_bottom).mas_equalTo(16);
    }];
    
    UIImageView *imgv2 = [[UIImageView alloc] init];
    imgv2.image = ImageName(@"shanpin2");
    imgv2.userInteractionEnabled = YES;
    [view_sp addSubview:imgv2];
    [imgv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(21);
        make.size.mas_equalTo(CGSizeMake(97, 91));
    }];
    
    UIButton *btn_jiage2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_jiage2 setBackgroundImage:ImageName(@"jine_bg") forState:UIControlStateNormal];
    [btn_jiage2 addTarget:self action:@selector(clickJinEBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn_jiage2.tag = 1;
    [btn_jiage2 setTitle:Klang(@"$ 2.99") forState:UIControlStateNormal];
    [btn_jiage2 setTitleColor:ColorRBG(0xffffff) forState:UIControlStateNormal];
    btn_jiage2.titleLabel.font = KFont(14);
    [view_sp addSubview:btn_jiage2];
    [btn_jiage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imgv2);
        make.bottom.mas_equalTo(imgv2.mas_bottom).mas_equalTo(16);
    }];
    
    UIImageView *imgv3 = [[UIImageView alloc] init];
    imgv3.userInteractionEnabled = YES;
    imgv3.image = ImageName(@"shanpin3");
    [view_sp addSubview:imgv3];
    [imgv3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(21);
        make.size.mas_equalTo(CGSizeMake(97, 91));
    }];
    
    UIButton *btn_jiage3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_jiage3 setBackgroundImage:ImageName(@"jine_bg") forState:UIControlStateNormal];
    [btn_jiage3 addTarget:self action:@selector(clickJinEBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn_jiage3.tag = 2;
    [btn_jiage3 setTitleColor:ColorRBG(0xffffff) forState:UIControlStateNormal];
    btn_jiage3.titleLabel.font = KFont(14);
    [btn_jiage3 setTitle:Klang(@"$ 4.99") forState:UIControlStateNormal];
    [view_sp addSubview:btn_jiage3];
    [btn_jiage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imgv3);
        make.bottom.mas_equalTo(imgv3.mas_bottom).mas_equalTo(16);
    }];
    
    UIView *view_pf = [[UIView alloc] init];
    view_pf.backgroundColor = ColorRBG(0xa541aa);
    [scrollView addSubview:view_pf];
    [view_pf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(view_sp.mas_bottom).mas_equalTo(3);
        make.height.mas_equalTo(350);
        make.width.mas_equalTo(W_VIEW);
    }];
    
    self.btn_pf1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_pf1.backgroundColor = ColorRBG(0x783e82);
    self.btn_pf1.layer.cornerRadius = 34;
    self.btn_pf1.layer.masksToBounds = YES;
    self.btn_pf1.layer.borderWidth = 0.5;
    self.btn_pf2.tag = 0;
    self.btn_pf1.layer.borderColor = ColorRBG(0xffc002).CGColor;
    [self.btn_pf1 addTarget:self action:@selector(piFuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view_pf addSubview:self.btn_pf1];
    [self.btn_pf1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(68);
        make.width.mas_equalTo(W_VIEW - 30);
    }];
    
    self.imgv1_sel = [[UIImageView alloc] init];
    self.imgv1_sel.userInteractionEnabled = YES;
    self.imgv1_sel.image = ImageName(@"pifu_seleced");
    [self.btn_pf1 addSubview:self.imgv1_sel];
    [self.imgv1_sel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.centerY.mas_equalTo(0);
    }];
    
    UIImageView *imgv_icon1 = [[UIImageView alloc] init];
    imgv_icon1.userInteractionEnabled = YES;
    imgv_icon1.image = ImageName(@"xiaotou_icon");
    [self.imgv1_sel addSubview:imgv_icon1];
    [imgv_icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    UILabel *lab_name1 = [[UILabel alloc] init];
    lab_name1.textColor = ColorRBG(0xffffff);
    lab_name1.font = KFont(16);
    lab_name1.text = Klang(@"Edward");
    [self.btn_pf1 addSubview:lab_name1];
    [lab_name1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgv1_sel.mas_right).mas_equalTo(13);
        make.centerY.mas_equalTo(0);
    }];
    
    UIButton *btn_free = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_free setBackgroundImage:ImageName(Klang(@"pifu_free")) forState:UIControlStateNormal];
    [self.btn_pf1 addSubview:btn_free];
    [btn_free mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-6);
    }];
    
    self.btn_pf2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_pf2.backgroundColor = ColorRBG(0x783e82);
    self.btn_pf2.layer.cornerRadius = 34;
    self.btn_pf2.layer.masksToBounds = YES;
    self.btn_pf2.layer.borderWidth = 0.5;
    self.btn_pf2.layer.borderColor = ColorRBG(0xffc002).CGColor;
    [self.btn_pf2 addTarget:self action:@selector(piFuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_pf2.tag = 1;
    [view_pf addSubview:self.btn_pf2];
    [self.btn_pf2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(W_VIEW - 30);
        make.top.mas_equalTo(self.btn_pf1.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(68);
    }];
    
    self.imgv2_sel = [[UIImageView alloc] init];
    self.imgv2_sel.userInteractionEnabled = YES;
    self.imgv2_sel.image = ImageName(@"pifu_unseleced");
    [self.btn_pf2 addSubview:self.imgv2_sel];
    [self.imgv2_sel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.centerY.mas_equalTo(0);
    }];
    
    UIImageView *imgv_icon2 = [[UIImageView alloc] init];
    imgv_icon2.userInteractionEnabled = YES;
    imgv_icon2.image = ImageName(@"xiaochou_icon");
    [self.imgv2_sel addSubview:imgv_icon2];
    [imgv_icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    UILabel *lab_name2 = [[UILabel alloc] init];
    lab_name2.textColor = ColorRBG(0xffffff);
    lab_name2.font = KFont(16);
    lab_name2.text = Klang(@"Joker");
    [self.btn_pf2 addSubview:lab_name2];
    [lab_name2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgv2_sel.mas_right).mas_equalTo(13);
        make.centerY.mas_equalTo(0);
    }];
    
    self.btn_jg2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn_jg2 setBackgroundImage:ImageName(@"jiage_bg") forState:UIControlStateNormal];
    
    [self.btn_jg2 setTitleColor:ColorRBG(0xffffff) forState:UIControlStateNormal];
    [self.btn_jg2 addTarget:self action:@selector(duiHuanXiaoChou) forControlEvents:UIControlEventTouchUpInside];
    self.btn_jg2.titleLabel.font = KFont(14);
    [self.btn_pf2 addSubview:self.btn_jg2];
    [self.btn_jg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-6);
        make.centerY.mas_equalTo(0);
    }];
    
    self.imgv_lock2 = [[UIImageView alloc] initWithImage:ImageName(@"pifu_locked")];
    [self.btn_pf2 addSubview:self.imgv_lock2];
    [self.imgv_lock2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.btn_jg2.mas_left).mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
    }];
    NSString *haveXiaoChou = [[NSUserDefaults standardUserDefaults] objectForKey:@"HaveXiaoChou"] ? : @"0";
    if ([haveXiaoChou isEqualToString:@"1"]) {
        [self.btn_jg2 setImage:ImageName(Klang(@"pifu_have")) forState:UIControlStateNormal];
        self.imgv_lock2.hidden = YES;
    }else{
        [self.btn_jg2 setImage:ImageName(@"imgv_jinbi") forState:UIControlStateNormal];
        [self.btn_jg2 setTitle:@" 1000" forState:UIControlStateNormal];
        self.imgv_lock2.hidden = NO;
    }
    
    self.btn_pf3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_pf3.backgroundColor = ColorRBG(0x783e82);
    self.btn_pf3.layer.cornerRadius = 34;
    self.btn_pf3.layer.masksToBounds = YES;
    self.btn_pf3.layer.borderWidth = 0.5;
    self.btn_pf3.tag = 2;
    self.btn_pf3.layer.borderColor = ColorRBG(0xffc002).CGColor;
    [self.btn_pf3 addTarget:self action:@selector(piFuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view_pf addSubview:self.btn_pf3];
    [self.btn_pf3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(W_VIEW - 30);
        make.top.mas_equalTo(self.btn_pf2.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(68);
    }];
    
    self.imgv3_sel = [[UIImageView alloc] init];
    self.imgv3_sel.userInteractionEnabled = YES;
    self.imgv3_sel.image = ImageName(@"pifu_unseleced");
    [self.btn_pf3 addSubview:self.imgv3_sel];
    [self.imgv3_sel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.centerY.mas_equalTo(0);
    }];
    
    UIImageView *imgv_icon3 = [[UIImageView alloc] init];
    imgv_icon3.userInteractionEnabled = YES;
    imgv_icon3.image = ImageName(@"nvwu_icon");
    [self.imgv3_sel addSubview:imgv_icon3];
    [imgv_icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    UILabel *lab_name3 = [[UILabel alloc] init];
    lab_name3.textColor = ColorRBG(0xffffff);
    lab_name3.font = KFont(16);
    lab_name3.text = Klang(@"Corpse Bride");
    [self.btn_pf3 addSubview:lab_name3];
    [lab_name3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgv3_sel.mas_right).mas_equalTo(13);
        make.centerY.mas_equalTo(0);
    }];
    
    self.btn_jg3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn_jg3 setBackgroundImage:ImageName(@"jiage_bg") forState:UIControlStateNormal];
    [self.btn_jg3 setTitleColor:ColorRBG(0xffffff) forState:UIControlStateNormal];
    self.btn_jg3.titleLabel.font = KFont(14);
    [self.btn_jg3 addTarget:self action:@selector(duiHuanNvWu) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_pf3 addSubview:self.btn_jg3];
    [self.btn_jg3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-6);
        make.centerY.mas_equalTo(0);
    }];
    
    self.imgv_lock3 = [[UIImageView alloc] initWithImage:ImageName(@"pifu_locked")];
    [self.btn_pf3 addSubview:self.imgv_lock3];
    [self.imgv_lock3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.btn_jg3.mas_left).mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
    }];
    NSString *haveNvWu = [[NSUserDefaults standardUserDefaults] objectForKey:@"HaveNvWu"] ? : @"0";
    if ([haveNvWu isEqualToString:@"1"]) {
        [self.btn_jg3 setImage:ImageName(Klang(@"pifu_have")) forState:UIControlStateNormal];
        self.imgv_lock3.hidden = YES;
    }else{
        [self.btn_jg3 setImage:ImageName(@"imgv_jinbi") forState:UIControlStateNormal];
        [self.btn_jg3 setTitle:@" 700" forState:UIControlStateNormal];
        self.imgv_lock3.hidden = NO;
    }
    
    
    self.btn_pf4 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_pf4.backgroundColor = ColorRBG(0x783e82);
    self.btn_pf4.layer.cornerRadius = 34;
    self.btn_pf4.layer.masksToBounds = YES;
    self.btn_pf4.layer.borderWidth = 0.5;
    self.btn_pf4.tag = 3;
    self.btn_pf4.layer.borderColor = ColorRBG(0xffc002).CGColor;
    [self.btn_pf4 addTarget:self action:@selector(piFuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view_pf addSubview:self.btn_pf4];
    [self.btn_pf4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(W_VIEW - 30);
        make.top.mas_equalTo(self.btn_pf3.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(68);
    }];
    
    self.imgv4_sel = [[UIImageView alloc] init];
    self.imgv4_sel.userInteractionEnabled = YES;
    self.imgv4_sel.image = ImageName(@"pifu_unseleced");
    [self.btn_pf4 addSubview:self.imgv4_sel];
    [self.imgv4_sel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.centerY.mas_equalTo(0);
    }];
    
    UIImageView *imgv_icon4 = [[UIImageView alloc] init];
    imgv_icon4.userInteractionEnabled = YES;
    imgv_icon4.image = ImageName(@"maozi_icon");
    [self.imgv4_sel addSubview:imgv_icon4];
    [imgv_icon4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    UILabel *lab_name4 = [[UILabel alloc] init];
    lab_name4.textColor = ColorRBG(0xffffff);
    lab_name4.font = KFont(16);
    lab_name4.text = Klang(@"Killer in red");
    [self.btn_pf4 addSubview:lab_name4];
    [lab_name4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgv4_sel.mas_right).mas_equalTo(13);
        make.centerY.mas_equalTo(0);
    }];
    
    self.btn_jg4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn_jg4 setBackgroundImage:ImageName(@"jiage_bg") forState:UIControlStateNormal];
    [self.btn_jg4 setTitleColor:ColorRBG(0xffffff) forState:UIControlStateNormal];
    self.btn_jg4.titleLabel.font = KFont(14);
    [self.btn_jg4 addTarget:self action:@selector(duiHuanMaoZi) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_pf4 addSubview:self.btn_jg4];
    [self.btn_jg4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-6);
        make.centerY.mas_equalTo(0);
    }];
    
    self.imgv_lock4 = [[UIImageView alloc] initWithImage:ImageName(@"pifu_locked")];
    [self.btn_pf4 addSubview:self.imgv_lock4];
    [self.imgv_lock4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.btn_jg4.mas_left).mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
    }];
    NSString *haveMaoZi = [[NSUserDefaults standardUserDefaults] objectForKey:@"HaveMaoZi"] ? : @"0";
    if ([haveMaoZi isEqualToString:@"1"]) {
        [self.btn_jg4 setImage:ImageName(Klang(@"pifu_have")) forState:UIControlStateNormal];
        self.imgv_lock4.hidden = YES;
    }else{
        [self.btn_jg4 setImage:ImageName(@"imgv_jinbi") forState:UIControlStateNormal];
        [self.btn_jg4 setTitle:@" 700" forState:UIControlStateNormal];
        self.imgv_lock4.hidden = NO;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
    NSString *str_piFuType = [userDefaults objectForKey:@"PiFuType"] ? : @"1";
    if ([str_piFuType isEqualToString:@"1"]) {
        self.imgv_head.image = ImageName(@"xiaotou_head_bg");
        btn.tag = 0;
    }else if ([str_piFuType isEqualToString:@"2"]){
        self.imgv_head.image = ImageName(@"xiaochou_head_bg");
        btn.tag = 1;
    }else if ([str_piFuType isEqualToString:@"3"]){
        self.imgv_head.image = ImageName(@"nvwu_head_bg");
        btn.tag = 2;
    }else{
        self.imgv_head.image = ImageName(@"maozi_head_bg");
        btn.tag = 3;
    }
    [self piFuBtnClicked:btn];
}

- (void)duiHuanXiaoChou{
    NSString *haveXiaoChou = [[NSUserDefaults standardUserDefaults] objectForKey:@"HaveXiaoChou"] ? : @"0";
    if ([haveXiaoChou isEqualToString:@"1"]) {
        return;
    }
    NSString *jinBiNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"JinBiNum"] ? : @"0";
    if ([jinBiNum integerValue] < 1000) {
        [MBProgressHUD showText:Klang(@"You dont have enough coins") toView:self.view];
    }else{
        NSInteger newNum = [jinBiNum integerValue] - 1000;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", newNum] forKey:@"JinBiNum"];
        self.imgv_lock2.hidden = YES;
        [self.btn_jg2 setImage:ImageName(Klang(@"pifu_have")) forState:UIControlStateNormal];
        [self.btn_jg2 setTitle:@"" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"HaveXiaoChou"];
        self.lab_jb.text = [NSString stringWithFormat:@"%ld", newNum];
    }
}

- (void)duiHuanNvWu{
    NSString *havenvWu = [[NSUserDefaults standardUserDefaults] objectForKey:@"HaveNvWu"] ? : @"0";
    if ([havenvWu isEqualToString:@"1"]) {
        return;
    }
    NSString *jinBiNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"JinBiNum"] ? : @"0";
    if ([jinBiNum integerValue] < 700) {
        [MBProgressHUD showText:Klang(@"You dont have enough coins") toView:self.view];
    }else{
        NSInteger newNum = [jinBiNum integerValue] - 700;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", newNum] forKey:@"JinBiNum"];
        self.imgv_lock3.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"HaveNvWu"];
        [self.btn_jg3 setImage:ImageName(Klang(@"pifu_have")) forState:UIControlStateNormal];
        [self.btn_jg3 setTitle:@"" forState:UIControlStateNormal];
        self.lab_jb.text = [NSString stringWithFormat:@"%ld", newNum];
    }
}

- (void)duiHuanMaoZi{
    NSString *haveMaoZi = [[NSUserDefaults standardUserDefaults] objectForKey:@"HaveMaoZi"] ? : @"0";
    if ([haveMaoZi isEqualToString:@"1"]) {
        return;
    }
    NSString *jinBiNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"JinBiNum"] ? : @"0";
    if ([jinBiNum integerValue] < 700) {
        [MBProgressHUD showText:Klang(@"You dont have enough coins") toView:self.view];
    }else{
        NSInteger newNum = [jinBiNum integerValue] - 700;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", newNum] forKey:@"JinBiNum"];
        self.imgv_lock4.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"HaveMaoZi"];
        [self.btn_jg4 setImage:ImageName(Klang(@"pifu_have")) forState:UIControlStateNormal];
        [self.btn_jg4 setTitle:@"" forState:UIControlStateNormal];
        self.lab_jb.text = [NSString stringWithFormat:@"%ld", newNum];
    }
}

- (void)clickJinEBtn:(UIButton *)sender{
    NSString *productId = @"com.edward.game_6_v2";
    if (sender.tag == 1) {
        productId = @"com.edward.game_18_v2";
    }else if (sender.tag == 2){
        productId = @"com.edward.game_30_v2";
    }
    __weak typeof(self) weakSelf = self;
    [ProgressDialog addProgressDialog];
    [[JumpPayManager sharedPayManager] requestAppleStoreProductWithProductId:productId applePayCompleteBlock:^(NSString * _Nonnull product_id, BOOL isSuccess) {
        [ProgressDialog removeProgressDialog];
        if (isSuccess) {
          
           NSString *jinBiNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"JinBiNum"] ? : @"0";
           switch (sender.tag) {
               case 0:{
                   NSInteger newNum = [jinBiNum integerValue] + 500;
                   [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", newNum] forKey:@"JinBiNum"];
               }
                   break;
               case 1:{
                   NSInteger newNum = [jinBiNum integerValue] + 1500;
                   [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", newNum] forKey:@"JinBiNum"];
               }
                   break;
               case 2:{
                   NSInteger newNum = [jinBiNum integerValue] + 3000;
                   [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", newNum] forKey:@"JinBiNum"];
               }
                   break;
                   
               default:
                   break;
           }
           NSString *newJinBiNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"JinBiNum"] ? : @"0";
           weakSelf.lab_jb.text = newJinBiNum;
        }else{
            [MBProgressHUD showText:Klang(@"Payment failed！") toView:weakSelf.view];
        }
    }];
}

- (void)piFuBtnClicked:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            self.imgv_head.image = ImageName(@"xiaotou_head_bg");
            self.btn_pf1.layer.borderColor = ColorRBG(0xffc002).CGColor;
            self.btn_pf2.layer.borderColor = ColorRBG(0x783e82).CGColor;
            self.btn_pf3.layer.borderColor = ColorRBG(0x783e82).CGColor;
            self.btn_pf4.layer.borderColor = ColorRBG(0x783e82).CGColor;
            self.imgv1_sel.image = ImageName(@"pifu_seleced");
            self.imgv2_sel.image = ImageName(@"pifu_unseleced");
            self.imgv3_sel.image = ImageName(@"pifu_unseleced");
            self.imgv4_sel.image = ImageName(@"pifu_unseleced");
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
            [userDefaults setObject:@"1" forKey:@"PiFuType"];
        }
            break;
        case 1:{
            self.imgv_head.image = ImageName(@"xiaochou_head_bg");
            self.btn_pf1.layer.borderColor = ColorRBG(0x783e82).CGColor;
            self.btn_pf2.layer.borderColor = ColorRBG(0xffc002).CGColor;
            self.btn_pf3.layer.borderColor = ColorRBG(0x783e82).CGColor;
            self.btn_pf4.layer.borderColor = ColorRBG(0x783e82).CGColor;
            self.imgv1_sel.image = ImageName(@"pifu_unseleced");
            self.imgv2_sel.image = ImageName(@"pifu_seleced");
            self.imgv3_sel.image = ImageName(@"pifu_unseleced");
            self.imgv4_sel.image = ImageName(@"pifu_unseleced");
            NSString *haveXiaoChou = [[NSUserDefaults standardUserDefaults] objectForKey:@"HaveXiaoChou"] ? : @"0";
            if ([haveXiaoChou isEqualToString:@"1"]) {
                NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
                [userDefaults setObject:@"2" forKey:@"PiFuType"];
            }
        }
            break;
        case 2:{
            self.imgv_head.image = ImageName(@"nvwu_head_bg");
            self.btn_pf1.layer.borderColor = ColorRBG(0x783e82).CGColor;
            self.btn_pf2.layer.borderColor = ColorRBG(0x783e82).CGColor;
            self.btn_pf3.layer.borderColor = ColorRBG(0xffc002).CGColor;
            self.btn_pf4.layer.borderColor = ColorRBG(0x783e82).CGColor;
            self.imgv1_sel.image = ImageName(@"pifu_unseleced");
            self.imgv2_sel.image = ImageName(@"pifu_unseleced");
            self.imgv3_sel.image = ImageName(@"pifu_seleced");
            self.imgv4_sel.image = ImageName(@"pifu_unseleced");
            NSString *haveNvWu = [[NSUserDefaults standardUserDefaults] objectForKey:@"HaveNvWu"] ? : @"0";
            if ([haveNvWu isEqualToString:@"1"]) {
                NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
                [userDefaults setObject:@"3" forKey:@"PiFuType"];
            }
        }
            break;
        case 3:{
            self.imgv_head.image = ImageName(@"maozi_head_bg");
            self.btn_pf1.layer.borderColor = ColorRBG(0x783e82).CGColor;
            self.btn_pf2.layer.borderColor = ColorRBG(0x783e82).CGColor;
            self.btn_pf3.layer.borderColor = ColorRBG(0x783e82).CGColor;
            self.btn_pf4.layer.borderColor = ColorRBG(0xffc002).CGColor;
            self.imgv1_sel.image = ImageName(@"pifu_unseleced");
            self.imgv2_sel.image = ImageName(@"pifu_unseleced");
            self.imgv3_sel.image = ImageName(@"pifu_unseleced");
            self.imgv4_sel.image = ImageName(@"pifu_seleced");
            NSString *haveMaoZi = [[NSUserDefaults standardUserDefaults] objectForKey:@"HaveMaoZi"] ? : @"0";
            if ([haveMaoZi isEqualToString:@"1"]) {
                NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jumprunrun"];
                [userDefaults setObject:@"4" forKey:@"PiFuType"];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
