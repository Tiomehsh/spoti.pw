// Labs: Spotify's flags for features it built and did not ship; every row forces one flag.
#import "Settings/SGModPage.h"
#import "Flags.h"

static UIViewController *martiniPage(void) {
    return [[SGModPage alloc] initWithTitle:@"AI Chat (Martini)" intro:SGRestartNote sections:@[
        SGSection(@"在主页", @[
            SGFlagRow(@"聊天入口", @"ios-home-evopage-impl.interactive_entrypoint_enabled"),
            SGFlagRow(@"后方 Martini", @"ios-home-evopage-impl.interactive_entrypoint_martini_enabled"),
            SGFlagRow(@"悬浮聊天", @"ios-home-evopage-impl.interactive_entrypoint_floating_chat_enabled"),
            SGFlagRow(@"麦克风", @"ios-home-evopage-impl.interactive_entrypoint_mic_enabled"),
            SGFlagRow(@"发光胶囊", @"ios-home-evopage-impl.interactive_entrypoint_pill_glow_enabled"),
        ]),
        SGSection(@"聊天", @[
            SGFlagRow(@"意图标签", @"ios-martini-floatingchat-impl.intent_pills_enabled"),
            SGFlagRow(@"思考状态", @"ios-martini-floatingchat-impl.thinking_states_enabled"),
            SGFlagRow(@"录音", @"ios-martini-floatingchat-impl.voice_recording_enabled"),
        ]),
        SGSection(@"在播放器中", @[
            SGFlagRow(@"聊天入口", @"ios-martini-npvcardprovider-impl.floating_chat_entry_point_enabled"),
        ]),
    ] footer:nil];
}

UIViewController *SGLabsPage(void) {
    return [[SGModPage alloc] initWithTitle:@"实验室" intro:@"Unreleased features; some do nothing on your version. Changes apply after you restart Spotify." sections:@[
        SGSection(nil, @[
            SGWithSymbol(SGPageRow(@"AI Chat (Martini)", ^UIViewController *{ return martiniPage(); }), @"bubble.left.and.bubble.right"),
        ]),
        SGSection(@"音乐库", @[
            SGFlagRow(@"来自文件 App 的本地文件", @"ios-feature-localfiles.documents_enabled"),
        ]),
        SGSection(@"主屏幕小组件", @[
            SGFlagRow(@"进度条", @"ios-widgets-widgetremoteconfig-impl.progress_bar_enabled"),
        ]),
        SGNotedSection(@"睡眠定时", @[
            SGFlagRow(@"淡出", @"ios-feature-sleeptimer.enable_fade_out"),
            SGFlagRow(@"一分钟选项", @"ios-feature-sleeptimer.enable_one_minute_option"),
            SGFlagRow(@"选项弹层", @"ios-feature-sleeptimer.use_options_sheet"),
        ], @"重设计界面中选项弹层始终开启。"),
        SGSection(@"播放器", @[
            SGFlagRow(@"封面上的贪吃蛇", @"ios-feature-cover-art-snake.enabled"),
        ]),
        SGSection(@"播客评论", @[
            SGFlagRow(@"评论卡片", @"ios-feature-comments.enable_comments_card"),
            SGFlagRow(@"置顶评论", @"ios-feature-comments.enable_pinned_comments"),
            SGFlagRow(@"多个反应", @"ios-feature-comments.enable_multi_reactions"),
        ]),
    ] footer:nil];
}
