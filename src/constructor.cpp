
int pf_init();

void pf_constructor() __attribute__ ((constructor));

void pf_constructor() {

  pf_init();
}
