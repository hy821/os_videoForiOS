//
//  CommentSectionHeaderView.m
//  KSMovie
//
//  Created by young He on 2019/5/9.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "CommentSectionHeaderView.h"
#import "M80AttributedLabel.h"
#import "HorizenButton.h"
#import "UIControl+recurClick.h"
#import "KSLayerAnimation.h"

@interface CommentSectionHeaderView()
@property (nonatomic,weak) UIImageView * userImg;
@property (nonatomic,weak) UILabel * nameLable;
@property (nonatomic,weak) UIImageView * vipImg;
@property (nonatomic,weak) UILabel * timeLable;
@property (nonatomic,weak) HorizenButton *likeBtn;
@property (nonatomic,weak) M80AttributedLabel * descLable;
@end

@implementation CommentSectionHeaderView

- (void)setModel:(CommentModel *)model {
    _model = model;
    [self.userImg sd_setImageWithURL:URL(model.userBasic.portrait) placeholderImage:img_placeHolderIcon];
    self.nameLable.text = model.userBasic.nickName;
    self.timeLable.text = model.timeString;
    self.descLable.text = model.details;
    
    self.likeBtn.selected = model.likeOrSetOn;
    NSString *likeNumStr = @"";
    long likeNum = [model.interacts[@"PRAISE"] longValue];
    if (likeNum>0) {
        likeNumStr = [NSString stringWithFormat:@"%ld",likeNum];
    }
    
    [self.likeBtn setTitle:likeNumStr  forState:(UIControlStateNormal)];
    [self.likeBtn setTitle:likeNumStr  forState:(UIControlStateSelected)];
    
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
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
        make.bottom.equalTo(self.contentView).offset(0);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)tapAction:(UIGestureRecognizer*)tap {
    if (self.replyBlock) {
        self.replyBlock();
    }
}

- (void)likeOrSetOnAction:(HorizenButton *)sender {
    
    if (![USER_MANAGER isLogin]) {
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
                          @"ownerId" : self.model.ownerId ? self.model.ownerId : @"",   //programId 节目id
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
