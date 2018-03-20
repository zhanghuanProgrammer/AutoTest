
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ViewHolderType) {
    ViewHolderTypeEvent,
    ViewHolderTypeScroll,
};

@interface ViewHolder : NSObject

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, assign) NSInteger layerIndex;
@property (nonatomic, assign) uint64_t superView;

@property (nonatomic, assign) ViewHolderType type;

- (instancetype)copyNew;

@end
