/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <objc/runtime.h>
#import "UIView+Yoga.h"
#import "YGLayout+Private.h"

static const void* kYGYogaAssociatedKey = &kYGYogaAssociatedKey;

@implementation UIView (YogaKit)
//
//+ (void)load {
//  static dispatch_once_t once;
//  dispatch_once(&once, ^{
//
//    void (^swizzle)(Class class, SEL originalSelector, SEL swizzledSelector) = ^(Class class, SEL originalSelector, SEL swizzledSelector) {
//      Method originalMethod = class_getInstanceMethod(class, originalSelector);
//      Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//
//      BOOL didAddInsertSubviewAtIndexMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//      if (didAddInsertSubviewAtIndexMethod) {
//        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//      } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//      }
//    };
//
//    Class class = [self class];
//
//    SEL oInsertSubviewAtIndexSelector = @selector(insertSubview:atIndex:);
//    SEL sInsertSubviewAtIndexSelector = @selector(yoga_insertSubview:atIndex:);
//    swizzle(class, oInsertSubviewAtIndexSelector, sInsertSubviewAtIndexSelector);
//
//    SEL oInsertSubviewAboveSubviewSelector = @selector(insertSubview:aboveSubview:);
//    SEL sInsertSubviewAboveSubviewSelector = @selector(yoga_insertSubview:aboveSubview:);
//    swizzle(class, oInsertSubviewAboveSubviewSelector, sInsertSubviewAboveSubviewSelector);
//
//    SEL oInsertSubviewBelowSubviewSelector = @selector(insertSubview:belowSubview:);
//    SEL sInsertSubviewBelowSubviewSelector = @selector(yoga_insertSubview:belowSubview:);
//    swizzle(class, oInsertSubviewBelowSubviewSelector, sInsertSubviewBelowSubviewSelector);
//
//    SEL oAddSubviewSelector = @selector(addSubview:);
//    SEL sAddSubviewSelector = @selector(yoga_addSubview:);
//    swizzle(class, oAddSubviewSelector, sAddSubviewSelector);
//
//    SEL oExchangeSubviewsSelector = @selector(exchangeSubviewAtIndex:withSubviewAtIndex:);
//    SEL sExchangeSubviewsSelector = @selector(yoga_exchangeSubviewAtIndex:withSubviewAtIndex:);
//    swizzle(class, oExchangeSubviewsSelector, sExchangeSubviewsSelector);
//
//    SEL oRemoveFromSuperviewSelector = @selector(removeFromSuperview);
//    SEL sRemoveFromSuperviewSelector = @selector(yoga_removeFromSuperview);
//    swizzle(class, oRemoveFromSuperviewSelector, sRemoveFromSuperviewSelector);
//
//  });
//}

// TODO currently we only set measure func on leaf nodes which is
// determined by whether the view's yoga is enabled, whether the
// view has children, and whether the view's children's yogas are
// enabled and included in layout (aka set on a view)
// It's unclear whether we need all of that complexity, it seems
// like we should be able to:
// 1. say all yoga nodes are part of layout and enabled
// 2. just determine if a node is a leaf by whether it
// has children nodes [done]

- (YGLayout*)yoga {
  YGLayout* yoga = objc_getAssociatedObject(self, kYGYogaAssociatedKey);
  if (!yoga) {
    yoga = [[YGLayout alloc] initWithView:self];
    objc_setAssociatedObject(
        self, kYGYogaAssociatedKey, yoga, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }

  return yoga;
}

- (void)setYoga:(YGLayout *)yoga {
//    if (self.yoga != nil) {
//      if (self.superview != nil) {
//        [self.superview.yoga insertChildLayout:yoga atIndex:[self.superview.subviews indexOfObject:self]];
//        [self.superview.yoga removeChildLayout:self.yoga];
//      }
//      [self.yoga reparentChildrenToNewParent:yoga];
//      self.yoga.view = nil;
//    }

    yoga.view = self;
    objc_setAssociatedObject(self, kYGYogaAssociatedKey, yoga, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//- (BOOL)isYogaEnabled {
//  return objc_getAssociatedObject(self, kYGYogaAssociatedKey) != nil;
//}
//
//- (void)configureLayoutWithBlock:(YGLayoutConfigurationBlock)block {
//  if (block != nil) {
//    block(self.yoga);
//  }
//}

//#pragma mark - Method Swizzling
//
//- (void)yoga_insertSubview:(UIView*)view atIndex:(NSInteger)index {
//  [self yoga_insertSubview:view atIndex:index];
//  
//  if (view != nil) {
//    [self.yoga insertChildLayout:view.yoga atIndex:index];
//  }
//}
//
//- (void)yoga_insertSubview:(UIView*)view aboveSubview:(UIView*)subview {
//  [self yoga_insertSubview:view aboveSubview:subview];
//  
//  if (view != nil && subview != nil) {
//    NSInteger indexOfSubview = [self.superview.subviews indexOfObject:subview];
//    [self.yoga insertChildLayout:view.yoga atIndex:indexOfSubview];
//  }
//}
//
//- (void)yoga_insertSubview:(UIView*)view belowSubview:(UIView*)subview {
//  [self yoga_insertSubview:view belowSubview:subview];
//  
//  if (view != nil && subview != nil) {
//    NSInteger indexOfSubview = [self.superview.subviews indexOfObject:subview];
//    [self.yoga insertChildLayout:view.yoga atIndex:indexOfSubview + 1];
//  }
//}
//
//- (void)yoga_addSubview:(UIView*)view {
//  [self yoga_addSubview:view];
//  if (view != nil) {
//    [self.yoga insertChildLayout:view.yoga atIndex:self.subviews.count - 1];
//  }
//}
//
//- (void)yoga_exchangeSubviewAtIndex:(NSInteger)index1
//                 withSubviewAtIndex:(NSInteger)index2
//{
//  [self.yoga exchangeChildLayoutAtIndex:index1 withLayoutAtIndex:index2];
//  [self yoga_exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
//}
//
//- (void)yoga_removeFromSuperview {
//  [self.superview.yoga removeChildLayout:self.yoga];
//  [self yoga_removeFromSuperview];
//}

@end
