#import "Settings/SGModPage.h"
#import "Privacy.h"

// Every switch here forces a flag Spotify ships on to off, so the titles name the hiding: on hides
// the thing, off is Spotify's own value.
static UIViewController *tipsPage(void) {
    return [[SGModPage alloc] initWithTitle:@"提示" intro:SGRestartNote sections:@[
        SGSection(@"减少干扰", @[
            SGFlagRow(@"减少干扰", @"ios-messaging-reduceinterventions-impl.enabled"),
        ]),
        SGSection(@"工具提示", @[
            SGKillRow(@"隐藏智能随机助手", @"ios-messaging-reduceinterventions-impl.enable_message_smart_shuffle_helper_tooltip"),
            SGKillRow(@"隐藏省流量提示", @"ios-feature-nowplayingbar.data_saver_tooltip"),
            SGKillRow(@"隐藏 AI 歌单创建提示", @"ios-messaging-reduceinterventions-impl.enable_message_your_library_ai_playlist_creation_tooltip"),
            SGKillRow(@"隐藏视频流探索提示", @"ios-messaging-reduceinterventions-impl.enable_message_watch_feed_entity_explorer_tooltip"),
            SGKillRow(@"隐藏账号切换提示", @"ios-messaging-reduceinterventions-impl.enable_message_account_switching_tooltip"),
            SGKillRow(@"隐藏演出通知提示", @"ios-messaging-reduceinterventions-impl.enable_message_live_events_concert_notifications_tooltip"),
            SGKillRow(@"隐藏现场活动提示", @"ios-messaging-reduceinterventions-impl.enable_message_live_events_event_entity_safe_tooltip"),
            SGKillRow(@"隐藏现场活动场地提示", @"ios-messaging-reduceinterventions-impl.enable_message_live_events_event_entity_venuename_header_tooltip"),
            SGKillRow(@"隐藏 Puffin 提醒", @"ios-messaging-reduceinterventions-impl.enable_message_puffin_nudge_end_optimization"),
        ]),
    ] footer:nil];
}

static SGModSection *countersSection(void) {
    NSMutableArray<SGModRow *> *counts = [NSMutableArray array];
    for (NSString *label in SGBlockedLabels()) {
        [counts addObject:SGStatRow(label, ^NSString *{
            return @(SGBlockedCount(label)).stringValue;
        })];
    }
    [counts addObject:SGStatRow(@"总计", ^NSString *{
        return @(SGBlockedCount(nil)).stringValue;
    })];
    [counts addObject:SGActionRow(@"重置遥测计数器", nil, ^{ SGResetBlocked(); })];
    return SGSection(@"已屏蔽遥测", counts);
}

// The switches first and what they have stopped last, so the counters bury no setting.
UIViewController *SGPrivacySettingsPage(void) {
    return [[SGModPage alloc] initWithTitle:@"隐私与杂乱" intro:SGRestartNote sections:@[
        SGSection(@"隐私", @[
            SGWithSymbol(SGSwitchRow(@"屏蔽遥测", @"Spotify's own events still go out, since Recents is built from them", SGKeyBlockTelemetry), @"antenna.radiowaves.left.and.right.slash"),
        ]),
        SGSection(@"杂乱元素", @[
            SGWithSymbol(SGOptionRow(@"隐藏搜索中的视频轮播", nil, SGKeyHideSearchVideos), @"play.rectangle.on.rectangle"),
            SGWithSymbol(SGOptionRow(@"隐藏搜索中的社交证明", nil, SGKeyHideSocialProof), @"person.2"),
            SGWithSymbol(SGPageRow(@"提示", ^UIViewController *{ return tipsPage(); }), @"lightbulb"),
        ]),
        countersSection(),
    ] footer:nil];
}
