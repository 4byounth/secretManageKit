//
//  CKScep256k1.m
//  CKScep256k1
//
//  Created by caobo56 on 2017/8/17.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#import "CBSecp256k1.h"
#import <secp256k1/secp256k1.h>
#import <secp256k1/secp256k1_recovery.h>
#import "NSData+HexString.h"

static int secp256k1_ext_ecdsa_recover(    const secp256k1_context* ctx,    unsigned char *pubkey_out,    const unsigned char *sigdata,    const unsigned char *msgdata) {    secp256k1_ecdsa_recoverable_signature sig;    secp256k1_pubkey pubkey;
    if (!secp256k1_ecdsa_recoverable_signature_parse_compact(ctx, &sig, sigdata, (int)sigdata[64])) {        return 0;    }    if (!secp256k1_ecdsa_recover(ctx, &pubkey, &sig, msgdata)) {        return 0;    }    size_t outputlen = 65;    return secp256k1_ec_pubkey_serialize(ctx, pubkey_out, &outputlen, &pubkey, SECP256K1_EC_UNCOMPRESSED);}

@implementation CBSecp256k1
+ (NSData *)generatePublicKeyWithPrivateKey:(NSData *)privateKeyData compression:(BOOL)isCompression
{
    secp256k1_context *context = secp256k1_context_create(SECP256K1_CONTEXT_SIGN);
    
    const unsigned char *prvKey = (const unsigned char *)privateKeyData.bytes;
    secp256k1_pubkey pKey;
    
    int result = secp256k1_ec_pubkey_create(context, &pKey, prvKey);
    if (result != 1) {
        return nil;
    }
    
    int size = isCompression ? 33 : 65;
    unsigned char pubkey[65];
    size_t s = size;
    
    result = secp256k1_ec_pubkey_serialize(context, pubkey, &s, &pKey, isCompression ? SECP256K1_EC_COMPRESSED : SECP256K1_EC_UNCOMPRESSED);
    if (result != 1) {
        return nil;
    }
    
    secp256k1_context_destroy(context);
    
    NSMutableData *data = [NSMutableData dataWithBytes:pubkey length:size];
    return data;
}

+ (NSData *)compactSignData:(NSData *)msgData withPrivateKey:(NSData *)privateKeyData
{
    secp256k1_context *context = secp256k1_context_create(SECP256K1_CONTEXT_SIGN);
    
    const unsigned char *prvKey = (const unsigned char *)privateKeyData.bytes;
    const unsigned char *msg = (const unsigned char *)msgData.bytes;
    
    unsigned char *siga = malloc(64);
    secp256k1_ecdsa_signature sig;
    int result = secp256k1_ecdsa_sign(context, &sig, msg, prvKey, NULL, NULL);
    
    result = secp256k1_ecdsa_signature_serialize_compact(context, siga, &sig);
    
    if (result != 1) {
        return nil;
    }
    
    secp256k1_context_destroy(context);
    
    NSMutableData *data = [NSMutableData dataWithBytes:siga length:64];
    free(siga);
    return data;
}

+ (NSInteger)verifySignedData:(NSData *)sigData withMessageData:(NSData *)msgData usePublickKey:(NSData *)pubKeyData
{
    secp256k1_context *context = secp256k1_context_create(SECP256K1_CONTEXT_VERIFY | SECP256K1_CONTEXT_SIGN);
    
    const unsigned char *sig = (const unsigned char *)sigData.bytes;
    const unsigned char *msg = (const unsigned char *)msgData.bytes;
    
    const unsigned char *pubKey = (const unsigned char *)pubKeyData.bytes;
    
    secp256k1_pubkey pKey;
    int pubResult = secp256k1_ec_pubkey_parse(context, &pKey, pubKey, pubKeyData.length);
    if (pubResult != 1) return -3;
    
    secp256k1_ecdsa_signature sig_ecdsa;
    int sigResult = secp256k1_ecdsa_signature_parse_compact(context, &sig_ecdsa, sig);
    if (sigResult != 1) return -4;
    
    int result = secp256k1_ecdsa_verify(context, &sig_ecdsa, msg, &pKey);
    
    secp256k1_context_destroy(context);
    return result;
}

+ (NSData *)compactSignDataWithRecId:(NSData *)msgData withPrivateKey:(NSData *)privateKeyData
{
    secp256k1_context *context = secp256k1_context_create(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY);
    
    const unsigned char *prvKey = (const unsigned char *)privateKeyData.bytes;
    const unsigned char *msg = (const unsigned char *)msgData.bytes;
    
    if (secp256k1_ec_seckey_verify(context, prvKey) != 1)
    {
        secp256k1_context_destroy(context);
        return nil;
    }
    
    secp256k1_ecdsa_recoverable_signature sigstruct;
    if (secp256k1_ecdsa_sign_recoverable(context, &sigstruct, msg, prvKey, secp256k1_nonce_function_rfc6979, nil) == 0)
    {
        secp256k1_context_destroy(context);
        return nil;
    }
    char *siga = (char*)malloc(65);
    int recId;
    secp256k1_ecdsa_recoverable_signature_serialize_compact(context, siga, &recId, &sigstruct);
    siga[64] = (char)(recId&0xFF);
    secp256k1_context_destroy(context);
    
    NSMutableData *data = [NSMutableData dataWithBytes:siga length:65];
    free(siga);
    return data;
}

//+ (NSData *)verifySignedDataPublic:(NSData *)sigData withMessageData:(NSData *)msgData usePublickKey:(NSData *)pubKeyData
//{
//    secp256k1_context *context = secp256k1_context_create(SECP256K1_CONTEXT_VERIFY | SECP256K1_CONTEXT_SIGN);
//    
//    const unsigned char *sig = (const unsigned char *)sigData.bytes;
//    const unsigned char *msg = (const unsigned char *)msgData.bytes;
//    
//    const unsigned char *pubKey = (const unsigned char *)pubKeyData.bytes;
//    
//    secp256k1_pubkey pKey;
//    int pubResult = secp256k1_ec_pubkey_parse(context, &pKey, pubKey, pubKeyData.length);
//    if (pubResult != 1) return -3;
//    
//    secp256k1_ecdsa_signature sig_ecdsa;
//    int sigResult = secp256k1_ecdsa_signature_parse_compact(context, &sig_ecdsa, sig);
//    if (sigResult != 1) return -4;
//    
//    int result = secp256k1_ecdsa_verify(context, &sig_ecdsa, msg, &pKey);
//    
//    secp256k1_context_destroy(context);
//    return result;
//}
+(NSData *)recoverPubkey:(NSData *)msgData :(NSData *)sign {
    if(msgData.length != 32){
        return nil;
    }
    secp256k1_context *ctx;
    ctx = secp256k1_context_create(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY);
    
    unsigned char pubkey[65];
    if(secp256k1_ext_ecdsa_recover(ctx, pubkey, sign.bytes, msgData.bytes) == 0){
        secp256k1_context_destroy(ctx);
        return nil;
    }
    secp256k1_pubkey puk;
    size_t len = 65;
    unsigned char output[65];
    if(secp256k1_ec_pubkey_parse(ctx, &puk, pubkey, 65) != 1)
    {
        secp256k1_context_destroy(ctx);
        return nil;
    }
    secp256k1_ec_pubkey_serialize(ctx, output, &len, &puk, SECP256K1_EC_COMPRESSED);
    secp256k1_context_destroy(ctx);
    NSData *pk = [[NSData alloc] initWithBytes:output length:len];
    return pk;
}


@end
