//
//  ReportCell.m
//

#import "ReportCell.h"
#import "UILabel+Category.h"

@interface ReportCell ()

@property (nonatomic,strong) UILabel *contentLab;

@end

@implementation ReportCell

- (void)setModel:(ReportCellModel *)model {
    _model = model;
    self.contentLab.text = model.title;
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"ReportCell";
    ReportCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[ReportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UILabel *contentLab = [UILabel labelWithTitle:@"" font:14 textColor:Black_Color textAlignment:0];
    [self.contentView addSubview:contentLab];
    self.contentLab = contentLab;
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(0.8f);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
