class Category {
  String thumbnail;
  String name;

  Category({
    required this.name,
    required this.thumbnail,
  });
}

List<Category> categoryList = [
  Category(
    name: 'Start Learning',
    thumbnail: 'images/start.json',
  ),
  Category(
    name: 'Join US',
    thumbnail: 'images/whatsapp.json',
  ),
  Category(
    name: 'Website',
    thumbnail: 'images/www.json',
  ),
  Category(
    name: 'About Us',
    thumbnail: 'images/about-us.json',
  ),
];