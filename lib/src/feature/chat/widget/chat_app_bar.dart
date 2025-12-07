import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_new/src/core/resources/sizes.dart';
import 'package:chat_app_new/src/core/router/app_router.dart';
import 'package:chat_app_new/src/feature/chat/widget/scope/chat_scope.dart';

import '../../../../l10n/app_localizations.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double _preferredHeight = 72;
  final bool isTyping;

  const ChatAppBar({required this.isTyping, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(_preferredHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: 8,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Leading icon
              Positioned(
                left: 0,
                child: Icon(
                  Icons.smart_toy_outlined,
                  size: 28,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              // Centered title
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.aiAssistant,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isTyping) ...[
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CupertinoActivityIndicator(
                            color: Theme.of(context).primaryColor,
                            radius: 6,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ] else ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        isTyping ? l10n.typing : l10n.online,
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Actions
              Positioned(
                right: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => context.router.push(const SettingsRoute()),
                      icon: Icon(
                        Icons.settings_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.color
                            ?.withOpacity(0.7),
                      ),
                      tooltip: l10n.settings,
                    ),
                    IconButton(
                      onPressed: () => _showCancelDialog(context),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.color
                            ?.withOpacity(0.7),
                      ),
                      tooltip: l10n.clearChat,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCancelDialog(BuildContext pageContext) =>
      showCupertinoModalPopup<CupertinoActionSheet>(
        context: pageContext,
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return CupertinoActionSheet(
            message: Text(
              l10n.clearChatHistory,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            actions: [
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () =>
                    clearMessagesAndPopDialog(context, pageContext),
                child: Text(
                  l10n.clear,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                    color: CupertinoColors.systemRed,
                  ),
                ),
              )
            ],
          );
        },
      );

  void clearMessagesAndPopDialog(
    BuildContext context,
    BuildContext pageContext,
  ) {
    Navigator.pop(context);
    ChatScope.clearMessages(pageContext);
  }
}
