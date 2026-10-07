// The Lyrics page's parts; App/Pages.m assembles the page.
#import "Core/SGCore.h"
#import "Settings/SGModPage.h"
#import "Lyrics.h"
#import "Shared/LockScreenLyrics/LockScreenLyrics.h"
#import "Shared/LyricsSources/LyricsSources.h"

SGModSection *SGLyricsSourcesSection(BOOL namingSource) {
    SGModRow *sources = SGPageRow(@"来源", ^UIViewController *{ return SGLyricsSourcesPage(); });
    sources.value = ^NSString *{
        NSMutableArray<NSString *> *names = [NSMutableArray array];
        for (NSString *key in SGLyricsOrder()) [names addObject:SGLyricsProviderFor(key).name];
        return names.count ? [names componentsJoinedByString:@", "] : @"Off";
    };
    NSMutableArray<SGModRow *> *rows = [NSMutableArray arrayWithObjects:sources,
        SGOptionRow(@"每首歌的歌词", @"即使 Spotify 没有", SGKeyLyricsAllTracks), nil];
    if (namingSource) [rows addObject:SGOptionRow(@"显示来源", nil, SGKeyLyricsCredit)];
    if (!SGLyricsEeveeReplaces()) return SGSection(@"来源", rows);
    return SGNotedSection(@"来源", rows, @"EeveeSpotify is replacing lyrics, so these sources stay off. To use them, "
                          "turn on Do Not Replace Lyrics in EeveeSpotify's lyrics settings and restart Spotify.");
}

SGModRow *SGLockScreenLyricsRow(void) {
    return SGOptionRow(@"锁屏歌词", @"当前行替代艺人名", SGKeyLockScreenLyrics);
}

SGModRow *SGLyricsTranslationLanguageRow(void) {
    SGModRow *row = SGChoiceRow(@"翻译语言", nil, SGKeyLyricsTranslationLanguage, SGLyricsTranslationLanguageNames(), 0);
    row.choiceFooter = @"当歌词自带翻译时使用。Any 显示第一条。";
    return row;
}

// Only the redesign's lyrics view sweeps words.
SGModRow *SGLyricsWordTimingRow(void) {
    return SGOptionRow(@"模拟逐字歌词", nil, SGKeyLyricsSimulateWords);
}
