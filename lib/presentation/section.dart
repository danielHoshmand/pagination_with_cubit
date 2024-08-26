final class Section {
  Section(
    this.title,
    this.items,
  );

  final List<Item> items;
  final String title;
}

final class Item {
  Item(this.content);

  final String content;
}