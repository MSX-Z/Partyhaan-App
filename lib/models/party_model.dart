class Party {
  String? _partyID, _creator, _description, _image, _title;
  int? _maximum;
  List<String>? _participantList;

  Party(
      {String? partyID,
      String? creator,
      String? description,
      String? image,
      String? title,
      int? maximum,
      List<String>? participantList}) {
    _partyID = partyID;
    _creator = creator;
    _description = description;
    _image = image;
    _title = title;
    _maximum = maximum;
    _participantList = participantList;
  }

  // GET
  String? get partyID => _partyID;
  String? get creator => _creator;
  String? get title => _title;
  String? get description => _description;
  String? get image => _image;
  int? get maximum => _maximum;
  List<String>? get participantList => _participantList;

  Party.fromJson(Map<String, dynamic> json) {
    _partyID = json['party_id'];
    _creator = json['creator'];
    _description = json['description'];
    _image = json['image'];
    _maximum = json['maximum'];
    _participantList = json['participant_list'].cast<String>();
    _title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['party_id'] = _partyID;
    data['creator'] = _creator;
    data['description'] = _description;
    data['image'] = _image;
    data['maximum'] = _maximum;
    data['participant_list'] = _participantList;
    data['title'] = _title;
    return data;
  }

  @override
  String toString() {
    return 'Partys(partyID: $_partyID, creator: $_creator, description: $_description, image: $_image, maximum: $_maximum, participantList: $_participantList, title: $_title)';
  }

  Party copyWith(
      {String? partyID,
      String? creator,
      String? description,
      String? image,
      String? title,
      int? maximum,
      List<String>? participantList}) {
    return Party(
        partyID: partyID ?? _partyID,
        creator: creator ?? _creator,
        description: description ?? _description,
        image: image ?? _image,
        title: title ?? _title,
        maximum: maximum ?? _maximum,
        participantList: participantList ?? _participantList);
  }
}
