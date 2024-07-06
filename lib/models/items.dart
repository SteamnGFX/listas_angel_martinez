class SubItem {
  String title;
  bool completed;

  SubItem({required this.title, this.completed = false});

  factory SubItem.fromJson(Map<String, dynamic> json) {
    return SubItem(
      title: json['title'],
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completed': completed,
    };
  }
}

class Item {
  String title;
  List<SubItem> subItems;

  Item({required this.title, List<SubItem>? subItems})
      : subItems = subItems ?? <SubItem>[]; // Ensure subItems is a mutable list

  factory Item.fromJson(Map<String, dynamic> json) {
    var list = json['subItems'] as List<dynamic>;
    List<SubItem> subItemList = list.map((i) => SubItem.fromJson(i)).toList();

    return Item(
      title: json['title'],
      subItems: subItemList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subItems': subItems.map((e) => e.toJson()).toList(),
    };
  }
}
