#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include <openssl/evp.h>

#include "buffer.h"
#include "crypto.h"

struct crypto_context {
    EVP_CIPHER *cipher;
    EVP_CIPHER_CTX *ctx;

    // TODO: maybe this would go to a "session state" type somewhere?
    Buffer *key;
    Buffer *iv;
};

// From: http://stackoverflow.com/questions/12153009/openssl-c-example-of-aes-gcm-using-evp-interfaces
Buffer *encrypt(CryptoContext *context, Buffer *in)
{
	int howmany, dec_success, len;
	const EVP_CIPHER *cipher;
	switch(key_len)
	{
	    case 128: cipher  = EVP_aes_128_gcm ();break;
    	case 192: cipher  = EVP_aes_192_gcm ();break;
	    case 256: cipher  = EVP_aes_256_gcm ();break;
    	default:break;
	}
	// Encrypt
	EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
	EVP_EncryptInit (ctx, cipher, KEY, IV);
	EVP_EncryptUpdate (ctx, NULL, &howmany, AAD, aad_len);
	len = 0;
	while(len <= in_len-128)
	{
	   EVP_EncryptUpdate (ctx, CIPHERTEXT+len, &howmany, PLAINTEXT+len, 128);
	   len+=128;
	}
	EVP_EncryptUpdate (ctx, CIPHERTEXT+len, &howmany, PLAINTEXT+len, in_len - len);
	EVP_EncryptFinal (ctx, TAG, &howmany);
	EVP_CIPHER_CTX_ctrl (ctx, EVP_CTRL_GCM_GET_TAG, 16, TAG);
	EVP_CIPHER_CTX_free(ctx);
	// Decrypt
	ctx = EVP_CIPHER_CTX_new();
	EVP_DecryptInit (ctx, cipher, KEY, IV);
	EVP_CIPHER_CTX_ctrl (ctx, EVP_CTRL_GCM_SET_TAG, 16, ref_TAG);
	EVP_DecryptInit (ctx, NULL, KEY, IV);
	EVP_DecryptUpdate (ctx, NULL, &howmany, AAD, aad_len);
	len = 0;
	while(len <= in_len-128)
	{
	   EVP_DecryptUpdate (ctx, decrypted_CT+len, &howmany, CIPHERTEXT+len, 128);
	   len+=128;
	}
	EVP_DecryptUpdate (ctx, decrypted_CT+len, &howmany, CIPHERTEXT+len, in_len-len);
	dec_success = EVP_DecryptFinal (ctx, dec_TAG, &howmany);
	EVP_CIPHER_CTX_free(ctx);
}
