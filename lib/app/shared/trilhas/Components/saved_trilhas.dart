class SavedTrilhas {
  List<int> codes = [];

  SavedTrilhas(this.codes);

  SavedTrilhas.fromJson(Map<String, dynamic> json)
      : codes = json['codes'].cast<int>();

  Map<String, dynamic> toJson() => {
        'codes': codes,
      };
}
