#ifndef _SDS_PORTINFO_H
#define _SDS_PORTINFO_H
/* File: C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/p0/.cf_work/portinfo.h */
#ifdef __cplusplus
extern "C" {
#endif

struct _p0_swblk_get {
  cf_port_send_t cmd_get;
  cf_port_send_t data;
  cf_port_send_t key;
  cf_port_receive_t val_r;
  cf_port_receive_t ap_return;
};

struct _p0_swblk_set {
  cf_port_send_t cmd_set;
  cf_port_send_t data;
  cf_port_send_t key;
  cf_port_send_t val_r;
  cf_port_receive_t ap_return;
};

extern struct _p0_swblk_get _p0_swinst_get_0;
extern struct _p0_swblk_set _p0_swinst_set_0;
void _p0_cf_framework_open(int);
void _p0_cf_framework_close(int);

#ifdef __cplusplus
};
#endif
#ifdef __cplusplus
extern "C" {
#endif
void switch_to_next_partition(int);
void init_first_partition();
void close_last_partition();
#ifdef __cplusplus
};
#endif /* extern "C" */
#endif /* _SDS_PORTINFO_H_ */
