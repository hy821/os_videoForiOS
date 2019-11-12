//
//  SettingCell.m
//



#import "SettingCell.h"
#import "UILabel+Category.h"

@interface SettingCell()
@property (nonatomic,weak) UILabel *titleLab;
@property (nonatomic,weak) UILabel *subLab;
@property (nonatomic,weak) UISwitch *mainSwitch;
@property (nonatomic,weak) UIImageView *arrowIV;

@end

@implementation SettingCell

- (void)setModel:(SettingCellModel *)model {
    _model = model;
    
    self.titleLab.text = model.title;
    self.subLab.text = model.subTitle;
    [self.mainSwitch setOn:model.isSwitchOn];
    
    self.subLab.hidden = YES;
    self.mainSwitch.hidden = YES;
    self.arrowIV.hidden = YES;
    
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(model.isSubNoti ? self.sizeW(30) : self.sizeW(12));
    }];
    
    switch (model.type) {  // 1 无 任何sub     2 subTitle    3 箭头    4 switch
        case 1:
        {

        }
            break;
        case 2:
        {
            self.subLab.hidden = NO;
        }
            break;
        case 3:
        {
            self.arrowIV.hidden = NO;
        }
            break;
        case 4:
        {
            self.mainSwitch.hidden = NO;
        }
            break;
        default:
            break;
    }
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"SettingCell";
    SettingCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UILabel *titleLab = [UILabel labelWithTitle:@"" font:15 textColor:KCOLOR(@"#4A4A4A") textAlignment:0];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.centerY.equalTo(self.contentView);
    }];
    
    UIImageView *arrowIV = [[UIImageView alloc]initWithImage:Image_Named(@"ic_homepage_next")];
    self.arrowIV = arrowIV;
    [self.contentView addSubview:arrowIV];
    [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
        make.centerY.equalTo(self.contentView);
    }];
    
    UISwitch *s = [[UISwitch alloc]init];
    [s addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    self.mainSwitch = s;
    [self.contentView addSubview:s];
    [self.mainSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
        make.centerY.equalTo(self.contentView);
    }];
    
    UILabel *subLab = [UILabel labelWithTitle:@"" font:15 textColor:KCOLOR(@"#A99898") textAlignment:0];
    [self.contentView addSubview:subLab];
    self.subLab = subLab;
    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
        make.centerY.equalTo(self.contentView);
    }];
    
    self.subLab.hidden = YES;
    self.mainSwitch.hidden = YES;
    self.arrowIV.hidden = YES;
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(0.9f);
    }];
}

- (void)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if ([self.model.title containsString:@"移动网络播放视频"]) {
        if (isButtonOn) {
            [USERDEFAULTS setObject:@"1" forKey:CanSeeVideoNoWifi];
        }else {
            [USERDEFAULTS setObject:@"0" forKey:CanSeeVideoNoWifi];
        }
    }
    [USERDEFAULTS synchronize];
}

@end
