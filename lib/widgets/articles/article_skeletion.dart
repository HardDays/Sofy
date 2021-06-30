import 'package:flutter/cupertino.dart';

class ArticleSkeletion extends StatelessWidget {
  const ArticleSkeletion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(physics: NeverScrollableScrollPhysics(),
    child: Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 200),
            Center(child: Text('I INSERT SHIMMER HERE')),
          ],
        )
      ],
    ));
  }
}
