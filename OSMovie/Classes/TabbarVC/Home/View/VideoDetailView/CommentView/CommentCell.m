//
//  CommentCell.m
//  KSMovie
//
//  Created by young He on 2019/5/9.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "CommentCell.h"
#import "M80AttributedLabel.h"

@interface CommentCell()

@property (nonatomic,weak) M80AttributedLabel * descLable;

@end

@implementation CommentCell

- (void)setModel:(CommentModel *)model {
    _model = model;
    self.descLable.attributedText = model.subCommentDetails;
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"CommentCell";
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

    UIView *bg = [[UIView alloc]init];
    bg.backgroundColor = KCOLOR(@"#F7F7F7");
    [self.contentView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(self.sizeH(50));
        make.right.equalTo(self.contentView).offset(self.sizeH(-12));
    }];
    M80AttributedLabel * descLable = [[M80AttributedLabel alloc]init];
    descLable.font = KFONT(12);
    descLable.numberOfLines = 0.f;
    descLable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [bg addSubview:descLable];
    self.descLable = descLable;
    [self.descLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg).offset(UIEdgeInsetsMake(self.sizeH(2), self.sizeH(5), 0, 0));
    }];
}

@end
