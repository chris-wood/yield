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
