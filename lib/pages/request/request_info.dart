import 'dart:convert';

import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../nostr/event.dart';
import '../../nostr/nips/nip04/nip04.dart';
import '../../nostr/signer/local_nostr_signer.dart';
import '../../utils/server_nip46_signer.dart';


class RequestInfo extends StatefulWidget {
  final ClientRequest requestEvent;
  RequestInfo({required this.requestEvent});
  @override
  RequestInfoState createState() => RequestInfoState();
}

class RequestInfoState extends State<RequestInfo> {
  String decryptContent = '';
  String decryptSignEventContent = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDecryptContent();
    // getSignEventContent();
  }

  void getDecryptContent()async {
    Event event = widget.requestEvent.event;
    String ciphertext = event.content;
    String plaintext;
    bool isNip04 = ciphertext.contains('?iv=');
    if(isNip04){
      plaintext = NIP04.decrypt(ciphertext, LocalNostrSigner.instance.getAgreement(), event.pubkey);
    }else{
      plaintext = await LocalNostrSigner.instance.nip44Decrypt(event.pubkey, ciphertext) ?? '--';
    }
    setState(() {
      decryptContent = plaintext;
    });
  }

  @override
  Widget build(BuildContext context) {
    Event event = widget.requestEvent.event;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Permission Request',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                event.pubkey
            ).setPadding(EdgeInsets.symmetric(horizontal: 16,vertical: 20)),

            Text(
                event.id
            ).setPadding(EdgeInsets.symmetric(horizontal: 16,vertical: 20)),
            Text(
                event.createdAt.toString()
            ).setPadding(EdgeInsets.symmetric(horizontal: 16,vertical: 20)),
            Text(
                event.tags.toString()
            ).setPadding(EdgeInsets.symmetric(horizontal: 16,vertical: 20)),

            Text(
                decryptContent
            ).setPadding(EdgeInsets.symmetric(horizontal: 16,vertical: 20)),

          ],
        ),
      ),
    );
  }
}
