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

#include <stdio.h>
#include <stdlib.h>
#include "cf_stub.h"
int _p0_get_0(val_type * data, key_type key, val_type & val);
int _p0_get_0(val_type * data, key_type key, val_type & val)
{
  switch_to_next_partition(0);
  int start_seq[3];
  start_seq[0] = 0x00000300;
  start_seq[1] = 0x00010300;
  start_seq[2] = 0x00020000;
  cf_request_handle_t _p0_swinst_get_0_cmd;
  cf_send_i(&(_p0_swinst_get_0.cmd_get), start_seq, 3*sizeof(int), &_p0_swinst_get_0_cmd);
  cf_wait(_p0_swinst_get_0_cmd);

  cf_send_ref_i(&(_p0_swinst_get_0.data), &data, 40, &_p0_request_0);
  cf_send_i(&(_p0_swinst_get_0.key), &key, 4, &_p0_request_1);

  int _p0_get_0_v_return;
  cf_receive_i(&(_p0_swinst_get_0.val_r), &val, 4, &_p0_get_0_num_val_r, &_p0_request_2);
  cf_receive_i(&(_p0_swinst_get_0.ap_return), &_p0_get_0_v_return, 4, &_p0_get_0_num_ap_return, &_p0_request_3);

  cf_wait(_p0_request_0);
  cf_wait(_p0_request_1);
  cf_wait(_p0_request_2);
  cf_wait(_p0_request_3);
  return _p0_get_0_v_return;
}



#pragma SDS data zero_copy(data)
int set(val_type *data, key_type key, val_type val) {
	hash_type h;
	hash(key,h);
	assign_val(data[h], val);

	return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include "cf_stub.h"
int _p0_set_0(val_type * data, key_type key, val_type val);
int _p0_set_0(val_type * data, key_type key, val_type val)
{
  switch_to_next_partition(0);
  int start_seq[3];
  start_seq[0] = 0x00000700;
  start_seq[1] = 0x00010100;
  start_seq[2] = 0x00020000;
  cf_request_handle_t _p0_swinst_set_0_cmd;
  cf_send_i(&(_p0_swinst_set_0.cmd_set), start_seq, 3*sizeof(int), &_p0_swinst_set_0_cmd);
  cf_wait(_p0_swinst_set_0_cmd);

  cf_send_ref_i(&(_p0_swinst_set_0.data), &data, 40, &_p0_request_4);
  cf_send_i(&(_p0_swinst_set_0.key), &key, 4, &_p0_request_5);
  cf_send_i(&(_p0_swinst_set_0.val_r), &val, 4, &_p0_request_6);

  int _p0_set_0_v_return;
  cf_receive_i(&(_p0_swinst_set_0.ap_return), &_p0_set_0_v_return, 4, &_p0_set_0_num_ap_return, &_p0_request_7);

  cf_wait(_p0_request_4);
  cf_wait(_p0_request_5);
  cf_wait(_p0_request_6);
  cf_wait(_p0_request_7);
  return _p0_set_0_v_return;
}



/******************************************************/
int _p0_get_0(val_type * data, key_type key, val_type & val);
int _p0_set_0(val_type * data, key_type key, val_type val);
int main() {

	//initialize map
	val_type *data = (val_type *)sds_alloc(10*sizeof(val_type));
	memset(data,0,10*sizeof(val_type));

	val_type err;
	_p0_get_0(data,0,err);
	printf("err: %08X\n",err);

	for(unsigned i=0; i<10; i++) {
		_p0_set_0(data,i,i+1);
	}

	for(unsigned i=0; i<10; i++) {
		val_type val;
		_p0_get_0(data,i,val);
		printf("k: %d  v: %d\n",i,val);
	}

	sds_free(data);
}

