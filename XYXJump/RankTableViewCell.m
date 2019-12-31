//
//  RankTableViewCell.m
//  XYXJump
//
//  Created by df on 2019/12/24.
//  Copyright © 2019 cons. All rights reserved.
//

#import "RankTableViewCell.h"
#import "Masonry.h"
@interface RankTableViewCell()
@property (nonatomic,strong)UIView * beijinView;
@property (nonatomic,strong)UIImageView * iconImageView;
@property (nonatomic,strong)UILabel * iconLabel;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * scoreLabel;
@property (nonatomic,strong)UILabel * rankLabel;

@end
@implementation RankTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.beijinView.hidden = NO;
        self.iconImageView.hidden = NO;
        self.iconLabel.hidden = YES;
        self.nameLabel.hidden = NO;
        self.scoreLabel.hidden = NO;
        self.rankLabel.hidden = NO;
    }
    self.selectionStyle = 0;
    self.backgroundColor = [UIColor clearColor];
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIView *)beijinView
{
    if (!_beijinView) {
        _beijinView = [UIView new];
        _beijinView.backgroundColor = ColorRBG(0x813d83);
        _beijinView.layer.cornerRadius = 65/2.0;
        _beijinView.layer.masksToBounds = YES;
        [self.contentView addSubview:_beijinView];
        [_beijinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(65);
        }];
    }
    return _beijinView;
}

-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:ImageName(@"rankcell_icon")];
        [self.beijinView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(6);
            make.size.mas_equalTo(CGSizeMake(119/2.0, 119/2.0));
        }];
    }
    return _iconImageView;
}

-(UILabel *)iconLabel
{
    if (!_iconLabel) {
        _iconLabel = [UILabel new];
        _iconLabel.text = @"K";
        _iconLabel.textColor = ColorRBG(0xed93f7);
        _iconLabel.font = [UIFont boldSystemFontOfSize:24];
        [self.iconImageView addSubview:_iconLabel];
        [_iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return _iconLabel;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.text = @"Trixie Beatrice";
        _nameLabel.textColor = ColorRBG(0xffffff);
        _nameLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.beijinView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.beijinView.mas_centerY).mas_equalTo(-4);
            make.left.mas_equalTo(self.iconImageView.mas_right).mas_equalTo(10);
        }];
    }
    return _nameLabel;
}

-(UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [UILabel new];
        _scoreLabel.text = @"Score:9527";
        _scoreLabel.textColor = ColorRBG(0xe2d6e4);
        _scoreLabel.font = KFont(15);
        [self.beijinView addSubview:_scoreLabel];
        [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.beijinView.mas_centerY).mas_equalTo(4);
            make.left.mas_equalTo(self.iconImageView.mas_right).mas_equalTo(10);
        }];
    }
    return _scoreLabel;
}

-(UILabel *)rankLabel
{
    if (!_rankLabel) {
        _rankLabel = [UILabel new];
        _rankLabel.textAlignment = NSTextAlignmentCenter;
        _rankLabel.backgroundColor = ColorRBG(0x9e4fb1);
        _rankLabel.text = @"1";
        _rankLabel.textColor = ColorRBG(0xffffff);
        _rankLabel.font = [UIFont boldSystemFontOfSize:16];
        _rankLabel.layer.cornerRadius = 20;
        _rankLabel.layer.masksToBounds = YES;
        [self.beijinView addSubview:_rankLabel];
        [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-6);
            make.size.mas_equalTo(CGSizeMake(80, 40));
        }];
    }
    return _rankLabel;
}

-(void)setScore:(GKScore *)score
{
    _score = score;
    self.nameLabel.text = score.player.displayName;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score:%lld",score.value];
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",score.rank];
    if (score.rank == 1) {
        self.iconLabel.hidden = YES;
        self.iconImageView.image = ImageName(@"rank1_icon");
    }else if (score.rank == 2){
        self.iconLabel.hidden = YES;
        self.iconImageView.image = ImageName(@"rank2_icon");
    }else if (score.rank == 3){
        self.iconLabel.hidden = YES;
        self.iconImageView.image = ImageName(@"rank3_icon");
    }else{
        NSString * firstStr = [score.player.displayName substringToIndex:1];
        NSString * zimu = @"^[A-Za-z]+$";
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",zimu];
        if ([predicate evaluateWithObject:firstStr]) {
            self.iconImageView.image = ImageName(@"rankcell_icon");
            self.iconLabel.hidden = NO;
            self.iconLabel.text = firstStr;
        }else{
            self.iconImageView.image = ImageName(@"rankcell_cn_icon");
            self.iconLabel.hidden = YES;
        }
    }
}
@end
