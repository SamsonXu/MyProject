//
//  Define.h
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#ifndef Define_h
#define Define_h

#pragma mark-----系统相关
#define KWS(ws) __weak typeof(self) ws = self
#define KScreenWidth   self.view.bounds.size.width
#define KScreenHeight self.view.bounds.size.height
#define KWidth self.frame.size.width
#define KHeight self.frame.size.height
#define KNavBarLeft @"navBarLeft"
#define KNavBarRight @"navBarRight"
#define KJPG @"%@.jpg"
#define KCellImage @"image"
#define KCellLeftTitle @"leftTitle"
#define KCellRightTitle @"rightTitle"
#define KBtnBack @"co_nav_back_btn"
#define KTrue @"true"
#define KFaults @"faults"
#define KJZLX @"jzlx"
#define KLogin @"login"
#define KWrong @"wrong"
#define KCollect @"collect"
#define KQuesBase @"quesBase"
#define KScores @"scores"
#define KUserName @"userName"
#define KUserHead @"userHead"
#define KUserSex @"userSex"
#define KUserJZ @"userJZ"
#define KUserProgress @"userProgress"
#define KUserJournal @"userJournal"
#define KTrueFaults @"trueOrFaults"
#define KCbData @"cbData"

#pragma mark-----网址相关
#define KUrlPost @"POST"
#define KUrlGet @"GET"
#define KUrlPut @"PUT"

//报名
#define KUrlXSYH @"http://api.51jiaxiao.com/GoodsDiscount/index"
#define KUrlSchool @"http://api.51jiaxiao.com/Driv/index"
#define KUrlXCJL @"http://api.51jiaxiao.com/Journal/getJournalCate"
#define KUrlTopicTP @"http://api.51jiaxiao.com/Journal/uploadIos"
#define KUrlTopicRecod @"http://api.51jiaxiao.com/Journal/getImgList"
#define KUrlTopicImgDel @"http://api.51jiaxiao.com/Journal/delImgUpload"
#define KUrlTopicType @"http://api.51jiaxiao.com/Journal/getJournalId"

#define KUrlTopicList @"http://api.51jiaxiao.com/Wenda/getTheUserWendaList"
#define KUrlFavAdd @"http://api.51jiaxiao.com/Journal/setWendaPraise"
#define KUrlFavDel @"http://api.51jiaxiao.com/Journal/removeWendaPraise"
#define KUrlTopicDetail1 @"http://api.51jiaxiao.com/Journal/getJournalShow"
#define KUrlTopicDetail2 @"http://api.51jiaxiao.com/Journal/getPraiseList"
#define KUrlTopicDetail3 @"http://api.51jiaxiao.com/Journal/getAnswerList"
#define KUrlTopicDetail4 @"http://api.51jiaxiao.com/Wenda/getAnswerList"
#define KUrlComment @"http://api.51jiaxiao.com/Journal/answer_insert"
#define KUrlCommentList @"http://api.51jiaxiao.com/Driv/getPinglunList"
#define KUrlClassList @"http://api.51jiaxiao.com/Driv/getkechengList"
#define KUrlCash @"http://api.51jiaxiao.com/RedPackets/index/"
#define KUrlCashList @"http://api.51jiaxiao.com/RedPackets/getRedPacketsList"
#define KUrlCashChange @"http://api.51jiaxiao.com/RedPackets/setExchange"
#define KUrlConsult0 @"http://api.51jiaxiao.com/Reg/get_sms_code"
#define KUrlConsult1 @"http://api.51jiaxiao.com/UserOrder/sendRegSms"
#define KUrlConsult2 @"http://api.51jiaxiao.com/UserOrder/checksms"
#define KUrlAdver1 @"http://api.51jiaxiao.com/Adv/index/id/"
#define KUrlApply1 @"http://api.51jiaxiao.com/Driv/bmlc"
#define KUrlApply2 @"http://api.51jiaxiao.com/Driv/xclc"
#define KUrlApply3 @"http://api.51jiaxiao.com/Driv/fwbz"
#define KUrlApply4 @"http://api.51jiaxiao.com/Driv/cjwt"
#define KUrlDriveDetail @"http://api.51jiaxiao.com/Driv/jianjie"
#define KUrlClassDetail @"http://api.51jiaxiao.com/Driv/kechenginfo"
#define KUrlPay1 @"http://api.51jiaxiao.com/UserOrder/addOrder"
#define KUrlPay2 @"http://api.51jiaxiao.com/UserOrder/addUserOrder"
#define KUrlPay3 @"http://api.51jiaxiao.com/UserOrder/getUserOrder"
#define KUrlOrderList @"http://api.51jiaxiao.com/UserOrder/getMyOrderList"

#define KUrlCity @"http://api.51jiaxiao.com/Area/index"
//登录注册
#define KUrlLogin @"http://api.51jiaxiao.com/Login/checkLogin"
#define KUrlRegist0 @"http://api.51jiaxiao.com/Reg/get_sms_code"
#define KUrlRegist1 @"http://api.51jiaxiao.com/Reg/sendRegSms"
#define KUrlRegist2 @"http://api.51jiaxiao.com/Reg/checkReg"
#define KUrlInfo @"http://api.51jiaxiao.com/User/get_user_info"
#define KUrlCode0 @"http://api.51jiaxiao.com/Reg/get_sms_code"
#define KUrlCode1 @"http://api.51jiaxiao.com/Login/sendRegSms"
#define KUrlCode2 @"http://api.51jiaxiao.com/Login/checkSmscode"
#define KUrlCode3 @"http://api.51jiaxiao.com/Login/passupdate"
#define KUrlTest2 @"http://api.51jiaxiao.com/Kemuer/video_list"
#define KUrlTest3 @"http://api.51jiaxiao.com/Kemusan/video_list"
#define KUrlAboutUs @"http://api.51jiaxiao.com/Hlep/about"
//个人
#define KUrlJournalPublish @"http://api.51jiaxiao.com/Journal/journal_insert"
//科目一
#define KUrlKGOne @"http://api.51jiaxiao.com/Exam/kaogui"
#define KUrlDTJQOne @"http://api.51jiaxiao.com/News/article_list/id/72/p/"
#define KUrlZKXZ @"http://api.51jiaxiao.com/Exam/zkxz"
#define KUrlYYKS @"http://api.51jiaxiao.com/Exam/yyks"
#define KUrlZXDT @""
#define KUrlZXZKQ @""
#define KUrlRank @"http://api.51jiaxiao.com/UserKsjl/index"
//科目二
#define KUrlKGTwo @"http://api.51jiaxiao.com/Kemuer/kqgl"
#define KUrlAQD @"http://api.51jiaxiao.com/Kemuer/anquandai"
#define KUrlDHKG @"http://api.51jiaxiao.com/Kemuer/dhkg"
#define KUrlFXP @"http://api.51jiaxiao.com/Kemuer/fxp"
#define KUrlLHQ @"http://api.51jiaxiao.com/Kemuer/lhq"
#define KUrlJSTB @"http://api.51jiaxiao.com/Kemuer/jstb"
#define KUrlZDTB @"http://api.51jiaxiao.com/Kemuer/zdtb"
#define KUrlZCZD @"http://api.51jiaxiao.com/Kemuer/zczd"
#define KUrlZYTZ @"http://api.51jiaxiao.com/Kemuer/zytz"
#define KUrlHSJ @"http://api.51jiaxiao.com/Kemuer/hsj"
#define KUrlJYJQKE @"http://api.51jiaxiao.com/Kemuer/jyjq"
#define KUrlDTJQTwo @"http://api.51jiaxiao.com/News/article_cate/id/15"
//科目三
#define KUrlKGThree @"http://api.51jiaxiao.com/Kemusan/ksbz"
#define KUrlCJPD @"http://api.51jiaxiao.com/Kemusan/cjpd"
#define KUrlDWCZ @"http://api.51jiaxiao.com/Kemusan/dwcz"
#define KUrlDG @"http://api.51jiaxiao.com/Kemusan/dg"
#define KUrlZX @"http://api.51jiaxiao.com/Kemusan/zhixing"
#define KUrlJYJQKS @"http://api.51jiaxiao.com/Kemusan/jyjq"
#define KUrlKSMJKS @"http://api.51jiaxiao.com/Kemusan/kcjy"
#define KUrlDTJQThree @"http://api.51jiaxiao.com/News/article_cate/id/16"
#define KUrlUpdateFace @"http://api.51jiaxiao.com/User/uploadIos"
#define KUrlUpdateCity @"http://api.51jiaxiao.com/User/setCity"
#define KUrlUpdateJZ @"http://api.51jiaxiao.com/User/setJiazhao"
#define KUrlUpdateSex @"http://api.51jiaxiao.com/User/setSex"
#define KUrlUpdateName @"http://api.51jiaxiao.com/User/setNickname"
//科目四
#define KUrlKGFour @"http://api.51jiaxiao.com/Safety/kaogui"
#define KUrlList @"http://api.51jiaxiao.com/News/article_list/id/"
#define KUrlDetail @"http://api.51jiaxiao.com/News/article_detail/id/"
//拿本后
#define KUrlNB1 @"http://api.51jiaxiao.com/Naben/ljzsjdd.html"
#define KUrlNB2 @"http://api.51jiaxiao.com/Naben/jzns.html"
#define KUrlNB3 @"http://api.51jiaxiao.com/Naben/jzysgs.html"
#define KUrlNB4 @"http://api.51jiaxiao.com/Naben/jzhz.html"
#define KUrlNB5 @"http://api.51jiaxiao.com/Naben/jzhz.html"
#define KUrlNB6 @"http://api.51jiaxiao.com/Naben/jzhz.html"
#define KUrlNB7 @"http://api.51jiaxiao.com/Naben/tcszysx.html"
#define KUrlNB8 @"http://api.51jiaxiao.com/News/article_list/id/12"
//驾考圈
#define KUrlRiderHeadList @"http://api.51jiaxiao.com/Wenda/getWendaUserList"
#define KUrlRiders @"http://api.51jiaxiao.com/Wenda/index"
#define KUrlRiderCate @"http://api.51jiaxiao.com/Wenda/getCateList"
#define KUrlTopicPublish @"http://api.51jiaxiao.com/Wenda/wenda_insert"
#define KUrlTopicDel @"http://api.51jiaxiao.com/Wenda/delwenda"
#define KUrlCommentDel @"http://api.51jiaxiao.com/Wenda/delAnswer"
#define KUrlCommentSecond @"http://api.51jiaxiao.com/Wenda/reply_insert"

#pragma mark-----界面相关
#define KColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define KColorRGB(r,g,b) KColorRGBA(r,g,b,1)

#define KColorSystem KColorRGB(19, 153, 229)

#define KGrayColor KColorRGB(241, 241, 241)

#define KMBProgressShow [MBProgressHUD showMessage:nil]
#define KMBProgressHide [MBProgressHUD hideHUD]
#endif
