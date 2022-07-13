//
//  Lib.h
//  Roommatch
//
//  Created by Lily Yang on 7/8/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Lib : NSObject

+ (void)alertViewController:(UIViewController *)viewController WithMessage:(NSString *)message;

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END
