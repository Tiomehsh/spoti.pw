// Mod Settings > Karaoke, in the redesign (App/ModSettings.x puts its row on the main page): Sing's switch and
// its voice model. The switch puts the microphone in the player's lyrics and takes it away again at once; off, Sing
// does no work at all. The model row reads out where the download is and moves along with it, over a bar
// while it runs, and the row under it is what can be done next: download it, stop the download, or remove
// the model. Below iOS 27, where the separator cannot run, the section is one row saying so.
#import <UIKit/UIKit.h>
#import "Core/SGCore.h"
#import "Settings/SGModPage.h"
#import "Settings/SGPageStyle.h"
#import "Shared/Sing/SGSingController.h"
#import "Shared/Sing/SGSingModel.h"
#import "Sing.h"

// The model's size as the footer and the prompts say it, to the nearest ten megabytes.
static NSString *aboutSize(void) {
    return [NSString stringWithFormat:@"about %lld MB", ((SGSingModelSize() >> 20) + 5) / 10 * 10];
}

static NSString *footer(void) {
    return [NSString stringWithFormat:@"Sing turns the vocals of the song playing down to sing over, from the microphone in its lyrics. "
            "It works on iOS 27 only. Its voice model, %@, is downloaded once and runs only on this iPhone. "
            "The switch and the download apply straight away.", aboutSize()];
}

static void tell(NSString *title, NSString *message) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [SGTopController() presentViewController:alert animated:YES completion:nil];
}

static NSString *modelStatus(void) {
    int64_t received = SGSingModelReceived(), size = SGSingModelSize();
    switch (SGSingModelCurrentState()) {
        case SGSingModelInstalled: return [@"Downloaded · " stringByAppendingString:SGSingModelBytesText(size)];
        case SGSingModelChecking: return @"Checking…";
        case SGSingModelDownloading:
            return [NSString stringWithFormat:@"Downloading %lld %% · %lld of %@", received * 100 / size,
                    (received + (1ll << 19)) >> 20, SGSingModelBytesText(size)];
        case SGSingModelMissing:
            if (SGSingModelFailure()) return @"下载失败";
            if (received > 0) return [NSString stringWithFormat:@"Paused · %lld of %@", (received + (1ll << 19)) >> 20, SGSingModelBytesText(size)];
            return @"未下载";
    }
    return nil;
}

// A tap on the model row says what its value is short for.
static void explainModel(void) {
    NSString *failure = SGSingModelFailure();
    switch (SGSingModelCurrentState()) {
        case SGSingModelInstalled:
            tell(@"人声模型", [NSString stringWithFormat:@"It takes %@ on this iPhone. Remove it to free the space; Sing is unavailable without it.",
                                  SGSingModelBytesText(SGSingModelSize())]);
            break;
        case SGSingModelMissing:
            tell(failure ? @"下载失败" : @"人声模型",
                 failure ? [failure stringByAppendingString:@" Download goes on from where it stopped."]
                         : [NSString stringWithFormat:@"Sing needs its voice model, %@, before its microphone shows in the lyrics.", aboutSize()]);
            break;
        default:
            tell(@"人声模型", @"The download goes on while Spotify is in the background. Sing's microphone shows in the lyrics once it is in.");
    }
}

// Enough room first, then the network: nothing leaves on cellular without a yes.
static void startDownload(void) {
    NSString *space = SGSingModelSpaceProblem();
    if (space) { tell(@"空间不足", space); return; }
    SGSingModelCheckNetwork(^(SGSingModelNetwork network) {
        if (network == SGSingModelOffline) {
            tell(@"无网络连接", @"连接 Wi-Fi 以下载 Sing 人声模型。");
        } else if (network == SGSingModelMetered) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"使用蜂窝网络下载?"
                message:[NSString stringWithFormat:@"This iPhone isn't on Wi-Fi, and Sing's voice model is %@.", aboutSize()]
                preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                SGSingModelDownload(YES);
            }]];
            [SGTopController() presentViewController:alert animated:YES completion:nil];
        } else {
            SGSingModelDownload(NO);
        }
    });
}

static void confirmRemove(void) {
    BOOL installed = SGSingModelCurrentState() == SGSingModelInstalled;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"移除人声模型?"
        message:installed ? [NSString stringWithFormat:@"Sing is unavailable until it is downloaded again (%@).", aboutSize()]
                          : [NSString stringWithFormat:@"The %@ downloaded so far are deleted, and the next download starts over.",
                             SGSingModelBytesText(SGSingModelReceived())]
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"移除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        SGSingModelRemove();
    }]];
    [SGTopController() presentViewController:alert animated:YES completion:nil];
}

// Below iOS 27 the switch is a row saying what is missing.
static SGModRow *unavailableRow(void) {
    return SGStatActionRow(@"Sing", nil, ^NSString *{ return @"需要 iOS 27"; }, ^{
        tell(@"Sing", [NSString stringWithFormat:@"Sing separates a song's vocals on this iPhone with a voice model that needs iOS 27. "
                       "This iPhone runs iOS %@.", UIDevice.currentDevice.systemVersion]);
    });
}

static SGModSection *karaokeSection(void) {
    if (!SGSingSupported()) return SGNotedSection(@"卡拉OK", @[unavailableRow()], footer());
    SGModRow *sing = SGOptionRow(@"Sing", @"歌词中的麦克风", SGRKeySing);
    sing.changed = ^(BOOL on) { SGRSingApplySwitch(); };

    SGModRow *model = SGStatActionRow(@"人声模型", nil, ^NSString *{ return modelStatus(); }, ^{ explainModel(); });
    model.progress = ^double {
        return SGSingModelCurrentState() == SGSingModelDownloading ? (double)SGSingModelReceived() / SGSingModelSize() : -1;
    };
    model.refreshOn = SGSingModelDidChangeNotification;

    SGModRow *download = SGActionRow(@"下载人声模型", nil, ^{ startDownload(); });
    download.visible = ^BOOL { return SGSingModelCurrentState() == SGSingModelMissing; };
    SGModRow *cancel = SGActionRow(@"取消下载", nil, ^{ SGSingModelCancel(); });
    cancel.visible = ^BOOL {
        SGSingModelState state = SGSingModelCurrentState();
        return state == SGSingModelDownloading || state == SGSingModelChecking;
    };
    // Removing also takes what a stopped download kept, which can be most of the model.
    SGModRow *remove = SGActionRow(@"移除人声模型", nil, ^{ confirmRemove(); });
    remove.color = SGRed();
    remove.visible = ^BOOL {
        SGSingModelState state = SGSingModelCurrentState();
        return state == SGSingModelInstalled || (state == SGSingModelMissing && SGSingModelReceived() > 0);
    };
    return SGNotedSection(@"卡拉OK", @[sing, model, download, cancel, remove], footer());
}

UIViewController *SGRKaraokeSettingsPage(void) {
    return [[SGModPage alloc] initWithTitle:@"卡拉OK" intro:nil sections:@[karaokeSection()] footer:nil];
}

// Beside the main page's row: what Sing would do now, or how far its model has come.
NSString *SGRKaraokeSummary(void) {
    if (!SGSingSupported()) return @"需要 iOS 27";
    SGSingModelState state = SGSingModelCurrentState();
    if (state == SGSingModelDownloading) return [NSString stringWithFormat:@"%lld %%", SGSingModelReceived() * 100 / SGSingModelSize()];
    if (state == SGSingModelChecking) return @"Checking…";
    if (!SGFlag(SGRKeySing, NO)) return @"Off";
    return state == SGSingModelInstalled ? @"On" : @"无模型";
}
