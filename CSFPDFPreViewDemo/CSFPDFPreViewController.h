//
//  CSFPDFPreViewController.m
//  CiticsfFinanceApp
//
//  Created by hehaichi on 2020/6/8.
//  Copyright © 2020 CITICSF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSFPDFView : UIView

@property (assign, nonatomic) CGPDFDocumentRef pdfDocument;
@property (assign, nonatomic) long pageNO;
-(id)initWithFrame:(CGRect)frame atPage:(int)index withPDFDoc:(CGPDFDocumentRef) pdfDoc;
@end

@interface CSFPDFPreViewController : UIViewController
@property(nonatomic,copy)NSURL *srcURL;
@end


