//
//  VideoMsgCell.m
//


#import "VideoMsgCell.h"
#import "UILabel+Category.h"
#import "UIButton+Category.h"
#import "HorizenButton.h"
#import "HJRatingView.h"
#import "LCActionSheet.h"
#import "UIControl+recurClick.h"
#import "KSLayerAnimation.h"

@interface VideoMsgCell()<LCActionSheetDelegate>

@property (nonatomic,weak) UILabel *nameLab;
@property (nonatomic,weak) UILabel *categoryLab;
@property (nonatomic,weak) UILabel *directorLab;
@property (nonatomic,weak) UILabel *countryLab;
@property (nonatomic,weak) UILabel *actorLab;
@property (nonatomic,weak) HorizenButton *sourceBtn;
@property (nonatomic,weak) UILabel *scoreLab; /** 展示分数 */
@property (nonatomic,weak) UIImageView *starView; //展示分数的bgView
@property (nonatomic,weak) HJRatingView *ratingView; /** 评分视图 */

@property (nonatomic,weak) HorizenButton *playBtn;
@property (nonatomic,weak) HorizenButton *collectBtn;
@property (nonatomic,assign) NSInteger mediaSourceSelectIndex; //选中的视频来源Index   从1开始
@end

@implementation VideoMsgCell

- (void)setModel:(VDCommonModel *)model {
    _model = model;
    
    self.countryLab.hidden = model ? NO : YES;
    self.sourceBtn.hidden = model ? NO : YES;
    self.starView.hidden = model ? NO : YES;
    self.playBtn.hidden = model ? NO : YES;
    
    self.nameLab.text = model.name;
    self.categoryLab.text = [model.categoryArr componentsJoinedByString:@"/"];
    if(model.directorArr.count>0) {
        self.directorLab.text =  [NSString stringWithFormat:@"导演:%@",[model.directorArr componentsJoinedByString:@"/"]];
        [self.directorLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.categoryLab.mas_bottom).offset(self.sizeH(5));
            make.left.equalTo(self.categoryLab);
            make.height.equalTo(self.sizeH(15));
            make.width.lessThanOrEqualTo(self.sizeW(105));
        }];
        [self.countryLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.directorLab);
            make.left.equalTo(self.directorLab.mas_right).offset(self.sizeW(5));
            make.right.equalTo(self.contentView).offset(self.sizeW(-150));
            make.height.equalTo(self.sizeH(15));
        }];
    }else {
        self.directorLab.text =  @"";
        [self.directorLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.categoryLab.mas_bottom).offset(self.sizeH(5));
            make.left.equalTo(self.categoryLab);
            make.height.equalTo(self.sizeH(15));
            make.width.lessThanOrEqualTo(0);
        }];
        [self.countryLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.directorLab);
            make.left.equalTo(self.directorLab.mas_right).offset(self.sizeW(0));
            make.right.equalTo(self.contentView).offset(self.sizeW(-150));
            make.height.equalTo(self.sizeH(15));
        }];
    }
    if (model.areas) {
        self.countryLab.text = [NSString stringWithFormat:@"国家/地区:%@",model.areas];
    }else {
        self.countryLab.text = @"国家/地区:";
    }
    if (model.stars.count>0) {
        self.actorLab.text =  [NSString stringWithFormat:@"主演:%@",[model.starsArray componentsJoinedByString:@","]];
        [self.actorLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.directorLab.mas_bottom).offset(self.sizeH(5));
            make.left.equalTo(self.directorLab);
            make.right.equalTo(self.countryLab);
            make.height.equalTo(self.sizeH(15));
        }];
        [self.sourceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.actorLab.mas_bottom).offset(self.sizeH(5));
            make.left.equalTo(self.directorLab);
            make.height.equalTo(self.sizeH(18));
        }];
    }else {
        self.actorLab.text = @"";
        [self.actorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.directorLab.mas_bottom).offset(self.sizeH(5));
            make.left.equalTo(self.directorLab);
            make.right.equalTo(self.countryLab);
            make.height.equalTo(0);
        }];
        [self.sourceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.actorLab.mas_bottom).offset(0);
            make.left.equalTo(self.directorLab);
            make.height.equalTo(self.sizeH(18));
        }];
    }
    
    self.scoreLab.text = [model.originPoints integerValue] > 0 ? model.originPoints : @"暂无";
    self.ratingView.showScore = [model.originPoints integerValue];
      
    self.collectBtn.selected = [model.collected integerValue];
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"VideoMsgCell";
    VideoMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[VideoMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }return self;
}

-(void)createUI {
    self.contentView.backgroundColor = White_Color;
    
    UILabel *nameLab = [UILabel labelWithTitle:@"" font:20 textColor:Black_Color textAlignment:0];
    [nameLab setFont:Font_Bold(20)];
    [self.contentView addSubview:nameLab];
    self.nameLab = nameLab;
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.sizeH(15));
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.right.equalTo(self.contentView).offset(self.sizeW(-15));
        make.height.equalTo(self.sizeH(30));
    }];
    
    UILabel *categoryLab = [UILabel labelWithTitle:@"" font:11 textColor:KCOLOR(@"#9B9B9B") textAlignment:0];
    [self.contentView addSubview:categoryLab];
    self.categoryLab = categoryLab;
    [self.categoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(self.sizeH(5));
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.height.equalTo(self.sizeH(20));
    }];
    
    UILabel *directorLab = [UILabel labelWithTitle:@"" font:11 textColor:KCOLOR(@"#4A4A4A") textAlignment:0];
    [self.contentView addSubview:directorLab];
    self.directorLab = directorLab;
    [self.directorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryLab.mas_bottom).offset(self.sizeH(5));
        make.left.equalTo(self.categoryLab);
        make.height.equalTo(self.sizeH(15));
        make.width.lessThanOrEqualTo(self.sizeW(105));
    }];
    
    UILabel *countryLab = [UILabel labelWithTitle:@"" font:11 textColor:KCOLOR(@"#4A4A4A") textAlignment:0];
    [self.contentView addSubview:countryLab];
    self.countryLab = countryLab;
    [self.countryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.directorLab);
        make.left.equalTo(self.directorLab.mas_right).offset(self.sizeW(5));
        make.right.equalTo(self.contentView).offset(self.sizeW(-150));
        make.height.equalTo(self.sizeH(15));
    }];
   
    UILabel *actorLab = [UILabel labelWithTitle:@"" font:11 textColor:KCOLOR(@"#4A4A4A") textAlignment:0];
    [self.contentView addSubview:actorLab];
    self.actorLab = actorLab;
    [self.actorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.directorLab.mas_bottom).offset(self.sizeH(5));
        make.left.equalTo(self.directorLab);
        make.right.equalTo(self.countryLab);
        make.height.equalTo(self.sizeH(15));
    }];
    
    HorizenButton *sourceBtn = [[HorizenButton alloc]init];
    [sourceBtn setTitle:@"查看来源" forState:UIControlStateNormal];
    [sourceBtn setTitle:@"查看来源" forState:UIControlStateSelected];
    sourceBtn.titleLabel.font = Font_Size(10);
    [sourceBtn setTitleColor:KCOLOR(@"#81B0B6") forState:UIControlStateNormal];
    [sourceBtn setTitleColor:KCOLOR(@"#81B0B6") forState:UIControlStateSelected];
    sourceBtn.isTitleLeft = YES;
    sourceBtn.margeWidth = 3.f;
    [sourceBtn setImage:Image_Named(@"ic_little") forState:UIControlStateNormal];
    [sourceBtn setImage:Image_Named(@"ic_little") forState:UIControlStateSelected];
    [sourceBtn addTarget:self action:@selector(showSourceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sourceBtn];
    self.sourceBtn = sourceBtn;
    [self.sourceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actorLab.mas_bottom).offset(self.sizeH(5));
        make.left.equalTo(self.directorLab);
        make.height.equalTo(self.sizeH(18));
    }];
    
    UIImageView *starView = [[UIImageView alloc]initWithImage:Image_Named(@"img_buy_bg")];
    starView.contentMode = UIViewContentModeScaleAspectFit;
    starView.userInteractionEnabled = YES;
    [self.contentView addSubview:starView];
    self.starView = starView;
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom);
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
        make.width.equalTo(self.sizeW(130));
        make.height.equalTo(self.sizeH(135));
    }];
    
    HJRatingView *ratingView = [[HJRatingView alloc] initWithItemWidth:self.sizeW(18) margin:self.sizeW(0)];
    [ratingView setBgImageName:@"rating_gray" andTopImageName:@"rating_yellow"];
    ratingView.backgroundColor = White_Color;
    ratingView.maxScore = 10;
    ratingView.showScore = 8.8;
    [starView addSubview:ratingView];
    self.ratingView = ratingView;
    [self.ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starView);
        make.left.equalTo((self.sizeW(130)-self.ratingView.width)/2);
    }];
    
    UILabel *scoreLab = [UILabel labelWithTitle:@"" font:25 textColor:KCOLOR(@"#4A4A4A") textAlignment:1];
    [starView addSubview:scoreLab];
    self.scoreLab = scoreLab;
    [self.scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ratingView.mas_top).offset(-self.sizeH(10));
        make.centerX.equalTo(starView);
    }];
        
    HorizenButton *playBtn = [[HorizenButton alloc]init];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn setTitle:@"播放" forState:UIControlStateSelected];
    playBtn.titleLabel.font = Font_Size(12);
    [playBtn setTitleColor:KCOLOR(@"#9B9B9B") forState:UIControlStateNormal];
    [playBtn setTitleColor:KCOLOR(@"#9B9B9B") forState:UIControlStateSelected];
    playBtn.isTitleLeft = NO;
    playBtn.margeWidth = 2.f;
    playBtn.uxy_acceptEventInterval = 1.f;
    [playBtn setImage:Image_Named(@"ic_play") forState:UIControlStateNormal];
    [playBtn setImage:Image_Named(@"ic_play") forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:playBtn];
    self.playBtn = playBtn;
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(starView.mas_bottom).offset(self.sizeH(5));
        make.left.equalTo(self.directorLab);
        make.height.equalTo(self.sizeH(30));
        make.width.equalTo(self.sizeW(60));
    }];

    HorizenButton *collectBtn = [[HorizenButton alloc]init];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitle:@"收藏" forState:UIControlStateSelected];
    collectBtn.titleLabel.font = Font_Size(12);
    [collectBtn setTitleColor:KCOLOR(@"#9B9B9B") forState:UIControlStateNormal];
    [collectBtn setTitleColor:KCOLOR(@"#9B9B9B") forState:UIControlStateSelected];
    collectBtn.isTitleLeft = NO;
    collectBtn.margeWidth = 2.f;
    collectBtn.uxy_acceptEventInterval = 0.5f;
    [collectBtn setImage:Image_Named(@"ic_collect") forState:UIControlStateNormal];
    [collectBtn setImage:Image_Named(@"ic_choosecollect") forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:collectBtn];
    self.collectBtn = collectBtn;
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn);
        make.left.equalTo(self.playBtn.mas_right);
        make.height.equalTo(self.playBtn);
        make.width.equalTo(self.sizeW(60));
    }];
}

- (void)playAction {
    if (self.clickBlock) {
        self.clickBlock(1);
    }
}

- (void)collectAction:(HorizenButton *)sender {
    
    sender.selected = !sender.selected;
    [KSLayerAnimation animationWithView:sender.imageView type:RotationAnimationLeftRight repeatCount:0 duration:0];

//    NSString *sourceID = @"";
//    if (self.model.indexSelectForSource) {
//        sourceID = self.model.mediaSourceResultList[self.model.indexSelectForSource].idForModel;
//    }
//    NSDictionary *dic = @{@"assetType" : self.model.type,
//                          @"programId" : self.model.idForModel
//                          };
//    [USER_MANAGER videoCollectionWithPar:dic andIsCollection:!sender.isSelected success:^(id response) {
//        sender.selected = !sender.selected;
//        [KSLayerAnimation animationWithView:sender.imageView type:RotationAnimationLeftRight repeatCount:0 duration:0];
//    } failure:^(NSString *errMsg) {
//        SSMBToast(errMsg, MainWindow);
//    }];
}

- (void)showSourceAction {
    SSMBToast(@"暂无播放源,  看看其他精彩内容吧~", MainWindow);
}

@end
