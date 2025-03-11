import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/pages/request/request_info.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';

import '../../common/common_image.dart';
import '../../utils/account.dart';
import '../../utils/server_nip46_signer.dart';

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
        child: ValueListenableBuilder<List<ClientRequest>>(
          valueListenable: Account.sharedInstance.clientRequestList,
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
            Text(
              'Nothing to approve yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Why not explore your favorite nostr app  a bit?",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Discover all Nostr apps for android at nostrapps.com.",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            FilledButton.tonal(
              onPressed: () {
                // AegisNavigator.pushPage(context, (context) => RequestPermission());
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer, //
              ),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                child: Text(
                  'Discover',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ).setPaddingOnly(top: 20.0),
          ],
        ),
      ),
    );
  }

  List<Widget> _requestListWidget(List<ClientRequest> clientRequestList) {
    return clientRequestList.map((ClientRequest clientRequest) {
      return GestureDetector(
        onTap: () {
          AegisNavigator.pushPage(context, (context) => RequestInfo(requestEvent: clientRequest,));
        },
        child: Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primaryContainer,
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clientRequest.method,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                clientRequest.event?.subscriptionId?.toString() ?? '',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                clientRequest.params.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
