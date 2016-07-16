 /*
 * @f ccnl-core-fwd.c
 * @b CCN lite, the collection of suite specific forwarding logics
 *
 * Copyright (C) 2011-15, Christian Tschudin, University of Basel
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * File history:
 * 2014-11-05 collected from the various fwd-XXX.c files
 */

// returning 0 if packet was
int
ccnl_fwd_handleContent(struct ccnl_relay_s *relay, struct ccnl_face_s *from,
                       struct ccnl_pkt_s **pkt)
{
    struct ccnl_content_s *c;

    char *s = NULL;
#ifdef USE_NFN
    DEBUGMSG_CFWD(INFO, "  incoming data=<%s>%s (nfnflags=%d) from=%s\n",
                  (s = ccnl_prefix_to_path((*pkt)->pfx)),
                  ccnl_suite2str((*pkt)->suite),
                  (*pkt)->pfx->nfnflags,
                  ccnl_addr2ascii(from ? &from->peer : NULL));
    DEBUGMSG_CFWD(INFO, "data %.*s\n", (*pkt)->contlen, (*pkt)->content);
#else
    DEBUGMSG_CFWD(INFO, "  incoming data=<%s>%s from=%s\n",
                  (s = ccnl_prefix_to_path((*pkt)->pfx)),
                  ccnl_suite2str((*pkt)->suite),
                  ccnl_addr2ascii(from ? &from->peer : NULL));
#endif
    ccnl_free(s);

#if defined(USE_SUITE_CCNB) && defined(USE_SIGNATURES)
//  FIXME: mgmt messages for NDN and other suites?
        if (pkt->pfx->compcnt == 2 && !memcmp(pkt->pfx->comp[0], "ccnx", 4)
                && !memcmp(pkt->pfx->comp[1], "crypto", 6) &&
                from == relay->crypto_face) {
            return ccnl_crypto(relay, pkt->buf, pkt->pfx, from);
        }
#endif /* USE_SUITE_CCNB && USE_SIGNATURES*/

    // CONFORM: Step 1:
    for (c = relay->contents; c; c = c->next) {
        if (buf_equal(c->pkt->buf, (*pkt)->buf)) {
            DEBUGMSG_CFWD(TRACE, "  content is duplicate, ignoring\n");
            return 0; // content is dup, do nothing
        }
    }

    c = ccnl_content_new(relay, pkt);
    DEBUGMSG_CFWD(INFO, "data after creating packet %.*s\n", c->pkt->contlen, c->pkt->content);
    if (!c)
        return 0;

     // CONFORM: Step 2 (and 3)
#ifdef USE_NFN
    if (ccnl_nfnprefix_isNFN(c->pkt->pfx)) {
        if (ccnl_nfn_RX_result(relay, from, c))
            return 0;
        DEBUGMSG_CFWD(VERBOSE, "no running computation found \n");
    }
#endif
    if (!ccnl_content_serve_pending(relay, c)) { // unsolicited content
        // CONFORM: "A node MUST NOT forward unsolicited data [...]"
        DEBUGMSG_CFWD(DEBUG, "  removed because no matching interest\n");
        free_content(c);
        return 0;
    }
    if (relay->max_cache_entries != 0) { // it's set to -1 or a limit
        DEBUGMSG_CFWD(DEBUG, "  adding content to cache\n");
        if (ccnl_content_add2cache(relay, c) == NULL) {
            DEBUGMSG_CFWD(WARNING, "  adding to cache failed, discard packet\n");
            free_content(c);
            return 0;
        }
    	DEBUGMSG_CFWD(INFO, "data after creating packet %.*s\n", c->pkt->contlen, c->pkt->content);
    } else {
        DEBUGMSG_CFWD(DEBUG, "  content not added to cache\n");
        free_content(c);
    }
#ifdef USE_RONR
    /* if we receive a chunk, we assume more chunks of this content may be
     * retrieved along the same path */
    if ((c->pkt->pfx->chunknum) && (*(c->pkt->pfx->chunknum) >= 0)) {
        struct ccnl_prefix_s *pfx_wo_chunk = ccnl_prefix_dup(c->pkt->pfx);
        pfx_wo_chunk->compcnt--;
        ccnl_free(pfx_wo_chunk->chunknum);
        pfx_wo_chunk->chunknum = NULL;
        ccnl_fib_add_entry(relay, pfx_wo_chunk, from);
    }
#endif
    return 0;
}

#ifdef USE_FRAG
// returning 0 if packet was
int
ccnl_fwd_handleFragment(struct ccnl_relay_s *relay, struct ccnl_face_s *from,
                        struct ccnl_pkt_s **pkt, dispatchFct callback)
{
    unsigned char *data = (*pkt)->content;
    int datalen = (*pkt)->contlen;

    DEBUGMSG_CFWD(INFO, "  incoming fragment (%zd bytes) from=%s\n",
                  (*pkt)->buf->datalen,
                  ccnl_addr2ascii(from ? &from->peer : NULL));

    ccnl_frag_RX_BeginEnd2015(callback, relay, from,
                              relay->ifs[from->ifndx].mtu,
                              ((*pkt)->flags >> 2) & 0x03,
                              (*pkt)->val.seqno, &data, &datalen);

    free_packet(*pkt);
    *pkt = NULL;
    return 0;
}
#endif

// ----------------------------------------------------------------------
// returns 0 if packet should not be forwarded further
int
ccnl_pkt_fwdOK(struct ccnl_pkt_s *pkt)
{
    switch (pkt->suite) {
#ifdef USE_SUITE_IOTTLV
    case CCNL_SUITE_IOTTLV:
        return pkt->s.iottlv.ttl < 0 || pkt->s.iottlv.ttl > 0;
#endif
#ifdef USE_SUITE_NDNTLV
    case CCNL_SUITE_NDNTLV:
        return pkt->s.ndntlv.scope > 2;
#endif
    default:
        break;
    }

    return -1;
}

int
ccnl_fwd_handleInterest(struct ccnl_relay_s *relay, struct ccnl_face_s *from,
                        struct ccnl_pkt_s **pkt, cMatchFct cMatch)
{
    struct ccnl_interest_s *i;
    struct ccnl_content_s *c;

    char *s = NULL;
    DEBUGMSG_CFWD(INFO, "  incoming interest=<%s>%s from=%s\n",
                  (s = ccnl_prefix_to_path((*pkt)->pfx)),
                  ccnl_suite2str((*pkt)->suite),
                  ccnl_addr2ascii(from ? &from->peer : NULL));
    ccnl_free(s);

#ifdef USE_DUP_CHECK
    if (ccnl_nonce_isDup(relay, *pkt)) {
        DEBUGMSG_CFWD(DEBUG, "  dropped because of duplicate nonce\n");
        return 0;
    }
#endif

    if (local_producer(relay, from, *pkt)) {
        *pkt = NULL;
        return 0;
    }

#ifdef USE_SUITE_CCNB
    if ((*pkt)->suite == CCNL_SUITE_CCNB && (*pkt)->pfx->compcnt == 4 &&
                                  !memcmp((*pkt)->pfx->comp[0], "ccnx", 4)) {
        DEBUGMSG_CFWD(INFO, "  found a mgmt message\n");
        ccnl_mgmt(relay, (*pkt)->buf, (*pkt)->pfx, from); // use return value?
        return 0;
    }
#endif
    // Step 1: search in content store
    DEBUGMSG_CFWD(DEBUG, "  searching in CS\n");

    for (c = relay->contents; c; c = c->next) {
        if (c->pkt->pfx->suite != (*pkt)->pfx->suite)
            continue;
        if (cMatch(*pkt, c))
            continue;

        DEBUGMSG_CFWD(DEBUG, "  found matching content %p\n", (void *) c);
        if (from->ifndx >= 0) {
            ccnl_nfn_monitor(relay, from, c->pkt->pfx, c->pkt->content,
                             c->pkt->contlen);
            ccnl_face_enqueue(relay, from, buf_dup(c->pkt->buf));
        } else {
            ccnl_app_RX(relay, c);
        }
        return 0; // we are done
    }

    // CONFORM: Step 2: check whether interest is already known
#ifdef USE_KITE
    if ((*pkt)->tracing) { // is a tracing interest
        for (i = relay->pit; i; i = i->next) {
        }
    }
#endif
    for (i = relay->pit; i; i = i->next)
        if (ccnl_interest_isSame(i, *pkt))
            break;

    if (!i) { // this is a new/unknown I request: create and propagate
#ifdef USE_NFN
        if (ccnl_nfn_RX_request(relay, from, pkt))
            return -1; // this means: everything is ok and pkt was consumed
#endif
    }
    if (!ccnl_pkt_fwdOK(*pkt))
        return -1;
    if (!i) {
        i = ccnl_interest_new(relay, from, pkt);

    char *s = NULL;
#ifdef USE_NFN
        DEBUGMSG_CFWD(DEBUG,
                      "  created new interest entry %p (prefix=%s, nfnflags=%d)\n",
                      (void *) i,
                      (s = ccnl_prefix_to_path(i->pkt->pfx)),
                      i->pkt->pfx->nfnflags);
#else
        DEBUGMSG_CFWD(DEBUG,
                      "  created new interest entry %p (prefix=%s)\n",
                      (void *) i, (s = ccnl_prefix_to_path(i->pkt->pfx)));
#endif
    ccnl_free(s);
    }
    if (i) { // store the I request, for the incoming face (Step 3)
        DEBUGMSG_CFWD(DEBUG, "  appending interest entry %p\n", (void *) i);
        ccnl_interest_append_pending(i, from);
        ccnl_interest_propagate(relay, i);
    }

    /*
    if (!i) { // this is a new/unknown I request: create and propagate
#ifdef USE_NFN
        if (ccnl_nfn_RX_request(relay, from, pkt))
            return -1; // this means: everything is ok and pkt was consumed
#endif
<<<<<<< HEAD
        if (!ccnl_pkt_fwdOK(*pkt))
            return -1;
        i = ccnl_interest_new(relay, from, pkt);
        DEBUGMSG_CFWD(DEBUG,
            "  created new interest entry %p\n", (void *) i);
        ccnl_interest_propagate(relay, i);
    } else {
        if (ccnl_pkt_fwdOK(*pkt) && (from->flags & CCNL_FACE_FLAGS_FWDALLI)) {
            DEBUGMSG_CFWD(DEBUG, "  old interest, nevertheless propagated %p\n",
                     (void *) i);
            ccnl_interest_propagate(relay, i);
=======
        if (!i) {
            i = ccnl_interest_new(ccnl, from, CCNL_SUITE_CCNB,
                                  &buf, &p, minsfx, maxsfx);
            if (ppkd)
                i->details.ccnb.ppkd = ppkd, ppkd = NULL;
            if (i) { // CONFORM: Step 3 (and 4)
                DEBUGMSG_CFWD(DEBUG, "  created new interest entry %p\n", (void *)i);
                if (scope > 2)
                    ccnl_interest_propagate(ccnl, i);
            }
        } else if (scope > 2 && (from->flags & CCNL_FACE_FLAGS_FWDALLI)) {
            DEBUGMSG_CFWD(DEBUG, "  old interest, nevertheless propagated %p\n",
                     (void *) i);
            ccnl_interest_propagate(ccnl, i);
        }
        if (i) { // store the I request, for the incoming face (Step 3)
            DEBUGMSG_CFWD(DEBUG, "  appending interest entry %p\n", (void *) i);
            ccnl_interest_append_pending(i, from);
>>>>>>> origin/arduino
        }
    }
    if (i) { // store the I request, for the incoming face (Step 3)
        DEBUGMSG_CFWD(DEBUG, "  appending interest entry %p\n", (void *) i);
        ccnl_interest_append_pending(i, from);
    }
    */
    return 0;
}

// process one CCNTLV packet, return <0 if no bytes consumed or error
int
ccnl_ccntlv_forwarder(struct ccnl_relay_s *relay, struct ccnl_face_s *from,
                      unsigned char **data, int *datalen)
{
    int payloadlen, rc = -1;
    unsigned short hdrlen;
    struct ccnx_tlvhdr_ccnx2015_s *hp;
    unsigned char *start = *data;
    struct ccnl_pkt_s *pkt;

    DEBUGMSG_CFWD(DEBUG, "ccnl_ccntlv_forwarder: %dB from face=%p (id=%d.%d)\n",
                  *datalen, (void*)from, relay->id, from ? from->faceid : -1);

    if ( (unsigned int) *datalen < sizeof(struct ccnx_tlvhdr_ccnx2015_s) ||
                                                     **data != CCNX_TLV_V1) {
        DEBUGMSG_CFWD(DEBUG, "  short header or wrong version (%d)\n", **data);
        return -1;
    }

    hp = (struct ccnx_tlvhdr_ccnx2015_s*) *data;
    hdrlen = hp->hdrlen; // ntohs(hp->hdrlen);
    if (hdrlen > *datalen) { // not enough bytes for a full header
        DEBUGMSG_CFWD(DEBUG, "  hdrlen too large (%d > %d)\n",
                      hdrlen, *datalen);
        return -1;
    }

    payloadlen = ntohs(hp->pktlen);
    if (payloadlen < hdrlen ||
             payloadlen > *datalen) { // not enough data to reconstruct message
        DEBUGMSG_CFWD(DEBUG, "  pkt too small or too big (%d < %d < %d)\n",
                 hdrlen, payloadlen, *datalen);
        return -1;
    }
    payloadlen -= hdrlen;

    *data += hdrlen;
    *datalen -= hdrlen;

    if (hp->pkttype == CCNX_PT_Interest ||
#ifdef USE_FRAG
        hp->pkttype == CCNX_PT_Fragment ||
#endif
                                        hp->pkttype == CCNX_PT_NACK) {
        hp->hoplimit--;
        if (hp->hoplimit <= 0) { // drop it
            DEBUGMSG_CFWD(DEBUG, "  pkt dropped because of hop limit\n");
            *data += payloadlen;
            *datalen -= payloadlen;
            return 0;
        }
    }

    DEBUGMSG_CFWD(DEBUG, "ccnl_ccntlv_forwarder (%d bytes left, hdrlen=%d)\n",
                  *datalen, hdrlen);

#ifdef USE_FRAG
    if (hp->pkttype == CCNX_PT_Fragment) {
        uint16_t *sp = (uint16_t*) *data;
        int fraglen = ntohs(*(sp+1));

        if (ntohs(*sp) == CCNX_TLV_TL_Fragment && fraglen == (payloadlen-4)) {
            uint16_t fragfields; // = *(uint16_t *) &hp->fill;
            *data += 4;
            *datalen -= 4;
            payloadlen = fraglen;

            memcpy(&fragfields, hp->fill, 2);
            fragfields = ntohs(fragfields);

            ccnl_frag_RX_BeginEnd2015(ccnl_ccntlv_forwarder, relay, from,
                            relay->ifs[from->ifndx].mtu, fragfields >> 14,
                            fragfields & 0x3fff, data, datalen);

            DEBUGMSG_CFWD(TRACE, "  done (fraglen=%d, payloadlen=%d, *datalen=%d)\n",
                     fraglen, payloadlen, *datalen);
        } else {
            DEBUGMSG_CFWD(DEBUG, "  problem with frag type or length (%d, %d, %d)\n",
                     ntohs(*sp), fraglen, payloadlen);
            *data += payloadlen;
            *datalen -= payloadlen;
        }
        DEBUGMSG_CFWD(TRACE, "  returning after fragment: %d bytes\n", *datalen);
        return 0;
    } else {
        DEBUGMSG_CFWD(TRACE, "  not a fragment, continueing\n");
    }
#endif

    if (!from) {
        DEBUGMSG_CFWD(TRACE, "  local data, datalen=%d\n", *datalen);
    }

    pkt = ccnl_ccntlv_bytes2pkt(start, data, datalen);
    if (!pkt) {
        DEBUGMSG_CFWD(WARNING, "  parsing error or no prefix\n");
        goto Done;
    }
    if (!from) {
        DEBUGMSG_CFWD(TRACE, "  pkt ok\n");
//        goto Done;
    }


    if (hp->pkttype == CCNX_PT_Interest) {
        if (pkt->type == CCNX_TLV_TL_Interest) {
            pkt->flags |= CCNL_PKT_REQUEST;
            // DEBUGMSG_CFWD(DEBUG, "  interest=<%s>\n", ccnl_prefix_to_path(pkt->pfx));
            if (ccnl_fwd_handleInterest(relay, from, &pkt, ccnl_ccntlv_cMatch))
                goto Done;
        } else {
            DEBUGMSG_CFWD(WARNING, "  ccntlv: interest pkt type mismatch %d %d\n",
                          hp->pkttype, pkt->type);
        }
    } else if (hp->pkttype == CCNX_PT_Data) {
        if (pkt->type == CCNX_TLV_TL_Object) {
            pkt->flags |= CCNL_PKT_REPLY;
            ccnl_fwd_handleContent(relay, from, &pkt);
        } else {
            DEBUGMSG_CFWD(WARNING, "  ccntlv: data pkt type mismatch %d %d\n",
                     hp->pkttype, pkt->type);
        }
    } // else ignore
    rc = 0;
Done:
    free_packet(pkt);

    DEBUGMSG_CFWD(TRACE, "  returning %d bytes\n", *datalen);
    return rc;
}

// ----------------------------------------------------------------------

// insert forwarding entry with a tap - the prefix arg is consumed
int
ccnl_set_tap(struct ccnl_relay_s *relay, struct ccnl_prefix_s *pfx,
             tapCallback callback)
{
    struct ccnl_forward_s *fwd, **fwd2;

    char *s = NULL;
    DEBUGMSG_CFWD(INFO, "setting tap for <%s>, suite %s\n",
             (s = ccnl_prefix_to_path(pfx)), ccnl_suite2str(pfx->suite));
    ccnl_free(s);

    for (fwd = relay->fib; fwd; fwd = fwd->next) {
        if (fwd->suite == pfx->suite &&
                        !ccnl_prefix_cmp(fwd->prefix, NULL, pfx, CMP_EXACT)) {
            free_prefix(fwd->prefix);
            fwd->prefix = NULL;
            break;
        }
    }
    if (!fwd) {
        fwd = (struct ccnl_forward_s *) ccnl_calloc(1, sizeof(*fwd));
        if (!fwd)
            return -1;
        fwd2 = &relay->fib;
        while (*fwd2)
            fwd2 = &((*fwd2)->next);
        *fwd2 = fwd;
        fwd->suite = pfx->suite;
    }
    fwd->prefix = pfx;
    fwd->tap = callback;

    return 0;
}


// eof
