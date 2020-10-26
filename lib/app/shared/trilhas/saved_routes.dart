class SavedRoutes {
  List<int> codes = [];
  List<String> names = [];

  SavedRoutes(this.codes, this.names);

  SavedRoutes.fromJson(Map<String, dynamic> json)
      : codes = json['codes'].cast<int>(),
        names = json['names'].cast<String>();

  Map<String, dynamic> toJson() => {
        'codes': codes,
        'names': names,
      };

  
}