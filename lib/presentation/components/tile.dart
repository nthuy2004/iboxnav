import "package:flutter/material.dart";

class Tile {
  static Widget Header(context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 17, right: 17, top: 5, bottom: 1),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  static Widget Item(context,
      {required String text,
      required IconData icon,
      required VoidCallback onClick}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        onTap: onClick,
        leading: CircleAvatar(
          backgroundColor: const Color(0xffE6E6E6),
          radius: 23,
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        title: Text(text),
        trailing: const Icon(
          Icons.navigate_next,
          size: 25,
        ),
      ),
    );
  }
}
