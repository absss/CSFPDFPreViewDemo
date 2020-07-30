//
//  CSFPDFPreViewController.m
//  CiticsfFinanceApp
//
//  Created by hehaichi on 2020/6/8.
//  Copyright © 2020 CITICSF. All rights reserved.
//

#import "CSFPDFPreViewController.h"

@implementation CSFPDFView

-(id)initWithFrame:(CGRect)frame atPage:(int)index withPDFDoc:(CGPDFDocumentRef) pdfDoc{
    self = [super initWithFrame:frame];
    self.pageNO = index;
    self.pdfDocument = pdfDoc;
    return self;
}

-(void)drawInContext:(CGContextRef)context atPageNo:(int)page_no{
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    if (self.pageNO == 0) {
        self.pageNO = 1;
    }
    CGPDFPageRef page = CGPDFDocumentGetPage(self.pdfDocument, self.pageNO);
    CGContextSaveGState(context);
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.bounds, 0, true);
    CGContextConcatCTM(context, pdfTransform);
    CGContextDrawPDFPage(context, page);
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext() atPageNo:(int)self.pageNO];
}

@end

@interface CSFPDFPreViewController ()<UIScrollViewDelegate>
{
    NSInteger pageSum;
    NSInteger index;
}
@property (strong, nonatomic) UIScrollView * containerView;
@property (strong, nonatomic) UIScrollView * contentView;
@property (strong, nonatomic) UIView * indexView;

@end

@implementation CSFPDFPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    self.containerView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [self.view addSubview:self.containerView];
    self.containerView.delegate = self;
    self.containerView.maximumZoomScale = 3;
    self.containerView.tag = 10;
    self.containerView.minimumZoomScale = 1;
    
    self.contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    self.contentView.delegate = self;
    self.contentView.tag = 20;
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.containerView addSubview:self.contentView];
    self.contentView.alwaysBounceVertical = NO;
    self.contentView.alwaysBounceHorizontal = NO;
    self.containerView.alwaysBounceVertical = NO;
    self.containerView.alwaysBounceHorizontal = NO;
    
    CFURLRef pdfURL;
    if ([self.srcURL.absoluteString hasPrefix:@"file://"]) {
        pdfURL = (__bridge CFURLRef)self.srcURL;
    }
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    CFRelease(pdfURL);
    
    pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
   
    self.contentView.contentSize = CGSizeMake(width, height*pageSum);
    for (int i = 0; i<pageSum; i++ ) {
        CSFPDFView *pdfView = [[CSFPDFView alloc]initWithFrame:CGRectMake(0, height*i, width, height) atPage:i+1 withPDFDoc:pdfDocument];
        pdfView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:pdfView];
    }
    
    self.indexView = [UIView new];
    self.indexView.hidden = YES;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView =  [[UIVisualEffectView alloc] initWithEffect:blur];
    [self.indexView addSubview:blurView];
    self.indexView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    blurView.frame = CGRectMake(0, 0, 66, 35);
    self.indexView.frame = CGRectMake(20, 20, 66, 35);
    [self.view addSubview:self.indexView];
    UILabel *label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = UIColor.grayColor;
    label.textAlignment = NSTextAlignmentCenter;
    self.indexView.layer.masksToBounds = YES;
    label.frame = blurView.frame;
    label.tag = 100;
    [self.indexView addSubview:label];
    self.indexView.layer.cornerRadius = 5;
    
   
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.contentView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 10) {
        return;
    }
    index = (int)((scrollView.contentOffset.y / scrollView.contentSize.height)*pageSum)+1;
    UILabel * label = [self.indexView viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%ld/%ld",(long)index,(long)pageSum];
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 10) {
        return;
    }
    self.indexView.hidden = NO;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 10) {
           return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.indexView.hidden = YES;
    });
}
@end
