class SavedRoutes {
  List<int> codes = [];

  SavedRoutes(this.codes);

  SavedRoutes.fromJson(Map<String, dynamic> json)
      : codes = json['codes'].cast<int>();

  Map<String, dynamic> toJson() => {
        'codes': codes,
      };

  
}