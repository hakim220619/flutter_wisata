import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:wisata/components/like/data.dart' as data;

class PostWidget extends StatelessWidget {
  const PostWidget({
    Key? key,
    this.title,
    required this.imgPath,
    required this.reactions,
    this.description,
  }) : super(key: key);

  final String imgPath;

  final Widget? title;
  final Widget? description;
  final List<Reaction<String>> reactions;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 2,
              child: Image.asset(
                imgPath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            if (title != null || description != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) title!,
                    if (title != null && description != null)
                      const SizedBox(
                        height: 2,
                      ),
                    if (description != null) description!,
                  ],
                ),
              ),
            Container(
              height: 55,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReactionButton<String>(
                    itemSize: const Size.square(40),
                    onReactionChanged: (Reaction<String>? reaction) {
                      debugPrint('Selected value: ${reaction?.value}');
                    },
                    reactions: reactions,
                    placeholder: reactions.first,
                    selectedReaction: reactions.first,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.message,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        child: Text(
                          'Comment',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text('Modal BottomSheet'),
                                      ElevatedButton(
                                        child: const Text('Close BottomSheet'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.share,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
