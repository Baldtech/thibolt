class CategoryModel{
  String name;
  String icon;
  CategoryModel({required this.name, required this.icon});

  static List<CategoryModel> categories = [
    CategoryModel(name: 'core', icon: 'core.svg'),
    CategoryModel(name: 'stretching', icon: 'stretching.svg'),
    CategoryModel(name: 'swim', icon: 'swim.svg'),
  ];
}