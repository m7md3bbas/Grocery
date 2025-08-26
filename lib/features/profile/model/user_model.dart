class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String image;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
  });

  /// copyWith لتسهيل تحديث أي حقل بدون المساس بالكائن الأصلي
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? image,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
    );
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      image: map['profile_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'phone': phone, 'profile_url': image};
  }
}
