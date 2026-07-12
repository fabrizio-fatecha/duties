import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tariff_record.dart';
import '../providers/locale_provider.dart';
import 'record_detail_dialog.dart';

class ResultTile extends StatelessWidget {
  const ResultTile({super.key, required this.record});

  final TariffRecord record;

  @override
  Widget build(BuildContext context) {
    final strings = context.watch<LocaleProvider>().strings;

    return ListTile(
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
    );
  }
}
