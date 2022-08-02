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

@interface Utils : NSObject

+ (void)alertViewController:(UIViewController *)viewController WithMessage:(NSString *)message;

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

+ (NSDate *)getDateFrom_MM_dd_YYYY_String:(NSString *)string;

+ (NSDate *)getDateFrom_MM_dd_YYYY_HH_mm_ss_String:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
