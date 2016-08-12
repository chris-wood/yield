#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "sds_lib.h"

#include "repo.h"
#include "buffer.h"
#include "parser.h"

#include "zc706_net.h"
#include "ethernet_if.h"
#include "ethernet_wrap.h"

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

typedef enum {
	EtherType_IPv4 = 0x0800,
	EtherType_ARP  = 0x0806,
	EtherType_CCNx = 0x0801,
} EtherType;

#define MTU_SIZE 1500
#define CLEAR(X, Y) (memset(X, 0, Y * sizeof(unsigned)))

// Statically allocated output buffer
unsigned char outputBuffer[MTU_SIZE];

static int
_protocolHandler_CCNx_Process(PacketRepo *repo, int length, uint8_t inputBuffer[MTU_SIZE], uint8_t outputBuffer[MTU_SIZE])
{
	printf("Packet size is: %d\n\r", length);
	for (int i = 0; i < length; i++) {
		printf("packet data [%d] : %02x\n\r", i, inputBuffer[i]);
	}

	// fix to extract the name/keyid/hash
	Buffer *key = _readName(inputBuffer, length);
	Buffer *response = packetRepo_Lookup(repo, key, NULL);

	memcpy(outputBuffer, response->bytes, response->length);
	return response->length;
}

/*
 * Internet Checksum computer
 * buf - pointer to data array
 * size - number of bytes in the array (not shorts, bytes)
 */
unsigned short checksum(unsigned short *buf, unsigned size) {
	unsigned long checksum=0;
	while (size > 1) {
		unsigned short swap = *buf++;
		swap = (swap >> 8) | ((swap & 0xFF) << 8);
		checksum += swap;
		size -= sizeof(unsigned short);
	}

	if (size) {
		checksum += *(unsigned char*) buf;
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
void ping_handler(unsigned char *packet, unsigned len, unsigned char *outpacket) {
	// Check protocol (ICMP)
	if (len < 6 || !(packet[23] == 1)) {
		return;
	}

	// Check type (echo - ping request)
	if (len < 10 || !(packet[34] == 8)) {
		return;
	}

	//copy packet
	memcpy(outpacket,packet,sizeof(unsigned)*len);

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
	write_data_wrapper((unsigned*)outpacket,len);
}


/*
 * ARP protocol responder
 * packet - pointer to packet data
 * len - length of the packet in 32-bit words
 */
static void 
arp_handler(unsigned char *packet, unsigned len, unsigned char *outpacket)
{
	// Verify that this is a request
	if (len < 6 || !(packet[20] == 0 && packet[21] == 1)) {
		return;
	}

	// Verify that the target IP matches our IP
	if (len < 11 || !(packet[38] == myIP[0] && packet[39] == myIP[1] && packet[40] == myIP[2] && packet[41] == myIP[3])) {
		return;
	}

	// Generate and return a response
	// Copy packet
	memcpy(outpacket,packet,sizeof(unsigned)*len);

	// Response packet
	outpacket[21] = 2; //opcode: response

	// destMAC = srcMAC
	outpacket[0] = packet[6];
	outpacket[1] = packet[7];
	outpacket[2] = packet[8];
	outpacket[3] = packet[9];
	outpacket[4] = packet[10];
	outpacket[5] = packet[11];
	// targetMAC = srcMAC
	outpacket[32] = packet[6];
	outpacket[33] = packet[7];
	outpacket[34] = packet[8];
	outpacket[35] = packet[9];
	outpacket[36] = packet[10];
	outpacket[37] = packet[11];
	// destIP = srcIP
	outpacket[38] = packet[28];
	outpacket[39] = packet[29];
	outpacket[40] = packet[30];
	outpacket[41] = packet[31];
	// srcIP = myIP
	outpacket[28] = myIP[0];
	outpacket[29] = myIP[1];
	outpacket[30] = myIP[2];
	outpacket[31] = myIP[3];
	// srcMAC = myMAC
	outpacket[6] = myMAC[5];
	outpacket[7] = myMAC[4];
	outpacket[8] = myMAC[3];
	outpacket[9] = myMAC[2];
	outpacket[10] = myMAC[1];
	outpacket[11] = myMAC[0];
	// senderMAC = myMAC
	outpacket[22] = myMAC[5];
	outpacket[23] = myMAC[4];
	outpacket[24] = myMAC[3];
	outpacket[25] = myMAC[2];
	outpacket[26] = myMAC[1];
	outpacket[27] = myMAC[0];

	// send packet
	write_data_wrapper((unsigned*)outpacket,len);
}

static void
ccnx_handler(PacketRepo *repo, unsigned char *inputBuffer, unsigned length)
{
	// Process the packet
	length = _protocolHandler_CCNx_Process(repo, length, inputBuffer, outputBuffer);
	if (length > 0 && length <= MTU_SIZE) {
		// Write the result
		write_data_wrapper((unsigned*) outputBuffer, length / 4);
		CLEAR(outputBuffer, MTU_SIZE);
	}
}

/*
 * Print out the packet
 * buf - pointer to packet data
 * len - lenght of the packet in 32-bit words
 */
void print_packet(unsigned *buf, unsigned len) {
	printf("Packet size is: %d\n\r",len);
	for(int i=0; i<len; i++) {
		printf("packet data [%d] : %08X\n\r",i,buf[i]);
	}
}

static EtherType
_packetHandler_GetEtherType(unsigned char *packet, unsigned length)
{
	uint16_t word = ((uint16_t) packet[12] << 8) | ((uint16_t) packet[13]);
	return (EtherType) word;
}

static int
_serveNIC(PacketRepo *repo, uint8_t *packet, uint8_t *outputBuffer)
{
	unsigned length = 0;

	for (;;) {
		// Read a packet
		read_data_wrapper((unsigned*)packet, length);

		if(length > 14) {
			// Handle the packet if we support the protocol.
			unsigned type = ((uint16_t) packet[12] << 8) | ((uint16_t) packet[13]);
			printf("type is: %08x\n\r",type);
			switch (type) {
			case EtherType_IPv4:
				ping_handler(packet, length, outputBuffer);
				break;
			case EtherType_ARP:
				arp_handler(packet, length, outputBuffer);
				break;
			case EtherType_CCNx:
				ccnx_handler(repo, packet, length);
				break;
			}
		}
	}

	return 0;
}


int
main(int argc, char **argv)
{
	printf("Starting the forwarder,\n\r");

	uint8_t *packet = (uint8_t *) sds_alloc(MTU_SIZE * sizeof(uint8_t));
	uint8_t *outputBuffer = (uint8_t *) sds_alloc(MTU_SIZE * sizeof(uint8_t));

	// Create the repo
	PacketRepo *repo = packetRepo_LoadFromFile("test_data.bin");
	printf("Repo initialized\n\r");

	// Start serving packets
	_serveNIC(repo,packet,outputBuffer);

	sds_free(packet);
	sds_free(outputBuffer);
}
