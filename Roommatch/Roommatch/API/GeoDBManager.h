//
//  GeoDBManager.h
//  Roommatch
//
//  Created by Lily Yang on 7/12/22.
//

#import <Foundation/Foundation.h>
@import AutoCompletion;

@interface RequestObject : NSObject

@end

NS_ASSUME_NONNULL_BEGIN

@interface GeoDBManager : NSObject<AutoCompletionTextFieldDataSource>

- (void)fetchSuggestionsForIncompleteString:(NSString*)incompleteString
                        withCompletionBlock:(FetchCompletionBlock)completion;

- (NSArray *)APICall:(NSString*)prefix;

@end

NS_ASSUME_NONNULL_END
