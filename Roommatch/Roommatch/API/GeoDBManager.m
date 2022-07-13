//
//  GeoDBManager.m
//  Roommatch
//
//  Created by Lily Yang on 7/12/22.
//

#import "GeoDBManager.h"
#import "Items.h"


@interface RequestObject ()
@property (nonatomic, strong) NSString* incompleteString;
@property (nonatomic, strong) FetchCompletionBlock completionBlock;
@end

@implementation RequestObject
@end

@interface GeoDBManager ()
@property(strong,nonatomic) NSOperationQueue *fetchQueue;
@property RequestObject *requestDataObject;
@end

@implementation GeoDBManager

- (void)fetchSuggestionsForIncompleteString:(NSString*)incompleteString
                        withCompletionBlock:(FetchCompletionBlock)completion {
    NSMutableArray* items;
    NSArray* cities = [self APICall:incompleteString];
    for(NSString* city in cities){
        Items* item = [[Items alloc] init];
        item.title = city; 
        [items addObject:item];
    }
    
    completion(items, @"title");
}

- (NSArray *)APICall:(NSString*)prefix{
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    NSDictionary *headers = @{ @"X-RapidAPI-Key": [dict objectForKey: @"GeoDB Key"],
                               @"X-RapidAPI-Host": [dict objectForKey: @"GeoDB Host"] };

    NSString* URLString = [[@"https://wft-geo-db.p.rapidapi.com/v1/geo/cities?limit=10&countryIds=Q30&namePrefix=" stringByAppendingString:prefix] stringByAppendingString:@"&sort=-population&types=CITY"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSMutableArray* cityNames;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers   error:nil];
                                                        NSArray *cities = dataDictionary[@"data"];
                                                        
                                                        for(NSDictionary *city in cities){
                                                            NSString *cityString = [[city[@"city"] stringByAppendingString:@", "] stringByAppendingString:city[@"regionCode"]];
                                                            NSLog(@"%@", cityString);
                                                            [cityNames addObject:cityString];
                                                        }
                                                    }
                                                }];
    [dataTask resume];
    return cityNames;
}

@end
