//
//  ARTRest+Private.h
//  ably-ios
//
//  Created by Jason Choy on 21/12/2014.
//  Copyright (c) 2014 Ably. All rights reserved.
//

#import "ARTRest.h"
#import "ARTHttp.h"

@protocol ARTEncoder;
@protocol ARTHTTPExecutor;

ART_ASSUME_NONNULL_BEGIN

/// ARTRest private methods that are used internally and for whitebox testing
@interface ARTRest ()

@property (nonatomic, strong, readonly) ARTClientOptions *options;
@property (readonly, strong, nonatomic) __GENERIC(id, ARTEncoder) defaultEncoder;
@property (readonly, strong, nonatomic) NSString *defaultEncoding; //Content-Type
@property (readonly, strong, nonatomic) NSDictionary *encoders;

@property (nonatomic, strong) id<ARTHTTPExecutor> httpExecutor;
@property (readonly, nonatomic, assign) Class channelClass;

@property (nonatomic, strong) NSURL *baseUrl;

@property (nonatomic, strong, readonly) ARTLog *logger;

// MARK: Not accessible by tests
@property (readonly, strong, nonatomic) ARTHttp *http;
@property (strong, nonatomic) ARTAuth *auth;
@property (readwrite, assign, nonatomic) int fallbackCount;

// MARK: ARTHTTPExecutor

- (void)executeRequest:(NSMutableURLRequest *)request completion:(ARTHttpRequestCallback)callback;

// MARK: Internal

- (void)executeRequest:(NSMutableURLRequest *)request withAuthOption:(ARTAuthentication)authOption completion:(ARTHttpRequestCallback)callback;

- (void)calculateAuthorization:(ARTAuthMethod)method completion:(void (^)(NSString *__art_nonnull authorization, NSError *__art_nullable error))callback;

- (id<ARTCancellable>)internetIsUp:(void (^)(bool isUp))cb;

@end

ART_ASSUME_NONNULL_END
