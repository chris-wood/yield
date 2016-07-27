#include <arpa/inet.h>
#include <linux/if_packet.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <netinet/ether.h>

#define DST_ADDRESS_MAC0 0x00
#define DST_ADDRESS_MAC1 0x00
#define DST_ADDRESS_MAC2 0x00
#define DST_ADDRESS_MAC3 0x00
#define DST_ADDRESS_MAC4 0x00
#define DST_ADDRESS_MAC5 0x00

#define IF_NAME "eth0"

#define MTU_SIZE 1500

static int
_fillPacket(int bufferSize, char buffer[bufferSize], int offset)
{
    // XXX: load a wire-encoded interest into this packet

    buffer[offset++] = 0x00;
    buffer[offset++] = 0x01;
    buffer[offset++] = 0x02;
    buffer[offset++] = 0x03;

    return offset;
}

int
main(int argc, char *argv[])
{
	int packetSize = 0;
	char packetBuffer[MTU_SIZE];
	struct ether_header *eh = (struct ether_header *) packetBuffer;
	struct iphdr *iph = (struct iphdr *) (packetBuffer + sizeof(struct ether_header));
	struct sockaddr_ll linkLayerAddress;

	// Open the raw socket
    int sockfd = 0;
	if ((sockfd = socket(AF_PACKET, SOCK_RAW, IPPROTO_RAW)) == -1) {
        perror("Unable to create a raw socket.\n");
	    exit(-1);
	}

	// Get the interface index
    struct ifreq interfaceIndex;
	struct ifreq interfaceMAC;
	memset(&interfaceIndex, 0, sizeof(struct ifreq));
	strncpy(interfaceIndex.ifr_name, IF_NAME, IFNAMSIZ - 1);
	if (ioctl(sockfd, SIOCGIFINDEX, &interfaceIndex) < 0)
	    perror("SIOCGIFINDEX");

    // Get the interface MAC address
	memset(&interfaceMAC, 0, sizeof(struct ifreq));
	strncpy(interfaceMAC.ifr_name, IF_NAME, IFNAMSIZ-1);
	if (ioctl(sockfd, SIOCGIFHWADDR, &interfaceMAC) < 0)
	    perror("SIOCGIFHWADDR");


	// Initialize the Ethernet header with the source and destination MAC addresses
    memset(packetBuffer, 0, BUF_SIZ);
	eh->ether_shost[0] = ((uint8_t *)&interfaceMAC.ifr_hwaddr.sa_data)[0];
	eh->ether_shost[1] = ((uint8_t *)&interfaceMAC.ifr_hwaddr.sa_data)[1];
	eh->ether_shost[2] = ((uint8_t *)&interfaceMAC.ifr_hwaddr.sa_data)[2];
	eh->ether_shost[3] = ((uint8_t *)&interfaceMAC.ifr_hwaddr.sa_data)[3];
	eh->ether_shost[4] = ((uint8_t *)&interfaceMAC.ifr_hwaddr.sa_data)[4];
	eh->ether_shost[5] = ((uint8_t *)&interfaceMAC.ifr_hwaddr.sa_data)[5];
	eh->ether_dhost[0] = DST_ADDRESS_MAC0;
	eh->ether_dhost[1] = DST_ADDRESS_MAC1;
	eh->ether_dhost[2] = DST_ADDRESS_MAC2;
	eh->ether_dhost[3] = DST_ADDRESS_MAC3;
	eh->ether_dhost[4] = DST_ADDRESS_MAC4;
	eh->ether_dhost[5] = DST_ADDRESS_MAC5;

	// Fill in the Ethertype
	eh->ether_type = htons(ETH_P_IP);
	packetSize += sizeof(struct ether_header);

	// Put in the meat and potatoes
    packetSize = _fillPacket(MTU_SIZE, packetBuffer, packetSize);

	// Set the socket interface index
	linkLayerAddress.sll_ifindex = interfaceIndex.ifr_ifindex;

	// Set the length of the address field in the header
	linkLayerAddress.sll_halen = ETH_ALEN;

	// Set the link layer destination MAC address
	linkLayerAddress.sll_addr[0] = DST_ADDRESS_MAC0;
	linkLayerAddress.sll_addr[1] = DST_ADDRESS_MAC1;
	linkLayerAddress.sll_addr[2] = DST_ADDRESS_MAC2;
	linkLayerAddress.sll_addr[3] = DST_ADDRESS_MAC3;
	linkLayerAddress.sll_addr[4] = DST_ADDRESS_MAC4;
	linkLayerAddress.sll_addr[5] = DST_ADDRESS_MAC5;

	// Send the packet
	int numBytesSent = sendto(sockfd, packetBuffer, packetSize, 0, (struct sockaddr*) &linkLayerAddress, sizeof(struct sockaddr_ll));
    if (numBytesSent < 0) {
        printf("Send failed\n");
        exit(-1);
    }

    memset(packetBuffer, 0, MTU_SIZE);
    int destAddressLength = 0;
    int numBytesReceived = recvfrom(socketfd, packetBuffer, MTU_SIZE, 0, (struct sockaddr *) &linkLayerAddress, &destAddressLength);
    if (numBytesReceived < 0) {
        printf("Receive failed\n");
        exit(-1);
    }

    // XXX: display the packet

	return 0;
}
