import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/date_utils.dart';
import '../data/database.dart';
import '../theme/theme.dart';
import 'pop_calendar.dart';
import 'pop_tappable.dart';

/// Journal → PDF export (Settings "Export journal"). The user picks a date
/// range, then we build a paginated keepsake PDF (entries in their chosen
/// journal font + alignment) and hand it to the system share sheet.
Future<void> showJournalExportDialog(
  BuildContext context, {
  required AppDatabase db,
  required JournalFont font,
  required JournalAlignment alignment,
  required DateTime accountCreated,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Export journal',
    barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
    transitionDuration: AppMotion.pop,
    pageBuilder: (ctx, _, _) => _ExportDialog(
      db: db,
      font: font,
      alignment: alignment,
      accountCreated: accountCreated,
    ),
    transitionBuilder: (_, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: AppMotion.curvePop);
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(curved), child: child),
      );
    },
  );
}

class _ExportDialog extends StatefulWidget {
  const _ExportDialog({
    required this.db,
    required this.font,
    required this.alignment,
    required this.accountCreated,
  });
  final AppDatabase db;
  final JournalFont font;
  final JournalAlignment alignment;
  final DateTime accountCreated;

  @override
  State<_ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<_ExportDialog> {
  late DateTime _from = dateOnly(widget.accountCreated);
  late DateTime _to = dateOnly(DateTime.now());
  bool _busy = false;

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showGeneralDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Pick a date',
      barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
      transitionDuration: AppMotion.pop,
      pageBuilder: (ctx, _, _) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 340,
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
            decoration: popSurface(
                fill: AppColors.paper, radius: AppRadii.lg, stroke: 3),
            child: PopCalendar(
              selectedDate: isFrom ? _from : _to,
              firstDate: DateTime(now.year - 3),
              lastDate: now,
              onSelect: (d) => Navigator.of(ctx).pop(dateOnly(d)),
            ),
          ),
        ),
      ),
      transitionBuilder: (_, anim, _, child) {
        final curved = CurvedAnimation(parent: anim, curve: AppMotion.curvePop);
        return FadeTransition(
            opacity: anim,
            child: ScaleTransition(
                scale: Tween(begin: 0.6, end: 1.0).animate(curved),
                child: child));
      },
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _from = picked;
        if (_to.isBefore(_from)) _to = _from;
      } else {
        _to = picked;
        if (_from.isAfter(_to)) _from = _to;
      }
    });
  }

  Future<void> _export() async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      final entries = await widget.db.journalEntriesInRange(_from, _to);
      if (entries.isEmpty) {
        navigator.pop();
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text('No journal entries in that range.')));
        return;
      }
      final bytes = await buildJournalPdf(
        entries: entries,
        font: widget.font,
        alignment: widget.alignment,
        from: _from,
        to: _to,
      );
      navigator.pop();
      await Printing.sharePdf(bytes: bytes, filename: 'OptiLife-Journal.pdf');
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
          decoration:
              popSurface(fill: AppColors.paper, radius: AppRadii.lg, stroke: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Export Journal',
                  textAlign: TextAlign.center,
                  style: AppType.display.copyWith(fontSize: 22)),
              const SizedBox(height: 4),
              Text('Save a date range as a PDF.',
                  textAlign: TextAlign.center,
                  style:
                      AppType.caption.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 18),
              _dateRow('From', _from, () => _pickDate(isFrom: true)),
              const SizedBox(height: 10),
              _dateRow('To', _to, () => _pickDate(isFrom: false)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: PopTappable(
                      onTap: _busy ? null : () => Navigator.of(context).pop(),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: popSurface(
                            fill: AppColors.haze,
                            radius: AppRadii.pill,
                            stroke: 2.5,
                            shadow: false),
                        child: Text('Cancel',
                            style: AppType.label.copyWith(fontSize: 15)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PopTappable(
                      onTap: _busy ? null : _export,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: popSurface(
                            fill: AppColors.popPurple,
                            radius: AppRadii.pill,
                            stroke: 2.5),
                        child: _busy
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.4, color: Colors.white))
                            : Text('Export PDF',
                                style: AppType.label.copyWith(
                                    fontSize: 15, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateRow(String label, DateTime date, VoidCallback onTap) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(label,
              style: AppType.label
                  .copyWith(fontSize: 14, color: AppColors.textMuted)),
        ),
        Expanded(
          child: PopTappable(
            onTap: onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: popSurface(
                  fill: AppColors.haze,
                  radius: AppRadii.md,
                  stroke: 2,
                  shadow: false),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      size: 15, color: AppColors.ink),
                  const SizedBox(width: 8),
                  Text(_shortDate(date),
                      style: AppType.body.copyWith(fontSize: 15)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────── PDF builder ────────────────────────────────

const _weekdays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
];
const _months = [
  'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
  'September', 'October', 'November', 'December'
];

String _longDate(DateTime d) =>
    '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';
String _shortDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

int _wordCount(String s) =>
    s.trim().isEmpty ? 0 : s.trim().split(RegExp(r'\s+')).length;

Future<pw.Font> _loadFont(String asset, pw.Font fallback) async {
  try {
    return pw.Font.ttf(await rootBundle.load(asset));
  } catch (_) {
    return fallback; // variable-font edge cases shouldn't break the export
  }
}

/// Builds the journal PDF bytes. Public so it can be unit-tested / reused.
Future<Uint8List> buildJournalPdf({
  required List<JournalEntry> entries,
  required JournalFont font,
  required JournalAlignment alignment,
  required DateTime from,
  required DateTime to,
}) async {
  final heading =
      await _loadFont('assets/fonts/Fredoka-Variable.ttf', pw.Font.helveticaBold());
  final body = font == JournalFont.handwriting
      ? await _loadFont('assets/fonts/Caveat-Variable.ttf', pw.Font.times())
      : await _loadFont('assets/fonts/Lora-Variable.ttf', pw.Font.times());
  final bodySize = font == JournalFont.handwriting ? 17.0 : 12.0;
  final align = alignment == JournalAlignment.right
      ? pw.TextAlign.right
      : pw.TextAlign.left;

  const ink = PdfColor.fromInt(0xFF1A1626);
  const purple = PdfColor.fromInt(0xFF7C4DFF);
  const muted = PdfColor.fromInt(0xFF9B8FB0);
  const cream = PdfColor.fromInt(0xFFFFF7EC);

  final totalWords =
      entries.fold<int>(0, (sum, e) => sum + _wordCount(e.body));

  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(46, 46, 46, 52),
      footer: (ctx) => pw.Container(
        alignment: pw.Alignment.center,
        margin: const pw.EdgeInsets.only(top: 12),
        child: pw.Text('${ctx.pageNumber} / ${ctx.pagesCount}',
            style: pw.TextStyle(font: heading, fontSize: 9, color: muted)),
      ),
      build: (ctx) => [
        // ── title block ──
        pw.Text('OptiLife Journal',
            style: pw.TextStyle(font: heading, fontSize: 32, color: purple)),
        pw.SizedBox(height: 6),
        pw.Text(
          '${_shortDate(from)}  –  ${_shortDate(to)}',
          style: pw.TextStyle(font: heading, fontSize: 13, color: ink),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          '${entries.length} ${entries.length == 1 ? 'entry' : 'entries'} · $totalWords words',
          style: pw.TextStyle(font: heading, fontSize: 10, color: muted),
        ),
        pw.SizedBox(height: 14),
        pw.Divider(color: purple, thickness: 2),
        pw.SizedBox(height: 6),

        // ── entries ──
        for (final e in entries)
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 14),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: pw.BoxDecoration(
                    color: cream,
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Text(_longDate(e.date),
                      style: pw.TextStyle(
                          font: heading, fontSize: 12, color: purple)),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  e.body.trim(),
                  textAlign: align,
                  style: pw.TextStyle(
                      font: body,
                      fontSize: bodySize,
                      color: ink,
                      lineSpacing: 3),
                ),
              ],
            ),
          ),
      ],
    ),
  );
  return doc.save();
}
