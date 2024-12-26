import 'package:flutter/material.dart';
import 'package:online_groceries_app/server/aiphelper.dart';
import 'package:online_groceries_app/themes/app_theme.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late Future<List<Category>> categories;
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    categories = fetchCategories();
    products = fetchProducts();
  }

  Future<List<Category>> fetchCategories() async {
    final data = await ApiHelper.fetchData(
        'categories'); // Assuming 'categories' is your endpoint
    List<Category> categoryList = [];
    for (var category in data['data']) {
      categoryList.add(Category.fromJson(category));
    }
    return categoryList;
  }

  Future<List<Product>> fetchProducts() async {
    final data = await ApiHelper.fetchData(
        'products'); // Assuming 'products' is your endpoint
    List<Product> productList = [];
    for (var product in data['data']) {
      productList.add(Product.fromJson(product));
    }
    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: MyAppTheme.primaryColor,
        elevation: 0,
        title: const Text(
          'Shop',
          style: TextStyle(
            fontSize: 24,
            color: MyAppTheme.mainColor,
            fontFamily: 'KantumruyPro',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shop by Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MyAppTheme.backgroundColor,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Category>>(
              future: categories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No categories found');
                } else {
                  return _buildCategoryList(snapshot.data!);
                }
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Popular Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MyAppTheme.backgroundColor,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Product>>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No products found');
                } else {
                  return _buildProductList(snapshot.data!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(categories[index], categories[index].image);
      },
    );
  }

  Widget _buildCategoryCard(Category category, String image) {
    return GestureDetector(
      onTap: () {
        // Navigate to the category-specific products (or add functionality)
        print('Tapped on ${category.name}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: MyAppTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            // Display the category name
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MyAppTheme.backgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(
            products[index].name,
            products[index].price,
            products[index].image,
          );
        },
      ),
    );
  }

  Widget _buildProductCard(String name, String price, String image) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Add to cart functionality
                    print('Added $name to cart');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyAppTheme.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Category {
  final String id;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class Product {
  final String id;
  final String name;
  final String price;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      price: '\$${json['price']}',
      image: json['image'],
    );
  }
}
