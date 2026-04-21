/// Last Updated: 2026-04-10
/// 最后更新: 2026-04-10
///
/// Module: Task Card Widget - used in Home Dashboard
/// 模块: 任务卡片组件 - 用于首页仪表盘
///
/// Dependencies: flutter/material.dart
/// 依赖: flutter/material.dart
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
    this.isLocked = false,
  });

  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                isLocked ? Icons.lock_outline : Icons.star_rounded,
                color: isLocked ? const Color(0xFFB0B9C0) : const Color(0xFFF2C94C),
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isLocked ? const Color(0xFF8A959E) : const Color(0xFF162025),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5D696F),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLocked ? null : onTap,
              style: FilledButton.styleFrom(
                backgroundColor: isLocked ? const Color(0xFFE5E9EC) : const Color(0xFF1FA95B),
                foregroundColor: isLocked ? const Color(0xFF8A959E) : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
