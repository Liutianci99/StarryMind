import 'package:flutter/material.dart';
import 'package:starry_mind/core/theme/app_theme.dart';
import 'package:starry_mind/shared/presentation/widgets/frosted_panel.dart';

class ThoughtComposer extends StatelessWidget {
  const ThoughtComposer({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return FrostedPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: 999,
      child: Row(
        children: [
          const Icon(Icons.star_rounded, size: 18, color: AppTheme.starGold),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSubmit(),
              style: const TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontStyle: FontStyle.italic,
                fontSize: 15, color: AppTheme.ink900,
              ),
              decoration: const InputDecoration(
                hintText: 'Whatever crosses your mind —',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSubmit,
            child: const Text(
              'enter',
              style: TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontStyle: FontStyle.italic,
                fontSize: 13,
                color: AppTheme.starGold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
