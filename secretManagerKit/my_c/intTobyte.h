//
//  intTobyte.h
//  test_tool
//
//  Created by mac  on 2018/11/30.
//  Copyright © 2018年 mac . All rights reserved.
//

#ifndef intTobyte_h
#define intTobyte_h


#endif /* intTobyte_h */
#import<stdio.h>

Byte* intTobytes(unsigned int num){
    Byte* result = (Byte *)malloc(4);
    result[0] = (Byte)((num>>24) & 0xff);
    result[1] = (Byte)((num>>16) & 0xff);
    result[2] = (Byte)((num>>8) & 0xff);
    result[3] = (Byte)(num & 0xff);
    return result;
}
Byte* intArrayToByte(unsigned int* num){
    int len = sizeof(num) * 4;
    Byte* result = (Byte *)malloc(sizeof(num) * 4);
    for(int i = 0;i<len;i++){
        for(int j = 0;j<sizeof(num);j++){
            result[i * 4 + j] = (Byte)((num[i]>>(24-8*j)) & 0xff);
        }
    }
    return result;
}
