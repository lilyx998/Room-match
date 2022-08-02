//
//  Lib.m
//  Roommatch
//
//  Created by Lily Yang on 7/8/22.
//

#import "Utils.h"

@implementation Utils

+ (void)alertViewController:(UIViewController *)viewController WithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}


+ (NSDate *)getDateFrom_MM_dd_YYYY_String:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    return [dateFormatter dateFromString:string];
}

+ (NSDate *)getDateFrom_MM_dd_YYYY_HH_mm_ss_String:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    return [dateFormatter dateFromString:string];
}

@end
