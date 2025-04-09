import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../common/common_image.dart';
import '../../common/common_webview.dart';
import '../../db/clientAuthDB_isar.dart';
import '../../utils/account.dart';

class Request extends StatefulWidget {
  @override
  RequestState createState() => RequestState();
}

class RequestState extends State<Request> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Incoming Request',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      body: Container(
        height: double.infinity,
        child: ValueListenableBuilder<List<ClientAuthDBISAR>>(
          valueListenable: Account.sharedInstance.clientAuthList,
          builder: (context, value, child) {
            if (value.isEmpty) return _noRequestWidget();
            return SingleChildScrollView(
              child: Column(
                children: _requestListWidget(value),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _noRequestWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CommonImage(
                iconName: 'aegis_logo.png',
                size: 100,
              ).setPaddingOnly(
                top: 24.0,
                bottom: 20.0,
              ),
            ),
            Center(child: Text(
              'Nothing to approve yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),)
          ],
        ),
      ),
    );
  }

  List<Widget> _requestListWidget(List<ClientAuthDBISAR> clientAuthList) {
    return clientAuthList.map((ClientAuthDBISAR clientAuth) {
      return GestureDetector(
        onTap: () {
          // AegisNavigator.pushPage(context, (context) => RequestInfo(requestEvent: clientRequest,));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          width: double.infinity,
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoWidget('pukey', clientAuth.pubkey),
              _infoWidget('clientPukey', clientAuth.clientPubkey),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'isAuthorized',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(clientAuth.isAuthorized ? '✅' : '❌'),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _infoWidget(String title, String content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(content),
      ],
    ).setPaddingOnly(bottom: 15.0);
  }
}
