/*
 * main.cpp
 *
 *  Created on: Feb 1, 2016
 *      Author: sskalick
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "sds_lib.h"

typedef unsigned key_type;

typedef unsigned hash_type;

typedef unsigned val_type;


/******************************************************/
//update as value type gets more complex
void assign_val(val_type &dest, val_type src) {
	dest = src;
}

void hash(key_type key, hash_type &h) {
	h = key;
}

/******************************************************/
#pragma SDS data zero_copy(data)
int get(val_type *data, key_type key, val_type &val) {
	hash_type h;
	hash(key,h);
	assign_val(val, data[h]);

	return 0;
}

#pragma SDS data zero_copy(data)
int set(val_type *data, key_type key, val_type val) {
	hash_type h;
	hash(key,h);
	assign_val(data[h], val);

	return 0;
}

/******************************************************/
int main() {

	//initialize map
	val_type *data = (val_type *)sds_alloc(10*sizeof(val_type));
	memset(data,0,10*sizeof(val_type));

	val_type err;
	get(data,0,err);
	printf("err: %08X\n",err);

	for(unsigned i=0; i<10; i++) {
		set(data,i,i+1);
	}

	for(unsigned i=0; i<10; i++) {
		val_type val;
		get(data,i,val);
		printf("k: %d  v: %d\n",i,val);
	}

	sds_free(data);
}

