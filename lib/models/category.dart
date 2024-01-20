class Category{
  String name;
  String icon;
  Category({required this.name, required this.icon});

  static List<Category> categories = [
    Category(name: 'core', icon: 'core.svg'),
    Category(name: 'stretching', icon: 'stretching.svg'),
    Category(name: 'swim', icon: 'swim.svg'),
  ];
}