//
//  ViewController.m
//  BarcodeScanner
//
//  Created by Sureshkumar Linganathan on 10/03/17.
//  Copyright © 2017 Impiger Technologies. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)setupView
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    self.session = [[AVCaptureSession alloc]init];
    [_session addInput:deviceInput];
    AVCaptureMetadataOutput *captureOutput = [[AVCaptureMetadataOutput alloc]init];
    [self.session addOutput:captureOutput];
    [captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    NSArray *barCodeTypes = [[NSArray alloc]initWithObjects:AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeDataMatrixCode, nil];
    [captureOutput setMetadataObjectTypes:barCodeTypes];
    _previewPlayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    [_previewPlayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_previewPlayer setFrame:self.view.frame];
    [self.view.layer addSublayer:_previewPlayer];
    [_session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection;
{
    if((metadataObjects == nil)||([metadataObjects count]==0))
    {
        printf("no barcode detect");
        return;
    }
    AVMetadataMachineReadableCodeObject *object = [metadataObjects objectAtIndex:0];
    NSLog(@"%@",object.type);
    NSLog(@"%@",object.stringValue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
