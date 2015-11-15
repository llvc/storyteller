//
//  Config.h
//  storyteller
//
//  Created by Alin Hila on 8/16/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import "Logger.h"
#import "TopicList.h"
#import "ResponseVideoPhoto.h"
#import "HttpEngine.h"
#import "Topic.h"

//Logger, topic variables
extern Logger *logger;
extern TopicList *topicList;
extern ResponseVideoPhoto *responseVideoPhoto;
extern Topic *currentTopic;
extern int currentTab;

//loading page maintain time
#define LoadingPage_Last_Time       1.0

//set spin speed
#define SPIN_SPEED      100.0f

//view controller index
#define TabViewControllerIndex          2

//tabbar item index
#define TopicTabIndex                   0
#define FirstQuestionTabIndex           1
#define SecondQuestionTabIndex          2
#define ThirdQuestionTabIndex           3
#define UploadTabIndex                  4

//dark blue background
#define DarkBlue_Background_Color       [UIColor colorWithRed:52/255.0 green:120/255.0 blue:188/255.0 alpha:1]

//request urls
#define Login_Request               @"http://storyteller.projectworldimpact.com/apis/add_name.php"
#define Topic_Download_Request      @"http://storyteller.projectworldimpact.com/apis/select_ministry.php"
#define Uploading_Request_URL       @"http://storyteller.projectworldimpact.com/apis/question_awnser.php"
#define MINISTRY_URL                @"http://storyteller.projectworldimpact.com/apis/ministry_uploadcombined.php"

//#define Login_Request               @"http://192.168.1.31/storyteller/apis/add_name.php"
//#define Topic_Download_Request      @"http://192.168.1.31/storyteller/apis/select_ministry.php"
//#define Uploading_Request_URL       @"http://192.168.1.31/storyteller/apis/question_awnser.php"
//#define MINISTRY_URL                @"http://192.168.1.31/storyteller/apis/ministry_uploadcombined.php"

/*
 * response messages
 */

//common message
#define MESSAGE                          @"message"
#define SUCCESS                          @"success"

//login message
#define LOGIN_USER_ID                    @"user_id"

//topic message
#define TOPIC_STORY_DATA                 @"data"
#define TOPIC_STORY_DESCRIPTION          @"ministry_desc"
#define TOPIC_STORY_ID                   @"ministry_id"
#define TOPIC_STORY_TITLE                @"ministry_title"
#define TOPIC_QUESTION_ID                @"quesId"
#define TOPIC_QUESTION_DESCRIPTION       @"question"

//uploading success
#define PUBLIC_VIDEO_URL                 @"videourl"

/*
 *  request messages
 */
//uploading request
#define QUESTION_ID                     @"question_id"

//define notification
#define NFGOTOTABVIEW                    @"NF_Goto_TabView"
#define NFSELECTEDTAB                    @"NF_Selected_Tab"
#define NFGOTOVIEWCONTROLLER             @"NF_Goto_ViewController"
#define NFREFRESHRESPONSELIST            @"NF_Refresh_ResponseList"

/*
 * topic view controller
 */
#define TopicFontFamily                  @"Helvetica Neue"
#define TopicFontSize                    12
#define TopicFontColor                   [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1]

#define BrightWhiteBlue                  [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1]

#define NavBlackBG                       [UIColor colorWithRed:14/255.0 green:14/255.0 blue:11/255.0 alpha:1]

#define BlueBG                          [UIColor colorWithRed:52/255.0 green:115/255.0 blue:184/255.0 alpha:1]

#define TopicViewTitle                   @"SELECT"

extern BOOL passedTopicPage;

/*
 * first question view controller
 */
#define FirstQuestionViewTitle           @"QUESTION 1"

extern BOOL passedFirstQuestionPage;

/*
 * second question view controller
 */
#define SecondQuestionViewTitle           @"QUESTION 2"

extern BOOL passedSecondQuestionPage;

/*
 * first question view controller
 */
#define ThirdQuestionViewTitle           @"QUESTION 3"

extern BOOL passedThirdQuestionPage;

/*
 * first question view controller
 */
#define UploadViewTitle                  @"UPLOAD"
#define UPLOADING                        @"Uploading..."

extern BOOL passedUploadingPage;

/*
 *  share view controller
 */
#define ShareViewTitle                   @"SHARE"

/*
 * sender / receiver
 */
#define INCOMING                         @"incoming"
#define OUTCOMING                        @"outcoming"

/*
 * camera setting
 */

#define MAX_RECORDING_TIME               30

/*
 *  text view
 */
#define ResponseTextViewHeight               80
#define MESSAGE_TEXT_WIDTH_MAX               30
#define MESSAGE_TEXT_LENGTH                  150
#define kChatBarHeight1                      40
#define kChatBarHeight4                      80
#define TEXT_VIEW_X                          7   // 40  (with CameraButton)
#define TEXT_VIEW_Y                          2
//#define TEXT_VIEW_WIDTH                      249 // 216 (with CameraButton)
#define TEXT_VIEW_WIDTH                      messageInputBar.frame.size.width-5
#define TEXT_VIEW_HEIGHT_MIN                 90
#define MessageFontSize                      14

#define MESSAGE_TEXT_SIZE_WITH_FONT(message, font) \
[message sizeWithFont:font constrainedToSize:CGSizeMake(MESSAGE_TEXT_WIDTH_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping]

#define UIKeyboardNotificationsObserve() \
NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter]; \
[notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil]; \
[notificationCenter addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil]

#define UIKeyboardNotificationsUnobserve() \
[[NSNotificationCenter defaultCenter] removeObserver:self];

/*
 *  response type
 */
#define VideoResponse                   @"VideoResponse"
#define PhotoTextResponse               @"PhotoTextResponse"

/*
 * keyboard
 */
#define k_KEYBOARD_OFFSET 80.0
