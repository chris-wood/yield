#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#include "sds_lib.h"

#include "common.h"
#include "repo.h"
#include "buffer.h"
#include "parser.h"
#include "yield.h"

//#include "zc706_net.h"
#include "ethernet_if.h"
#include "ethernet_wrap.h"


/*
 * User configurable IP Address of the board
 */
unsigned char myIP[4] = {192,168,1,11};

/*
 * Fixed MAC address of the board.
 * If you wish to change this, you must also change the MAC address
 * 		in the file pf_init.c in the platform sources directory
 * 		(ie. zc706_net/src/standalone/sdk/src
 */
unsigned char myMAC[6] = {0x00, 0x0A, 0x35, 0x01, 0x02, 0x03};

typedef enum {
	EtherType_IPv4 = 0x0800,
	EtherType_ARP  = 0x0806,
	EtherType_CCNx = 0x0801,
} EtherType;

#define MTU_SIZE 1500
#define CLEAR(X, Y) (memset(X, 0, Y * sizeof(unsigned)))

struct yield_state {
    EthernetFace *face;
    PacketRepo *repo;
    uint8_t inputBuffer[MTU_SIZE];
    uint8_t outputBuffer[MTU_SIZE];
};

YieldState *
yield_Create(EthernetFace *face, PacketRepo *repo)
{
    YieldState *state = (YieldState *) malloc(sizeof(YieldState));
    state->face = face;
    state->repo = repo;
    return state;
}

// Statically allocated output buffer
unsigned char outputBuffer[MTU_SIZE];

/*
 * Internet Checksum computer
 * buf - pointer to data array
 * size - number of bytes in the array (not shorts, bytes)
 */
unsigned short
checksum(unsigned short *buf, unsigned size)
{
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
void
ping_handler(uint8_t *packet, unsigned len, uint8_t *outpacket, unsigned *length)
{
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
    *length = 38;
}


/*
 * ARP protocol responder
 * packet - pointer to packet data
 * len - length of the packet in 32-bit words
 */
static void
arp_handler(unsigned char *packet, unsigned len, unsigned char *outpacket, unsigned *length)
{
	// Verify that this is a request
	if (len < 6 || !(packet[20] == 0 && packet[21] == 1)) {
		return;
	}

	// Verify that the target IP matches our IP
	if (len < 11 || !(packet[38] == myIP[0] && packet[39] == myIP[1] && packet[40] == myIP[2] && packet[41] == myIP[3])) {
		return;
	}

	// Copy the input packet
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

    // Save the output length
	*length = 42;
}

static void
ccnx_handler(PacketRepo *repo, unsigned char *inputBuffer, unsigned inputLength, unsigned char *outputBuffer, unsigned *outputLength)
{
	// fix to extract the name/keyid/hash
    int messageOffset = inputBuffer[7];
    unsigned char *messageBuffer = inputBuffer + messageOffset;
    int messageLength = inputLength - messageOffset;

	Buffer *key = parser_ReadName(messageBuffer, messageLength);
	Buffer *response = packetRepo_Lookup(repo, key, NULL);

	memcpy(outputBuffer, response->bytes, response->length);
	*outputLength = response->length;
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

int
yield_ServeNIC(YieldState *state)
{
	unsigned inputLength = 0;
    unsigned outputLength = 0;

    EthernetFace *face = state->face;
    PacketRepo *repo = state->repo;
    uint8_t *inputBuffer = state->inputBuffer;
    uint8_t *outputBuffer = state->outputBuffer;

	// Read a packet
    ethernet_Read(face, inputBuffer, &inputLength);

	bool toWrite = true;
	if (inputLength > 14) {
		// Handle the packet if we support the protocol.
		unsigned type = ((uint16_t) inputBuffer[12] << 8) | ((uint16_t) inputBuffer[13]);

		switch (type) {
		case EtherType_IPv4:
			ping_handler(inputBuffer, inputLength, outputBuffer, &outputLength);
			break;
		case EtherType_ARP:
			arp_handler(inputBuffer, inputLength, outputBuffer, &outputLength);
			break;
		case EtherType_CCNx:
			ccnx_handler(repo, inputBuffer + 14, inputLength - 14, outputBuffer, &outputLength);
			break;
        default:
			toWrite = false;
		}

        // Write the result
		if (toWrite) {
			ethernet_Write(face, outputBuffer, outputLength);
		} else {
			printf("Nothing written!\n");
		}
	}

	return 0;
}
