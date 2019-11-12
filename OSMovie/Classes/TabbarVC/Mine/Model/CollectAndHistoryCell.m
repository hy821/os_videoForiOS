//
//  CollectAndHistoryCell.m
//



#import "CollectAndHistoryCell.h"
#import "UILabel+Category.h"

@interface CollectAndHistoryCell()
@property (nonatomic,weak) UIImageView *videoIV;
@property (nonatomic,weak) UILabel *titleLab;
@property (nonatomic,weak) UILabel *subTitleLab;
@end

@implementation CollectAndHistoryCell

- (void)setModel:(ProgramResultListModel *)model {
    _model = model;
    
    [self.videoIV sd_setImageWithURL:URL(model.poster.url) placeholderImage:img_placeHolder options:SDWebImageRetryFailed];
    self.titleLab.text = model.name;
    self.subTitleLab.text = model.briefIntroduction;
    
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"CollectAndHistoryCell";
    CollectAndHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[CollectAndHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self createUI];
    }return self;
}

-(void)createUI {
    self.contentView.backgroundColor = White_Color;
    UIImageView *videoIV = [[UIImageView alloc]init];
    videoIV.contentMode = UIViewContentModeScaleAspectFill;
    videoIV.image = img_placeHolder;
    videoIV.layer.masksToBounds = YES;
    videoIV.layer.cornerRadius = 5;
    [self.contentView addSubview:videoIV];
    self.videoIV = videoIV;
    
    [self.videoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.sizeH(10));
        make.bottom.equalTo(self.contentView).offset(self.sizeH(-10));
        make.left.equalTo(self.contentView).offset(self.sizeH(12));
        make.height.equalTo(self.sizeH(80));
        make.width.equalTo(self.sizeW(120));
    }];
    
    UILabel *titleLab = [UILabel labelWithTitle:@"" font:15 textColor:KCOLOR(@"#000000") textAlignment:0];
    [self.contentView addSubview:titleLab];
    titleLab.numberOfLines = 0;
    self.titleLab = titleLab;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoIV).offset(self.sizeH(5));
        make.left.equalTo(self.videoIV.mas_right).offset(self.sizeW(12));
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
//        make.bottom.lessThanOrEqualTo(self.videoIV);
    }];
    
    UILabel *subLab = [UILabel labelWithTitle:@"" font:10 textColor:KCOLOR(@"#A99898") textAlignment:11];
    [self.contentView addSubview:subLab];
    self.subTitleLab = subLab;
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(self.sizeH(10));
        make.bottom.lessThanOrEqualTo(self.videoIV.mas_bottom).offset(self.sizeH(-5));
        make.left.right.equalTo(self.titleLab);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#EEEDED");
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(0.7f);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
