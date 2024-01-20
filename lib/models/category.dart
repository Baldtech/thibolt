class Category {
  final int id;
  final String name;
  final String icon;

  Category({this.id = -1, required this.name, required this.icon});

  Category.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        name = item["name"],
        icon = item["icon"];

  Map<String, Object> toMap() {
    return {'id': id, 'name': name, 'icon': icon};
  }

  static List<Category> categories = [
    // Category(name: 'core', icon: 'core.svg'),
    // Category(name: 'stretching', icon: 'stretching.svg'),
    // Category(name: 'swim', icon: 'swim.svg'),
  ];
}
