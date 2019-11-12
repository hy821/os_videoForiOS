//
//  SynopsisCell.m
//

#import "SynopsisCell.h"
#import "HorizenButton.h"
#import "UILabel+Category.h"

@interface SynopsisCell()

@property (nonatomic,weak) UILabel *synopsisLab; 
@property (nonatomic,weak) UILabel *contentLab;
@property (nonatomic,weak) HorizenButton *openCloseBtn;
@property (nonatomic,weak) UIView *line;
@end

@implementation SynopsisCell

- (void)setModel:(VDCommonModel *)model {
    _model = model;
    self.contentLab.text = [NSString stringWithFormat:@"简介:%@",model.descriptionForModel];
    self.openCloseBtn.selected = model.isOpen;
    self.openCloseBtn.hidden = !model.isShowFoldBtn;

}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"SynopsisCell";
    SynopsisCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[SynopsisCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    self.clipsToBounds = YES;
    UILabel *synopsisLab = [UILabel labelWithTitle:@"剧情简介" font:13 textColor:KCOLOR(@"#333333") textAlignment:0];
    [self.contentView addSubview:synopsisLab];
    self.synopsisLab = synopsisLab;
    [self.synopsisLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.sizeH(10));
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.height.equalTo(self.sizeH(25));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.contentView addSubview:line];
    self.line = line;
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(self.sizeH(0.9));
    }];
    
    HorizenButton *btn = [[HorizenButton alloc]init];
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    [btn setTitle:@"收起" forState:UIControlStateSelected];
    btn.titleLabel.font = Font_Size(13);
    [btn setTitleColor:KCOLOR(@"#333333") forState:UIControlStateNormal];
    [btn setTitleColor:KCOLOR(@"#333333") forState:UIControlStateSelected];
    btn.isTitleLeft = YES;
    btn.margeWidth = 1.f;
    [btn setImage:Image_Named(@"ic_more") forState:UIControlStateNormal];
    [btn setImage:Image_Named(@"ic_fold") forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(openCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    self.openCloseBtn = btn;
    [self.openCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
        make.bottom.equalTo(self.line.mas_top).offset(self.sizeH(-3));
        make.height.equalTo(self.sizeH(30));
    }];
    
    UILabel *contentLab = [UILabel labelWithTitle:@"" font:13 textColor:KCOLOR(@"#9B9B9B") textAlignment:0];
    [contentLab setNumberOfLines:0];
    [self.contentView addSubview:contentLab];
    self.contentLab = contentLab;
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.synopsisLab.mas_bottom);
        make.left.equalTo(self.synopsisLab);
        make.right.equalTo(self.openCloseBtn);
        make.bottom.equalTo(self.openCloseBtn.mas_top);
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(self.sizeH(7));
    }];
}

- (void)openCloseAction:(HorizenButton*)sender {
    if (self.foldOpenBlock) {
        self.foldOpenBlock(!sender.isSelected);
        sender.selected = !sender.selected;
    }
}

@end
