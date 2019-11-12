//
//  ErrorReportCell.m
//


#import "ErrorReportCell.h"
#import "UILabel+Category.h"
#import "UIButton+Category.h"

@interface ErrorReportCell ()

@property (nonatomic,weak) UILabel *contentLab;
@property (nonatomic,weak) UIButton *selectBtn;

@end

@implementation ErrorReportCell

- (void)setModel:(ReportCellModel *)model {
    _model = model;
    self.contentLab.text = model.title;
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"ErrorReportCell";
    ErrorReportCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[ErrorReportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIButton *selectBtn = [UIButton buttonWithImage:Image_Named(@"reportUnSelectLogo") selectedImage:Image_Named(@"reportSelectLogo")];
    self.selectBtn = selectBtn;
    [self.contentView addSubview:selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(self.sizeW(40));
    }];
    
    UILabel *contentLab = [UILabel labelWithTitle:@"" font:14 textColor:Black_Color textAlignment:0];
    [self.contentView addSubview:contentLab];
    self.contentLab = contentLab;
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.selectBtn.mas_right);
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(0.8f);
    }];
    
    UIButton *coverBtn = [[UIButton alloc]init];
    coverBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [coverBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:coverBtn];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)selectAction {
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.selectBlock) {
        self.selectBlock(self.selectBtn.isSelected);
    }
}

@end
