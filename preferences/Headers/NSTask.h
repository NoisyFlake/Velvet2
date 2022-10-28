@interface NSTask : NSObject
@property (copy) NSArray * arguments;
@property (retain) id standardOutput; 
- (void)setLaunchPath:(NSString *)path;
- (void)launch;
- (void)waitUntilExit;
@end