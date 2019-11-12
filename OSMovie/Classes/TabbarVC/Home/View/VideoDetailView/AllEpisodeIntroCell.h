//
//  AllEpisodeIntroCell.h
//


#import <UIKit/UIKit.h>

@interface AllEpisodeIntroCell : UITableViewCell

@property (nonatomic,strong) EpisodeIntroModel *model;

+(instancetype)cellForTableView:(UITableView*)tableView;

@end
