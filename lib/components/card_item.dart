import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:partyhaan_app/components/button.dart';
import 'package:partyhaan_app/constants/firebase_constants.dart';
import 'package:partyhaan_app/controllers/party_controller.dart';
import 'package:partyhaan_app/models/party_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    Key? key,
    required this.party,
  }) : super(key: key);

  final Party party;

  @override
  Widget build(BuildContext context) {
    bool isExist = party.participantList!.contains(auth.currentUser!.uid);

    return Card(
      elevation: 5,
      child: Container(
        color: Color.fromARGB(255, 255, 206, 59),
        child: Column(
          children: [
            _CardHeader(
              model: party,
              showMore: (party.creator == auth.currentUser?.uid),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
              child: Column(
                children: [
                  _CardBody(
                    title: party.title,
                    description: party.description,
                  ),
                  _CardFooter(party: party, isExist: isExist),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    Key? key,
    required this.model,
    required this.showMore,
  }) : super(key: key);

  final Party model;
  final bool showMore;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      child: Stack(
        children: [
          (model.image!.isEmpty)
              ? Image.asset(
                  'assets/images/party_haan.png',
                  fit: BoxFit.cover,
                )
              : Image.network(
                  model.image!,
                  width: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
          if (showMore)
            Positioned(
              top: 8,
              right: 2,
              child: _MoreButton(partyID: model.partyID!, image: model.image!),
            ),
        ],
      ),
      aspectRatio: 1,
    );
  }
}

class _MoreButton extends StatefulWidget {
  final String partyID;
  final String image;

  const _MoreButton({
    Key? key,
    required this.partyID,
    required this.image,
  }) : super(key: key);

  @override
  State<_MoreButton> createState() => _MoreButtonState();
}

class _MoreButtonState extends State<_MoreButton> {
  PointerHoverEvent? pointerEvent;

  void onTab() async {
    int? value = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
          pointerEvent?.position.dx ?? 0,
          pointerEvent?.position.dy ?? 0,
          pointerEvent?.position.dx ?? 0,
          pointerEvent?.position.dy ?? 0),
      items: [
        const PopupMenuItem(
          value: 0,
          child: Text("ลบปาร์ตี้"),
        ),
      ],
    );
    print('select value: $value');

    if (value == 0) {
      PartyController.instance.onDeleteParty(widget.partyID, widget.image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => pointerEvent = event,
      child: GestureDetector(
        onTap: onTab,
        child: Icon(Icons.more_vert),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String? title, description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${title}',
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${description}',
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardFooter extends StatelessWidget {
  const _CardFooter({
    Key? key,
    required this.party,
    required this.isExist,
  }) : super(key: key);

  final Party party;
  final bool isExist;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (party.creator != auth.currentUser?.uid)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                primary: (isExist) ? Colors.red : Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (isExist) {
                  PartyController.instance
                      .onLeaveParty(party, auth.currentUser!.uid);
                } else {
                  PartyController.instance
                      .onJoinParty(party, auth.currentUser!.uid);
                }
              },
              child: (isExist) ? Text('ออกปาร์ตี้') : Text('เข้าปาร์ตี้'),
            ),
          Text(
            '${party.participantList?.length}/${party.maximum}',
          ),
        ],
      ),
    );
  }
}
