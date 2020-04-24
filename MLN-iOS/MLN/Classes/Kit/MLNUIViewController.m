//
//  MLNUIViewController.m
//  AFNetworking
//
//  Created by Dai Dongpeng on 2020/4/24.
//

#import "MLNUIViewController.h"
#import "MLNKitInstanceFactory.h"
#import "MLNExporter.h"
#import "MLNKitInstance.h"
#import "MLNLuaBundle.h"

@interface MLNUIViewController ()
@property (nonatomic, copy, readwrite) NSString *entryFileName;
@property (nonatomic, copy, readonly) NSDictionary *extraInfo;
@property (nonatomic, strong) NSBundle *bundle;
@end

@implementation MLNUIViewController

- (instancetype)initWithEntryFileName:(NSString *)entryFileName {
    return [self initWithEntryFileName:entryFileName bundle:[NSBundle mainBundle]];
}

- (instancetype)initWithEntryFileName:(NSString *)entryFileName bundle:(NSBundle *)bundle {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.entryFileName = entryFileName;
        self.bundle = bundle ?: [NSBundle mainBundle];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.kitInstance changeRootView:self.view];
    [self.kitInstance changeLuaBundle:[[MLNLuaBundle alloc] initWithBundle:self.bundle]];
    
    NSError *error = nil;
    BOOL ret = [self.kitInstance runWithMLNUIEntryFile:self.entryFileName windowExtra:self.extraInfo error:&error];
    if (ret) {
        if ([self.delegate respondsToSelector:@selector(viewController:didFinishRun:)]) {
            [self.delegate viewController:self didFinishRun:self.entryFileName];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(viewController:didFailRun:error:)]) {
            [self.delegate viewController:self didFailRun:self.entryFileName error:error];
        }
    }
}

- (BOOL)regClasses:(NSArray<Class<MLNExportProtocol>> *)registerClasses {
    return [self.kitInstance registerClasses:registerClasses error:NULL];
}

- (MLNKitInstance *)kitInstance {
    if (!_kitInstance) {
        _kitInstance = [[MLNKitInstanceFactory defaultFactory] createKitInstanceWithViewController:self];
    }
    return _kitInstance;
}

@end
