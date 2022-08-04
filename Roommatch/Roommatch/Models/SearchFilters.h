//
//  SearchFilters.h
//  Roommatch
//
//  Created by Lily Yang on 8/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchFilters : NSObject

@property (nonatomic) BOOL from;
@property (nonatomic) BOOL to;
@property (nonatomic) BOOL before;
@property (nonatomic) BOOL after;

@property (strong, nonatomic) NSString * fromUsername;
@property (strong, nonatomic) NSString * toUsername;
@property (strong, nonatomic) NSDate * beforeDate;
@property (strong, nonatomic) NSDate * afterDate;

@end

NS_ASSUME_NONNULL_END
