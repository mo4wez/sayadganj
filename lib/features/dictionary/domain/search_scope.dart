enum SearchScope {
  containsHeadword('گال ءِ تہ ءَ'),
  startsWith('بندات گوں'),
  inDefinitions('بزانت ءِ تہ ءَ');

  final String label;
  const SearchScope(this.label);
}
