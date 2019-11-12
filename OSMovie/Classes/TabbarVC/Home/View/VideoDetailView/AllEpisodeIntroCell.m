//
//  AllEpisodeIntroCell.m
//


#import "AllEpisodeIntroCell.h"
#import "UILabel+Category.h"

@interface AllEpisodeIntroCell ()

@property (nonatomic,weak) UILabel *titleLab;
@property (nonatomic,weak) UILabel *picLab;

@end

@implementation AllEpisodeIntroCell

- (void)setModel:(EpisodeIntroModel *)model {
    _model = model;
    self.titleLab.text = model.title;
    self.picLab.text = model.summary;
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"AllEpisodeIntroCell";
    AllEpisodeIntroCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[AllEpisodeIntroCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
   
    UILabel *titleLab = [UILabel labelWithTitle:@"" font:12 textColor:Black_Color textAlignment:0];
    titleLab.numberOfLines = 0;
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.sizeH(5));
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
    }];
    
    UILabel *picLab = [UILabel labelWithTitle:@"" font:12 textColor:LightGray_Color textAlignment:0];
    picLab.numberOfLines = 0;
    self.picLab = picLab;
    [self.contentView addSubview:picLab];
    [self.picLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(self.sizeH(5));
        make.left.right.equalTo(self.titleLab);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(5);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
