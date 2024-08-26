import 'package:flutter/material.dart';

final class Section<T> {
  final List<Item<T>> items;
  final SliverAppBar header;

  Section({
    required this.items,
    required this.header,
  });
}

final class Item<T> {
  final Widget Function(T value) paginationItemView;

  Item({required this.paginationItemView});
}
