
class Kindergarten {
  String id;
  String name;
  String description;
  String imageUrl;
  String city;
  String state;
  String contactPerson;
  String contactNo;

  Kindergarten({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.city,
    required this.state,
    required this.contactPerson,
    required this.contactNo,
  });

  factory Kindergarten.fromJson(Map<String, dynamic> json) => Kindergarten(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        imageUrl: json["imageUrl"] ?? "",
        city: json["city"] ?? "",
        state: json["state"] ?? "",
        contactPerson: json["contact_person"] ?? "",
        contactNo: json["contact_no"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "imageUrl": imageUrl,
        "city": city,
        "state": state,
        "contact_person": contactPerson,
        "contact_no": contactNo,
      };
}

class Pagination {
  final int first;
  final int prev;
  final int next;
  final int last;
  final int pages;
  final int items;
  final List<Kindergarten> data;

  Pagination({
    required this.first,
    required this.prev,
    required this.next,
    required this.last,
    required this.pages,
    required this.items,
    required this.data,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      first: json['first'] ?? 0,
      prev: json['prev'] ?? 0,
      next: json['next'] ?? 0,
      last: json['last'] ?? 0,
      pages: json['pages'] ?? 0,
      items: json['items'] ?? 0,
      data: (json['data'] as List<dynamic>).map((item) => Kindergarten.fromJson(item)).toList(),
    );
  }
}
