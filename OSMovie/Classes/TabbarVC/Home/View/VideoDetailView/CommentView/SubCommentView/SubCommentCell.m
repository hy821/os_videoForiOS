//
//  SubCommentCell.m
//  KSMovie
//
//  Created by young He on 2019/5/11.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "SubCommentCell.h"
#import "M80AttributedLabel.h"
#import "HorizenButton.h"
#import "UIControl+recurClick.h"
#import "KSLayerAnimation.h"
#import "UILabel+Category.h"
#import "VideoDetailViewController.h"

@interface SubCommentCell()
@property (nonatomic,weak) UIImageView * userImg;
@property (nonatomic,weak) UILabel * nameLable;
@property (nonatomic,weak) UIImageView * vipImg;
@property (nonatomic,weak) UILabel * timeLable;
@property (nonatomic,weak) HorizenButton *likeBtn;
@property (nonatomic,weak) M80AttributedLabel * descLable;
@property (nonatomic,weak) UIView *lineBottom;

//消息中心进入评论详情页, 展示的影片View
@property (nonatomic,weak) UIView *grayView;
@property (nonatomic,weak) UIImageView *videoIV;
@property (nonatomic,weak) UILabel *videoNameLab;

@end

@implementation SubCommentCell

- (void)setModel:(CommentModel *)model {
    _model = model;
    [self.userImg sd_setImageWithURL:URL(model.userBasic.portrait) placeholderImage:img_placeHolderIcon];
    self.nameLable.text = model.userBasic.nickName;
    self.timeLable.text = model.timeString;
    self.likeBtn.selected = model.likeOrSetOn;
    
    NSString *likeNumStr = @"";
    long likeNum = [model.interacts[@"PRAISE"] longValue];
    if (likeNum>0) {
        likeNumStr = [NSString stringWithFormat:@"%ld",likeNum];
    }
    
    [self.likeBtn setTitle:likeNumStr  forState:(UIControlStateNormal)];
    [self.likeBtn setTitle:likeNumStr  forState:(UIControlStateSelected)];
    
    if (model.isFirstCom) {  //顶部cell  一级评论
        self.descLable.text = model.details;
    }else {  // 二级评论
        self.descLable.attributedText = model.detailsForSubComView;
    }
    
    //消息中心进入评论详情页, 顶部评论, 带展示的影片View
    if(model.isFromMsgCenter) {
        self.descLable.text = model.details;
        [self.videoIV sd_setImageWithURL:URL(model.url) placeholderImage:img_placeHolder];
        self.videoNameLab.text = model.title;
        self.grayView.hidden = NO;
        [self.grayView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.sizeH(100));
        }];
        
        [self.descLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLable.mas_bottom).offset(self.sizeH(2));
            make.left.equalTo(self.nameLable);
            make.right.equalTo(self.contentView).offset(self.sizeH(-12));
            make.bottom.equalTo(self.grayView.mas_top).offset(self.sizeH(-5));
        }];
        
    }else {
        self.grayView.hidden = YES;
        [self.grayView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.sizeH(0));
        }];
        
        [self.descLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLable.mas_bottom).offset(self.sizeH(2));
            make.left.equalTo(self.nameLable);
            make.right.equalTo(self.contentView).offset(self.sizeH(-12));
            make.bottom.equalTo(self.contentView).offset(self.sizeH(-1));
        }];
    }
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"SubCommentCell";
    SubCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[SubCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }return self;
}

- (void)createUI {
    UIImageView * userImage = [[UIImageView alloc]init];
    userImage.contentMode = UIViewContentModeScaleAspectFill;
    userImage.clipsToBounds = YES;
    [self.contentView addSubview:userImage];
    self.userImg = userImage;
    [self.userImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.sizeH(12));
        make.top.equalTo(self.contentView).offset(self.sizeH(12));
        make.width.height.equalTo(self.sizeH(30));
    }];
    
    UIImageView * img = [[UIImageView alloc]initWithImage:K_IMG(@"circleWhite")];
    img.contentMode = UIViewContentModeScaleAspectFill;
    [self.userImg addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.userImg);
    }];
    
    UILabel * nameLable = [[UILabel alloc]init];
    nameLable.font = KFONT(13);
    nameLable.textColor = KCOLOR(@"#9B9B9B");
    [self.contentView addSubview:nameLable];
    self.nameLable = nameLable;
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userImg);
        make.left.equalTo(self.userImg.mas_right).offset(self.sizeH(8));
        make.height.equalTo(self.sizeH(20));
    }];
    
    UIImageView * vipImg = [[UIImageView alloc]init];
    vipImg.hidden = YES;
    [self.contentView addSubview:vipImg];
    self.vipImg = vipImg;
    [self.vipImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLable);
        make.left.equalTo(self.nameLable.mas_right).offset(5.f);
        make.right.lessThanOrEqualTo(self.contentView).offset(-5.f);
    }];
    
    UILabel * timeLable = [[UILabel alloc]init];
    timeLable.font = KFONT(10);
    timeLable.textColor = KCOLOR(@"#9B9B9B");
    timeLable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.contentView addSubview:timeLable];
    self.timeLable = timeLable;
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable.mas_bottom).offset(-self.sizeH(2));
        make.left.equalTo(self.nameLable);
        make.height.equalTo(self.sizeH(15));
    }];
    
    HorizenButton *btn = [[HorizenButton alloc]init];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setTitle:@"" forState:UIControlStateSelected];
    btn.titleLabel.font = Font_Size(8);
    [btn setTitleColor:KCOLOR(@"#AAAAAA") forState:UIControlStateNormal];
    [btn setTitleColor:KCOLOR(@"#FFE55D") forState:UIControlStateSelected];
    btn.isTitleLeft = NO;
    btn.margeWidth = 2.f;
    btn.uxy_acceptEventInterval = 0.5f;
    self.likeBtn = btn;
    [self.contentView addSubview:btn];
    [btn setImage:Image_Named(@"ic_like") forState:UIControlStateNormal];
    [btn setImage:Image_Named(@"ic_like_choose") forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(likeOrSetOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLable);
        make.right.equalTo(self.contentView).offset(self.sizeH(-5));
        make.width.height.equalTo(self.sizeH(35));
    }];
    
    UIView *grayView = [[UIView alloc]init];
    grayView.backgroundColor = KCOLOR(@"#F7F7F7");
    grayView.clipsToBounds = YES;
    [self.contentView addSubview:grayView];
    self.grayView = grayView;
    self.grayView.hidden = YES;
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(self.sizeH(-5));
        make.left.equalTo(self.nameLable);
        make.right.equalTo(self.contentView).offset(self.sizeH(-12));
        make.height.equalTo(self.sizeH(0));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goVideoDetailAction:)];
    [self.grayView addGestureRecognizer:tap];
    
    UIImageView *videoIV = [[UIImageView alloc]init];
    videoIV.contentMode = UIViewContentModeScaleAspectFill;
    videoIV.layer.masksToBounds = YES;
    videoIV.layer.cornerRadius = self.sizeH(5);
    [self.grayView addSubview:videoIV];
    self.videoIV = videoIV;
    [self.videoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.grayView).offset(self.sizeH(10));
        make.bottom.equalTo(self.grayView).offset(self.sizeH(-10));
        make.left.equalTo(self.grayView).offset(self.sizeH(10));
        make.width.equalTo(self.videoIV.mas_height);
    }];
    
    UILabel *videoNameLab = [UILabel labelWithTitle:@"" font:16 textColor:KCOLOR(@"#4A4A4A") textAlignment:0];
    videoNameLab.numberOfLines = 0;
    [self.grayView addSubview:videoNameLab];
    self.videoNameLab = videoNameLab;
    [self.videoNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoIV.mas_right).offset(self.sizeW(12));
        make.right.equalTo(self.grayView).offset(self.sizeW(-12));
        make.centerY.equalTo(self.grayView);
        make.top.bottom.equalTo(self.grayView);
    }];
    
    M80AttributedLabel * descLable = [[M80AttributedLabel alloc]init];
    descLable.font = KFONT(14);
    descLable.numberOfLines = 0.f;
    descLable.textColor = KCOLOR(@"#000000");
    [self.contentView addSubview:descLable];
    self.descLable = descLable;
    [self.descLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLable.mas_bottom).offset(self.sizeH(2));
        make.left.equalTo(self.nameLable);
        make.right.equalTo(self.contentView).offset(self.sizeH(-12));
        make.bottom.equalTo(self.contentView).offset(self.sizeH(-1));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.contentView addSubview:line];
    self.lineBottom = line;
    [self.lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable);
        make.right.equalTo(self.likeBtn);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(0.9f);
    }];
}

- (void)goVideoDetailAction:(UITapGestureRecognizer *)sender {
    VideoDetailViewController *vc = [[VideoDetailViewController alloc]init];
    ProgramResultListModel *m = [[ProgramResultListModel alloc]init];
    m.idForModel = self.model.pi;
    m.type = self.model.pt;
    vc.model = m;
    [SelectVC pushViewController:vc animated:YES];
}
    
- (void)hideBottomLine {
    self.lineBottom.hidden = YES;
}

- (void)likeOrSetOnAction:(HorizenButton *)sender {
    
    if (![USER_MANAGER isLogin]) {
        SSMBToast(@"登录后可点赞喔~", MainWindow);
        if (self.likeBtnToLoginBlock) {
            self.likeBtnToLoginBlock();
        }
        return;
    }
    if ([self.model.userBasic.userId isEqualToString:[USER_MANAGER getUserID]]) {
        SSMBToast(@"不能对自己的评论点赞喔~", MainWindow);
        return;
    }
    
    //    if (self.buryPointLikeBtnClickBlock) {
    //        self.buryPointLikeBtnClickBlock((sender.tag==100));
    //    }
    
    NSString *clickType = (sender.isSelected) ? @"STEPON" : @"PRAISE";
    NSDictionary *dic = @{@"userId" : self.model.userBasic.userId ? self.model.userBasic.userId : @"",
                          @"ownerId" : self.model.pid ? self.model.pid : @"",
                          @"commentId" : self.model.idForModel ? self.model.idForModel : @"",
                          @"commentInteract" : clickType
                          };
    
    [[SSRequest request]POST:LikeOrSetOnCommentUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
        
        NSString *likeNumStr = @"";
        long likeNum = [self.model.interacts[@"PRAISE"] longValue];
        
        if (sender.selected) {  // -1
            likeNum -=1;
        }else {  // +1
            likeNum +=1;
        }
        
        if (likeNum<0) { likeNum = 0; }

        if (likeNum>0) {
            likeNumStr = [NSString stringWithFormat:@"%ld",likeNum];
        }
        if (likeNum==1 && !sender.selected) {  //自己一个点赞, 不要数字1
            likeNumStr = @"";
        }

        [self.likeBtn setTitle:likeNumStr  forState:(UIControlStateNormal)];
        [self.likeBtn setTitle:likeNumStr  forState:(UIControlStateSelected)];
        
        sender.selected = !sender.selected;
        [KSLayerAnimation animationWithView:sender type:BounceAnimation repeatCount:0 duration:0];
        
    } failure:^(SSRequest *request, NSString *errorMsg) {
        SSMBToast(errorMsg, MainWindow);
    }];
}

@end
