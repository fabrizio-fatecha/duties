/// A single row of the bundled tariff CSV (assets/data.csv).
///
/// Columns beyond [ncm]/[description] are read positionally because the
/// source file's header only names 11 of the 13 columns actually present.
/// Header order: NCM;DESCRIPCION;AEC;ANV;OMC;LISTA;INTRA;EXTRA;IVA;RENTA;ISC
/// (plus an unnamed trailing "regime note" column at index 11).
class TariffRecord {
  final int id;
  final String ncm;
  final String description;
  final String aec;
  final String anv;
  final String omc;
  final String lista;
  final String intra;
  final String extra;
  final String iva;
  final String renta;
  final String isc;
  final String regimen;
  final String descriptionLower;

  TariffRecord({
    required this.id,
    required this.ncm,
    required this.description,
    required this.aec,
    required this.anv,
    required this.omc,
    required this.lista,
    required this.intra,
    required this.extra,
    required this.iva,
    required this.renta,
    required this.isc,
    required this.regimen,
  }) : descriptionLower = description.toLowerCase();

  factory TariffRecord.fromRow(int id, List<dynamic> row) {
    String field(int index) => index < row.length ? row[index].toString().trim() : '';

    return TariffRecord(
      id: id,
      ncm: field(0),
      description: field(1),
      aec: field(2),
      anv: field(3),
      omc: field(4),
      lista: field(5),
      intra: field(6),
      extra: field(7),
      iva: field(8),
      renta: field(9),
      isc: field(10),
      regimen: field(11),
    );
  }
}
