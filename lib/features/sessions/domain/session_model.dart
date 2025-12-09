// Datenklasse: id, name, ownderId, members
class SessionModel {
  final String id;
  final String ownerId;
  final int createdAt;
  final String name;

  SessionModel({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    required this.name,
  });

  factory SessionModel.fromSnapshot(String key, Map<dynamic, dynamic> map) {
    return SessionModel(
      id: key,
      ownerId: map['ownerId'] ?? '',
      createdAt: map['createdAt'] ?? 0,
      name: map['name'] ?? 'Training',
    );
  }
}
