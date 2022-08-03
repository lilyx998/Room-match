//
//  SearchMessagesFiltersViewController.h
//  Roommatch
//
//  Created by Lily Yang on 8/3/22.
//

#import <UIKit/UIKit.h>
#import "SearchFilters.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchMessagesFiltersViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *fromButton;
@property (weak, nonatomic) IBOutlet UIButton *toButton;
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet UIButton *beforeButton;
@property (weak, nonatomic) IBOutlet UIButton *afterButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *beforeDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *afterDatePicker;

@property (strong, nonatomic) SearchFilters *filters; 

@end

NS_ASSUME_NONNULL_END
