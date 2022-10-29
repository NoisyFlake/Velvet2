@interface CALayer (Private)
@property (assign) BOOL continuousCorners; 
@end

@interface CAFilter : NSObject
+(id)filterWithName:(id)name;
@end