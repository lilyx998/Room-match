//
//  CityTableViewCell.h
//  Roommatch
//
//  Created by Lily Yang on 7/14/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

NS_ASSUME_NONNULL_END
