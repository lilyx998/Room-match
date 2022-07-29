//
//  MessagesViewController.h
//  Roommatch
//
//  Created by Lily Yang on 7/26/22.
//

#import <UIKit/UIKit.h>
#import "Chat.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessagesViewController : UIViewController

@property (strong, nonatomic) Chat *chat;

@end

NS_ASSUME_NONNULL_END
