import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tariff_record.dart';
import '../providers/locale_provider.dart';
import 'record_detail_dialog.dart';

const _rowColorA = Color(0xFF161616);
const _rowColorB = Color(0xFF1E1E1E);

class ResultTile extends StatelessWidget {
  const ResultTile({super.key, required this.record, required this.isEven});

  final TariffRecord record;
  final bool isEven;

  @override
  Widget build(BuildContext context) {
    final strings = context.watch<LocaleProvider>().strings;

    return Material(
      color: isEven ? _rowColorA : _rowColorB,
      child: ListTile(
        title: Text(record.description),
        subtitle: Text('${strings.ncmLabel}: ${record.ncm}'),
        onTap: () => showRecordDetailDialog(context, record),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (record.aec.isNotEmpty) Text('AEC ${record.aec}%'),
                if (record.iva.isNotEmpty) Text('IVA ${record.iva}'),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.visibility_outlined),
              onPressed: () => showRecordDetailDialog(context, record),
            ),
          ],
        ),
      ),
    );
  }
}
