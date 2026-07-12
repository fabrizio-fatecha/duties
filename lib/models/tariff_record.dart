/// A single row of the bundled tariff CSV (assets/data.csv).
///
/// Columns beyond [ncm]/[description] are read positionally because the
/// source file's header only names 11 of the 13 columns actually present.
class TariffRecord {
  final int id;
  final String ncm;
  final String description;
  final String aec;
  final String iva;
  final String regimen;
  final String descriptionLower;

  TariffRecord({
    required this.id,
    required this.ncm,
    required this.description,
    required this.aec,
    required this.iva,
    required this.regimen,
  }) : descriptionLower = description.toLowerCase();

  factory TariffRecord.fromRow(int id, List<dynamic> row) {
    String field(int index) => index < row.length ? row[index].toString().trim() : '';

    return TariffRecord(
      id: id,
      ncm: field(0),
      description: field(1),
      aec: field(2),
      iva: field(8),
      regimen: field(11),
    );
  }
}
