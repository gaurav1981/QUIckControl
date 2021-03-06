//
//  QUIckControlValue.h
//  KDNControl
//
//  Created by Denis Koryttsev on 03/11/16.
//  Copyright © 2016 Denis Koryttsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QUICStateDescriptorKey.h"

@class QUICStateDescriptorKey;

@interface QUIckControlValue : NSObject

-(instancetype)initWithKey:(NSString*)key;
-(void)setValue:(id)value forInvertedState:(UIControlState)state;
-(void)setValue:(id)value forState:(UIControlState)state;
-(void)setValue:(id)value forIntersectedState:(UIControlState)state;

-(void)setValue:(id)value forStateDescriptor:(QUICStateDescriptor)descriptor;
-(id)valueForState:(UIControlState)state;

@end
