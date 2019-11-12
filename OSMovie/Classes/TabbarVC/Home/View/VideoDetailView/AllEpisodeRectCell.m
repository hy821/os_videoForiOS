//
//  AllEpisodeRectCell.m
//



#import "AllEpisodeRectCell.h"
#import "UILabel+Category.h"

@interface AllEpisodeRectCell ()
@property (nonatomic,weak) UILabel *titleLab;
@property (nonatomic,weak) UILabel *picLab;
@property (nonatomic,weak) UIImageView *coverIV;
@property (nonatomic,weak) UIImageView *videoIV;

@end

@implementation AllEpisodeRectCell

- (void)setModel:(MediaTipResultModel *)model {
    [self.videoIV sd_setImageWithURL:URL(model.coverInfo.url) placeholderImage:img_placeHolder options:SDWebImageRetryFailed];
    self.titleLab.text = model.title;
    self.picLab.text = model.mediaIndex;
  
    if (model.isSelect) {
        self.titleLab.textColor = KCOLOR(@"#FF5C3E");
        self.videoIV.layer.borderColor = KCOLOR(@"#FF5C3E").CGColor;
    }else {
        self.titleLab.textColor = KCOLOR(@"#4A4A4A");
        self.videoIV.layer.borderColor = White_Color.CGColor;
    }
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"AllEpisodeRectCell";
    AllEpisodeRectCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[AllEpisodeRectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }return self;
}

- (void)createUI {
    self.backgroundColor = White_Color;
    UIImageView *iv = [[UIImageView alloc]init];
    iv.image = img_placeHolder;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    iv.layer.borderWidth = 1;
    iv.layer.borderColor = White_Color.CGColor;
    iv.layer.masksToBounds = YES;
    iv.layer.cornerRadius = 2;
    self.videoIV = iv;
    [self.contentView addSubview:iv];
    [self.videoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.top.equalTo(self.contentView).offset(self.sizeH(7));
        make.bottom.equalTo(self.contentView).offset(self.sizeH(-7));
        make.width.equalTo(self.sizeW(130));
    }];
    
    UIImageView *coverIV = [[UIImageView alloc]initWithImage:Image_Named(@"")];
    [self.contentView addSubview:coverIV];
    self.coverIV = coverIV;
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.videoIV);
    }];
    
    UILabel *picLab = [UILabel labelWithTitle:@"" font:9 textColor:White_Color textAlignment:2];
    picLab.numberOfLines = 0;
    self.picLab = picLab;
    [self.videoIV addSubview:self.picLab];
    [self.picLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.videoIV).offset(self.sizeH(-8));
        make.bottom.equalTo(self.videoIV.mas_bottom).offset(self.sizeH(-8));
        make.height.lessThanOrEqualTo(self.sizeH(50));
        make.width.equalTo(self.sizeW(114));
    }];
    
    UILabel *titleLab = [UILabel labelWithTitle:@"" font:12 textColor:KCOLOR(@"#4A4A4A") textAlignment:0];
    titleLab.numberOfLines = 0;
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoIV).offset(self.sizeH(5));
        make.left.equalTo(self.videoIV.mas_right).offset(self.sizeW(8));
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
        make.bottom.lessThanOrEqualTo(self.contentView);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(0.9f);
    }];
}
@end
