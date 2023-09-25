import 'package:flutter/material.dart';

class GridContainerItem {
  final String key;
  final String value;
  GridContainerItem({required this.key, required this.value});
  Widget render() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          key,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey[300]!),
        ),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}

Widget gridHeader(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 6, bottom: 12),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
    ),
  );
}

Widget gridContainer(context, List<GridContainerItem> items) {
  return GridView.count(
    physics: const ScrollPhysics(),
    crossAxisCount: 2,
    childAspectRatio: (1 / .27),
    shrinkWrap: true,
    children: <Widget>[for (var item in items) item.render()],
  );
}
