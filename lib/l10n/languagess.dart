class Languages {
  final int id;
  final String name;
  final String languageCode;
  Languages(this.id, this.name, this.languageCode);
  static List<Languages> languageList() {
    return <Languages>[
      Languages(1, "EN", "en"),
      Languages(2, "RU", "ru"),
      Languages(3, "KZ", "kk"),
    ];
  }
}
