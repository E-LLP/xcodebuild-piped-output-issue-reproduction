//
//  ARTPresenceMap.m
//  ably
//
//  Created by vic on 25/05/2015.
//  Copyright (c) 2015 Ably. All rights reserved.
//

#import "ARTPresenceMap.h"
#import "ARTPresenceMessage.h"

@interface ARTPresenceMap ()

@property (readwrite, strong, atomic) __GENERIC(NSMutableDictionary, NSString *, ARTPresenceMessage *) *mostRecentMessageForMember;
@property (readonly, nonatomic, assign) bool syncStarted;
@property (readonly, nonatomic, assign) bool syncComplete;
@property (nonatomic, copy) VoidCb cb;

@end

@implementation ARTPresenceMap

- (id)init {
    self = [super init];
    if(self) {
        _mostRecentMessageForMember = [NSMutableDictionary dictionary];
        _syncStarted = false;
        _syncComplete = false;
        _cb = nil;
    }
    return self;
}

- (__GENERIC(NSDictionary, NSString *, ARTPresenceMessage *) *)getMembers {
    return self.mostRecentMessageForMember;
}

- (void)onSync:(VoidCb)cb {
    _cb = cb;
}

- (void)syncMessageProcessed {
    if(self.cb) {
        self.cb();
    }
}

- (ARTPresenceMessage *)getClient:(NSString *) clientId {
    return [self.mostRecentMessageForMember objectForKey:clientId];
}

- (void)put:(ARTPresenceMessage *) message {
    ARTPresenceMessage * latest = [self.mostRecentMessageForMember objectForKey:message.clientId];
    if(!latest || latest.timestamp < message.timestamp) {
        [self.mostRecentMessageForMember setObject:message forKey:message.clientId];
    }
}

- (void)startSync {
    self.mostRecentMessageForMember = [NSMutableDictionary dictionary];
    _syncStarted = true;
}

- (void)endSync {
    NSArray * keys = [self.mostRecentMessageForMember allKeys];
    for(NSString * key in keys) {
        ARTPresenceMessage * message = [self.mostRecentMessageForMember objectForKey:key];
        if(message.action == ARTPresenceAbsent || message.action == ARTPresenceLeave) {
            [self.mostRecentMessageForMember removeObjectForKey:key];
        }
    }
    _syncComplete = true;
}

- (BOOL)isSyncComplete {
    return self.syncStarted && self.syncComplete;
}

- (BOOL) stillSyncing {
    return self.syncStarted && ! self.syncComplete;
}

#pragma mark private

- (NSString *)memberKey:(ARTPresenceMessage *) message {
    return [NSString stringWithFormat:@"%@:%@", message.connectionId, message.clientId];
}

@end
