@interface _LSQueryResult : NSObject
@end

@interface LSResourceProxy : _LSQueryResult
@property (setter=_setLocalizedName:,nonatomic,copy) NSString * localizedName;
@end

@interface LSBundleProxy : LSResourceProxy
@end

@interface LSApplicationProxy : LSBundleProxy
@property (nonatomic,readonly) NSString * applicationIdentifier;
@property (nonatomic,readonly) NSString * applicationType;
@property (nonatomic,readonly) NSArray * appTags;
@property (getter=isLaunchProhibited,nonatomic,readonly) BOOL launchProhibited;
@property (getter=isPlaceholder,nonatomic,readonly) BOOL placeholder;
@property (getter=isRemovedSystemApp,nonatomic,readonly) BOOL removedSystemApp;
@end

@interface LSApplicationWorkspace : NSObject
+(id)defaultWorkspace;
-(id)allInstalledApplications;
@end