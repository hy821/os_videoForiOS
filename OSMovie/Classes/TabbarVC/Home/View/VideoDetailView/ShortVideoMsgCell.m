//
//  ShortVideoMsgCell.m
//



#import "ShortVideoMsgCell.h"
#import "UILabel+Category.h"
#import "VerticalButton.h"
#import "UIControl+recurClick.h"
#import "KSLayerAnimation.h"

@interface ShortVideoMsgCell ()

@property (nonatomic,weak) UILabel *nameLab;
@property (nonatomic,weak) UIImageView *iconIV;
@property (nonatomic,weak) UILabel *nickNameLab;
@property (nonatomic,weak) VerticalButton *collectBtn;

@end

@implementation ShortVideoMsgCell

- (void)setModel:(VDCommonModel *)model {
    _model = model;
    self.nameLab.text = model.name;
    self.nickNameLab.text = model.authors.firstObject.name;
    [self.iconIV sd_setImageWithURL:URL(model.authors.firstObject.displayUrl) placeholderImage:img_placeHolder options:SDWebImageRetryFailed];
    //是否收藏了
    self.collectBtn.selected = [model.collected integerValue];
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"ShortVideoMsgCell";
    ShortVideoMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[ShortVideoMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }return self;
}

- (void)createUI {
    self.contentView.backgroundColor = White_Color;
    UILabel *nameLab = [UILabel labelWithTitle:@"" font:20 textColor:Black_Color textAlignment:0];
    [nameLab setFont:Font_Bold(20)];
    nameLab.numberOfLines = 0;
    [self.contentView addSubview:nameLab];
    self.nameLab = nameLab;
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.sizeH(12));
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.nameLab.mas_bottom).offset(self.sizeH(10));
        make.height.equalTo(self.sizeH(0.8));
    }];
    
    UIImageView *iconIV = [[UIImageView alloc]init];
    iconIV.image = img_placeHolder;
    iconIV.contentMode = UIViewContentModeScaleAspectFill;
    iconIV.layer.masksToBounds = YES;
    [self.contentView addSubview:iconIV];
    self.iconIV = iconIV;
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(self.sizeH(10));
        make.left.equalTo(self.nameLab);
        make.width.height.equalTo(self.sizeH(30));
    }];
    
    UIImageView *coverIV = [[UIImageView alloc]init];
    coverIV.image = Image_Named(@"circleWhite");
    coverIV.contentMode = UIViewContentModeScaleAspectFill;
    coverIV.layer.masksToBounds = YES;
    [self.contentView addSubview:coverIV];
    [coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconIV);
    }];
    
    UILabel *nickNameLab = [UILabel labelWithTitle:@"" font:14 textColor:KCOLOR(@"#4A4A4A") textAlignment:0];
    [self.contentView addSubview:nickNameLab];
    self.nickNameLab = nickNameLab;
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconIV);
        make.left.equalTo(self.iconIV.mas_right).offset(self.sizeW(5));
    }];
    
    VerticalButton *collectBtn = [[VerticalButton alloc]init];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitle:@"收藏" forState:UIControlStateSelected];
    collectBtn.titleLabel.font = Font_Size(10);
    [collectBtn setTitleColor:KCOLOR(@"#81B0B6") forState:UIControlStateNormal];
    [collectBtn setTitleColor:KCOLOR(@"#81B0B6") forState:UIControlStateSelected];
    collectBtn.verticalMarge = 2.f;
    collectBtn.uxy_acceptEventInterval = 0.5f;
    [collectBtn setImage:Image_Named(@"ic_collect") forState:UIControlStateNormal];
    [collectBtn setImage:Image_Named(@"ic_choosecollect") forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:collectBtn];
    self.collectBtn = collectBtn;
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV);
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
        make.height.equalTo(self.sizeH(50));
    }];
}

- (void)collectAction:(VerticalButton *)sender {
    NSDictionary *dic = @{@"assetType" : self.model.type,
                          @"programId" : self.model.idForModel
                          };
    [USER_MANAGER videoCollectionWithPar:dic andIsCollection:!sender.isSelected success:^(id response) {
        sender.selected = !sender.selected;
        [KSLayerAnimation animationWithView:sender.imageView type:RotationAnimationLeftRight repeatCount:0 duration:0];
    } failure:^(NSString *errMsg) {
        SSMBToast(errMsg, MainWindow);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
