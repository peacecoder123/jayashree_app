class DocumentModel {
  final String id;
  final String name;
  final String category;
  final String iconColor;
  final String? fileUrl;

  const DocumentModel({
    required this.id,
    required this.name,
    required this.category,
    required this.iconColor,
    this.fileUrl,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        iconColor: json['iconColor'] as String? ?? 'teal',
        fileUrl: json['fileUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'iconColor': iconColor,
        'fileUrl': fileUrl,
      };

  DocumentModel copyWith({
    String? id,
    String? name,
    String? category,
    String? iconColor,
    String? fileUrl,
  }) =>
      DocumentModel(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        iconColor: iconColor ?? this.iconColor,
        fileUrl: fileUrl ?? this.fileUrl,
      );
}
