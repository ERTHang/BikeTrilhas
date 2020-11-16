class SavedRoutes {
  List<int> codes = [];
  List<String> names = [];
  List<int> sequenceInits = [];

  SavedRoutes(this.codes, this.names);

  SavedRoutes.fromJson(Map<String, dynamic> json)
      : codes = json['codes'].cast<int>(),
        names = json['names'].cast<String>(),
        sequenceInits = json['sequenceInits'].cast<int>();

  Map<String, dynamic> toJson() => {
        'codes': codes,
        'names': names,
        'sequenceInits': sequenceInits,
      };

  
}