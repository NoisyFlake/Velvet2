@interface CALayer (Private)
@property (assign) BOOL continuousCorners; 
@end

@interface CAFilter : NSObject
@property (copy) NSString * name;
@property (getter=isEnabled) BOOL enabled;
+(id)filterWithName:(id)name;
@end