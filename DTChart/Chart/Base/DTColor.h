//
//  DTColor.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/15.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#ifndef DTColor_h
#define DTColor_h

#pragma mark - 颜色列表

// 绿
#define DTColorGreen DTRGBColor(0xABC900, 1)
// 浅绿
#define DTColorGreenLight DTRGBColor(0x94AC09, 1)
#define DTColorGreen60 DTRGBColor(0xABC900, 1)

// 蓝
#define DTColorBlue DTRGBColor(0x0095D9, 1)
// 蓝
#define DTColorBlueLight DTRGBColor(0x0982B9, 1)


// 紫色
#define DTColorPurple DTRGBColor(0x772F6D, 1)
// 紫色
#define DTColorPurpleLight DTRGBColor(0xC43168, 1)


// 洋红
#define DTColorMagenta DTRGBColor(0xE73275, 1)
// 洋红
#define DTColorMagentaLight DTRGBColor(0x692F61, 1)


// 黄
#define DTColorYellow DTRGBColor(0xFFE200, 1)
// 黄
#define DTColorYellowLight DTRGBColor(0xD8C009, 1)


// 橘
#define DTColorOrange DTRGBColor(0xFF5234, 1)
// 橘
#define DTColorOrangeLight DTRGBColor(0xD84C33, 1)

// 蓝
#define DTColorDarkBlue DTRGBColor(0x004898, 1)
// 蓝
#define DTColorDarkBlueLight DTRGBColor(0x094384, 1)


// 深绿
#define DTColorDarkGreen DTRGBColor(0x008E74, 1)
// 深绿
#define DTColorDarkGreenLight DTRGBColor(0x097C67, 1)


// 红
#define DTColorRed DTRGBColor(0xD72500, 1)
// 红
#define DTColorRedLight DTRGBColor(0xB72709, 1)


// 青
#define DTColorCyan DTRGBColor(0x5AC2D9, 1)
// 青
#define DTColorCyanLight DTRGBColor(0x52A6B9, 1)


// 灰
#define DTColorGray DTRGBColor(0xC0C0C0, 1)
// 灰
#define DTColorGrayLight DTRGBColor(0xA5A5A5, 1)


// 粉色
#define DTColorPink DTRGBColor(0xE761A4, 1)
// 粉色
#define DTColorPinkLight DTRGBColor(0xC4578E, 1)


#define DTColorArray  @[DTColorGreen, DTColorBlue, DTColorPurple, DTColorMagenta, DTColorYellow, DTColorOrange, DTColorDarkBlue, DTColorDarkGreen, DTColorRed, DTColorCyan, DTColorGray, DTColorPink]
#define DTLightColorArray  @[DTColorGreenLight, DTColorBlueLight, DTColorPurpleLight, DTColorMagentaLight, DTColorYellowLight, DTColorOrangeLight, DTColorDarkBlueLight, DTColorDarkGreenLight, DTColorRedLight, DTColorCyanLight, DTColorGrayLight, DTColorPinkLight]


#pragma mark - DTDistributionChart的颜色

/** 程度最低 */
#define DTDistributionLowLevelColor DTRGBColor(0x01081a, 1)
/** 程度中等 */
#define DTDistributionMiddleLevelColor DTRGBColor(0x014898, 1)
/** 程度高 */
#define DTDistributionHighLevelColor DTRGBColor(0x0095d9, 1)
/** 程度最高 */
#define DTDistributionSupremeLevelColor DTRGBColor(0x5ac3d9, 1)


#endif /* DTColor_h */
