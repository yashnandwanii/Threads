import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/models/comment_model.dart';
import 'package:threads/widgets/circle_image.dart';
import 'package:threads/widgets/comment_car_topbar.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final bool isAuthCard;

  const CommentCard({
    required this.comment,
    this.isAuthCard = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: context.width * 0.12,
              child: CircleImage(
                imageUrl: comment.user!.metadata?.image,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: context.width * 0.80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Comment top bar
                  CommentCardTopbar(
                    comment: comment,
                    isAuthCard: isAuthCard,
                  ),
                  Text(comment.reply!),
                  const SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
        const Divider(
          color: Color(0xff242424),
        )
      ],
    );
  }
}
