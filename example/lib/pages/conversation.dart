import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/views/card.dart';
import 'package:starrail_ui/views/misc/scroll.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  static const int _leftUserId = 0;
  static const int _rightUserId = 1;

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildHeader(UserModel user) {
    Widget child;
    var name = Text(
      user.name,
      style: TextStyle(fontSize: 15, color: Colors.black),
    );
    child = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        name,
        if (user.signature != null) const SizedBox(height: 4),
        if (user.signature != null)
          Text(
            user.signature!,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black.withOpacity(0.5),
            ),
          )
      ],
    );
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: child,
    );
  }

  _ConversationMessages _buildMessages(
    UserModel leftUser,
    UserModel rightUser,
  ) {
    return _ConversationMessages(
      padding: EdgeInsets.only(left: 16, right: 8),
      model: ConversationModel(
        leftUser: leftUser,
        rightUser: rightUser,
        messages: List.generate(
          Random().nextInt(40) + 10,
          (index) {
            int userId =
                (Random().nextDouble() > 0.5) ? _leftUserId : _rightUserId;
            return (Random().nextDouble() > 0.1)
                ? MessageModel(
                    userId: userId,
                    text: _randomString(Random().nextInt(10) + 1),
                  )
                : MessageModel(
                    userId: userId,
                    imageAssetPath: _randomImage(),
                  );
          },
        ),
      ),
    );
  }

  String _avatarPath(int id) {
    return "assets/images/avatars/0$id.jpg";
  }

  String _randomImage() {
    return "assets/images/0${Random().nextInt(2) + 1}.jpg";
  }

  String _randomString(int words) => lorem(paragraphs: 1, words: words);

  @override
  Widget build(BuildContext context) {
    List<int> avatarIds = List.generate(6, (index) => index + 1);
    var avatarId = avatarIds[Random().nextInt(avatarIds.length)];
    avatarIds.remove(avatarId);
    var leftUser = UserModel(
      id: _leftUserId,
      name: _randomString(1),
      signature: (Random().nextDouble() > 0.5) ? null : _randomString(4),
      avatarAssetPath: _avatarPath(avatarId),
    );
    avatarId = avatarIds[Random().nextInt(avatarIds.length)];
    var rightUser = UserModel(
      id: _rightUserId,
      name: _randomString(1),
      signature: (Random().nextDouble() > 0.5) ? null : _randomString(4),
      avatarAssetPath: _avatarPath(avatarId),
    );
    var scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Container(
        color: scheme.inverseSurface,
        padding: const EdgeInsets.all(16),
        child: SRCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(leftUser),
              Container(color: srCardTitleRowDivider, height: 1),
              Expanded(child: _buildMessages(leftUser, rightUser)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationMessages extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final ConversationModel model;

  const _ConversationMessages({required this.model, this.padding});

  _MessageBanner? _buildMessage(double imageWidth, MessageModel e) {
    bool isLeft = e.userId == model.leftUser.id;
    _Bubble? bubble;
    if (e.text != null) {
      bubble = _Bubble.text(text: e.text!, isLeft: isLeft);
    } else if (e.imageAssetPath != null) {
      bubble = _Bubble.image(
        image: e.imageAssetPath!,
        width: imageWidth,
        isLeft: isLeft,
      );
    }
    if (bubble != null) {
      return _MessageBanner(
        isLeft: isLeft,
        user: isLeft ? model.leftUser : model.rightUser,
        bubble: bubble,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var widgets = model.messages
            .map((e) => _buildMessage(constraints.maxWidth / 2, e))
            .whereNotNull()
            .map((e) => [e, const SizedBox(height: 16)])
            .expand((e) => e)
            .toList();
        if (widgets.isNotEmpty) {
          widgets.removeLast();
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
              child: Container(height: 1, color: srCardTitleRowDivider),
            ),
          );
        }
        return SRScrollView(
          padding: padding,
          children: widgets,
        );
      },
    );
  }
}

class _MessageBanner extends StatelessWidget {
  final bool isLeft;
  final UserModel user;
  final _Bubble bubble;

  const _MessageBanner({
    required this.isLeft,
    required this.user,
    required this.bubble,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var sizedAvatar = SizedBox.square(
          dimension: 48,
          child: ClipOval(child: Image.asset(user.avatarAssetPath)),
        );
        var column = ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: constraints.maxWidth - 48 - 8 - 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              bubble,
            ],
          ),
        );
        var children = isLeft
            ? [
                sizedAvatar,
                const SizedBox(width: 8),
                column,
                const SizedBox(width: 8),
              ]
            : [
                const SizedBox(width: 8),
                column,
                const SizedBox(width: 8),
                sizedAvatar,
              ];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: children,
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  static const double _radius = 7;
  static const double _horizontalPadding = 10;
  static const double _verticalPadding = 7;
  final Widget child;
  final bool isLeft;
  final bool onlyClip;
  final EdgeInsets? padding;

  factory _Bubble.text({
    required String text,
    required bool isLeft,
    Color textColor = Colors.black,
  }) {
    return _Bubble(
      isLeft: isLeft,
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: textColor),
      ),
    );
  }

  factory _Bubble.image({
    required String image,
    required bool isLeft,
    required double width,
  }) {
    return _Bubble(
      isLeft: isLeft,
      onlyClip: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width, maxHeight: width * 1.5),
        child: Image.asset(image),
      ),
    );
  }

  const _Bubble({
    super.key,
    required this.child,
    required this.isLeft,
    this.padding,
    this.onlyClip = false,
  });

  @override
  Widget build(BuildContext context) {
    Radius corner = const Radius.circular(_radius);
    BorderRadius borderRadius = BorderRadius.only(
      bottomLeft: corner,
      bottomRight: corner,
      topLeft: isLeft ? Radius.zero : corner,
      topRight: isLeft ? corner : Radius.zero,
    );
    if (onlyClip) {
      return ClipRRect(borderRadius: borderRadius, child: child);
    } else {
      return Container(
        decoration: BoxDecoration(
          color: (isLeft ? Colors.white : const Color(0xFFD4BC8A))
              .withOpacity(0.95),
          borderRadius: borderRadius,
        ),
        padding: padding,
        child: child,
      );
    }
  }
}

class UserModel {
  final int id;
  final String name;
  final String? signature;
  final String avatarAssetPath;

  const UserModel({
    required this.id,
    required this.name,
    required this.avatarAssetPath,
    this.signature,
  });
}

class ConversationModel {
  final UserModel leftUser;
  final UserModel rightUser;
  final List<MessageModel> messages;

  const ConversationModel({
    required this.leftUser,
    required this.rightUser,
    required this.messages,
  });
}

class MessageModel {
  final int userId;
  final String? text;
  final String? imageAssetPath;

  const MessageModel({
    required this.userId,
    this.text,
    this.imageAssetPath,
  });
}
