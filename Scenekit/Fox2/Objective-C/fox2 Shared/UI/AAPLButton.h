/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Custom `SKNode` based button.
*/

#import <SpriteKit/SpriteKit.h>



@interface AAPLButton : SKNode {
    void (*_action)(id, SEL);
}

+ (AAPLButton*)buttonWithText:(NSString*)txt;
+ (AAPLButton*)buttonWithSKNode:(SKNode*)node;

@property (readonly) CGFloat width;

- (void)setText:(NSString*)txt;
- (void)setBackgroundColor:(SKColor*)col;

- (void)setClickedTarget:(id)target action:(SEL)action;

@end
