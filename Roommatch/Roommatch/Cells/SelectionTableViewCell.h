//
//  SelectionTableViewCell.h
//  Roommatch
//
//  Created by Lily Yang on 8/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

NS_ASSUME_NONNULL_END
