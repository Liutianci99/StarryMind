import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);

    return FrostedPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('快速投入一个想法', style: theme.textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            '输入后会立刻通过 Flutter -> WebView bridge 飞入 3D 星图。',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            minLines: 1,
            maxLines: 4,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => onSubmit(),
            decoration: const InputDecoration(
              hintText: '比如：先把 WebView 通信桥抽出来，后面替换 Three.js 页面',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '当前阶段使用 mock 节点与随机 3D 坐标。',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.send_rounded),
                label: const Text('投入星图'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
