
#include <stdio.h>
#include <string.h>
#include "sds_lib.h"
//#include "zc706_net.h"
#include "ethernet_if.h"
#include "ethernet_wrap.h"
#include "common.h"

/*
 * User configurable IP Address of the board
 */
char myIP[4] = {192,168,1,11};

/*
 * Fixed MAC address of the board.
 * If you wish to change this, you must also change the MAC address
 * 		in the file pf_init.c in the platform sources directory
 * 		(ie. zc706_net/src/standalone/sdk/src
 */
char myMAC[6] = {0x00, 0x0A, 0x35, 0x01, 0x02, 0x03};

/*
 * Internet Checksum computer
 * buf - pointer to data array
 * size - number of bytes in the array (not shorts, bytes)
 */
unsigned short checksum(unsigned short *buf, unsigned size) {
	unsigned long checksum=0;
	while(size >1) {
		unsigned short swap = *buf++;
		swap = (swap >> 8) | ((swap & 0xFF) << 8);
		checksum += swap;
		size -=sizeof(unsigned short);
	}
	if(size) {
		checksum += *(unsigned char*)buf;
	}
	checksum = (checksum >> 16) + (checksum & 0xffff);
	checksum += (checksum >>16);
	checksum = ~checksum;

	return (unsigned short)(checksum);
}

/*
 * ICMP ping protocol handler
 * packet - pointer to packet data
 * len - length of the packet in 32-bit words
 */
void ping_handler(unsigned char *packet, unsigned len) {
	unsigned *outbuf = (unsigned *) sds_alloc(BUF_SIZE * sizeof(unsigned));
	unsigned char *outpacket = (unsigned char *) outbuf;

	//copy packet
	memcpy(outbuf,packet,sizeof(unsigned)*len);

	//response packet
	//srcMAC = myMAC
	outpacket[6] = myMAC[5];
	outpacket[7] = myMAC[4];
	outpacket[8] = myMAC[3];
	outpacket[9] = myMAC[2];
	outpacket[10] = myMAC[1];
	outpacket[11] = myMAC[0];
	//destMAC = srcMAC
	outpacket[0] = packet[6];
	outpacket[1] = packet[7];
	outpacket[2] = packet[8];
	outpacket[3] = packet[9];
	outpacket[4] = packet[10];
	outpacket[5] = packet[11];
	//destIP = srcIP
	outpacket[30] = packet[26];
	outpacket[31] = packet[27];
	outpacket[32] = packet[28];
	outpacket[33] = packet[29];
	//srcIP = myIP
	outpacket[26] = myIP[0];
	outpacket[27] = myIP[1];
	outpacket[28] = myIP[2];
	outpacket[29] = myIP[3];
	//type = 0
	outpacket[34] = 0;
	//zero the header checksum
	outpacket[36] = 0;
	outpacket[37] = 0;
	//compute headere checksum
	unsigned short chksum = checksum((unsigned short*)&(outpacket[34]),len*4-34);

	//set new checksum
	outpacket[36] = (chksum >> 8) & 0xFF;
	outpacket[37] = (chksum & 0xFF);

	//send packet
	write_data_wrapper(outbuf,len);
	sds_free(outbuf);
}

/*
 * ARP protocol responder
 * packet - pointer to packet data
 * len - length of the packet in 32-bit words
 */
void arp_handler(unsigned char *packet, unsigned len) {
	unsigned *outbuf = (unsigned*) sds_alloc(BUF_SIZE * sizeof(unsigned));
	unsigned char *outpacket = (unsigned char *)outbuf;

	//copy packet
	memcpy(outbuf,packet,sizeof(unsigned)*len);

	//response packet
	outpacket[21] = 2; //opcode: response
	//destMAC = srcMAC
	outpacket[0] = packet[6];
	outpacket[1] = packet[7];
	outpacket[2] = packet[8];
	outpacket[3] = packet[9];
	outpacket[4] = packet[10];
	outpacket[5] = packet[11];
	//targetMAC = srcMAC
	outpacket[32] = packet[6];
	outpacket[33] = packet[7];
	outpacket[34] = packet[8];
	outpacket[35] = packet[9];
	outpacket[36] = packet[10];
	outpacket[37] = packet[11];
	//destIP = srcIP
	outpacket[38] = packet[28];
	outpacket[39] = packet[29];
	outpacket[40] = packet[30];
	outpacket[41] = packet[31];
	//srcIP = myIP
	outpacket[28] = myIP[0];
	outpacket[29] = myIP[1];
	outpacket[30] = myIP[2];
	outpacket[31] = myIP[3];
	//srcMAC = myMAC
	outpacket[6] = myMAC[5];
	outpacket[7] = myMAC[4];
	outpacket[8] = myMAC[3];
	outpacket[9] = myMAC[2];
	outpacket[10] = myMAC[1];
	outpacket[11] = myMAC[0];
	//senderMAC = myMAC
	outpacket[22] = myMAC[5];
	outpacket[23] = myMAC[4];
	outpacket[24] = myMAC[3];
	outpacket[25] = myMAC[2];
	outpacket[26] = myMAC[1];
	outpacket[27] = myMAC[0];

	//send packet
	write_data_wrapper(outbuf,len);
	sds_free(outbuf);
}

/*
 * Print out the packet
 * buf - pointer to packet data
 * len - lenght of the packet in 32-bit words
 */
void print_packet(unsigned *buf, unsigned len) {
	printf("Packet size is: %d\n\r",len);
	for (int i = 0; i < len; i++) {
		printf("packet data [%d] : %08X\n\r",i,buf[i]);
	}
}

/*
 * Read a packet and figure out what to do with it
 */
void packet_handler(unsigned char *packet, unsigned len) {
	//check packet type (ARP)
	if(packet[12] == 8 && packet[13] == 6) {
		//check opcode (Request)
		if(packet[20] == 0 && packet[21] == 1) {
			//check IP
			if(packet[38] == myIP[0] && packet[39] == myIP[1] &&
					packet[40] == myIP[2] && packet[41] == myIP[3]) {
				arp_handler(packet,len);
			}
		}
	}
	//check packet type (IP)
	else if(packet[12] == 8 && packet[13] == 0) {
		//check protocol (ICMP)
		if(packet[23] == 1) {
			//check type (echo - ping request)
			if(packet[34] == 8) {
				ping_handler(packet,len);
			}
		}
	}
}

int main() {
	unsigned *inbuf;
	inbuf = (unsigned*) sds_alloc(BUF_SIZE * sizeof(unsigned));

	printf("starting...\n\r");

	while(1) {
		//read one packet
		unsigned inlen=0;
		read_data_wrapper(inbuf,inlen);

		//handle the packet
		packet_handler((unsigned char *)inbuf,inlen);
	}

	sds_free(inbuf);

	printf("Done!\n\r");

	return 0;
}
