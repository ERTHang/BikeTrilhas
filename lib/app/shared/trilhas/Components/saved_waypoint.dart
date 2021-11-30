class SavedWaypoint {
  List<int> codes = [];

  SavedWaypoint(this.codes);

  SavedWaypoint.fromJson(Map<String, dynamic> json)
      : codes = json['codes'].cast<int>();

  Map<String, dynamic> toJson() => {
        'codes': codes,
      };
}
