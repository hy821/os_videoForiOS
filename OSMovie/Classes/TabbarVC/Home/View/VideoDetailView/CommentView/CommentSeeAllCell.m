//
//  CommentSeeAllCell.m
//  KSMovie
//
//  Created by young He on 2019/5/9.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "CommentSeeAllCell.h"

@interface CommentSeeAllCell ()

@property (nonatomic,weak) UILabel *seeAllLab;

@end

@implementation CommentSeeAllCell

- (void)setModel:(CommentModel *)model {
    _model = model;
    self.seeAllLab.text = [NSString stringWithFormat:@"查看全部%@条回复 >",model.count];
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"CommentSeeAllCell";
    CommentSeeAllCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[CommentSeeAllCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }return self;
}

-(void)createUI {
    self.backgroundColor = White_Color;
    UIView *bg = [[UIView alloc]init];
    bg.backgroundColor = KCOLOR(@"#F7F7F7");
    [self.contentView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(self.sizeH(50));
        make.right.equalTo(self.contentView).offset(self.sizeH(-12));
    }];
    UILabel * seeAllLab = [[UILabel alloc]init];
    seeAllLab.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    seeAllLab.textAlignment = NSTextAlignmentLeft;
    seeAllLab.font = KFONT(11);
    seeAllLab.textColor = KCOLOR(@"#000000");
    [bg addSubview:seeAllLab];
    self.seeAllLab = seeAllLab;
    [seeAllLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg).offset(UIEdgeInsetsMake(0, 5, 0, 0));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
