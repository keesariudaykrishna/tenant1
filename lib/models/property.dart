class Property {
  final String id;
  final String title;
  final String location;
  final String imageUrl;
  final double price;
  final String description;
  final List<String> amenities;
  final String hostId;

  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.amenities,
    required this.hostId,
  });

  factory Property.fromFirestore(Map<String, dynamic> data, String id) {
    return Property(
      id: id,
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/300',
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      amenities: List<String>.from(data['amenities'] ?? []),
      hostId: data['hostId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'location': location,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
      'amenities': amenities,
      'hostId': hostId,
    };
  }
}