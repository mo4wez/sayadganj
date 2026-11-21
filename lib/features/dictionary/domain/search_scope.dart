enum SearchScope {
  containsHeadword('لبز ءِ تها'),
  startsWith('بندات گوں'),
  inDefinitions('مانا ءِ تها');

  final String label;
  const SearchScope(this.label);
}
