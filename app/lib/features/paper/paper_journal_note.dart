import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/format.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/paper.pb.dart';
import '../../l10n/app_localizations.dart';
import 'paper_providers.dart';

class PaperJournalNoteEditor extends ConsumerStatefulWidget {
  const PaperJournalNoteEditor({super.key, required this.receiptId, required this.note, required this.connected});

  final Int64 receiptId;
  final PaperJournalNote? note;
  final bool connected;

  @override
  ConsumerState<PaperJournalNoteEditor> createState() => _PaperJournalNoteEditorState();
}

class _PaperJournalNoteEditorState extends ConsumerState<PaperJournalNoteEditor> {
  final _text = TextEditingController();
  final _signal = CancelableSignal();
  PaperJournalNote? _confirmed;
  Int64 _expected = Int64.ZERO;
  bool _editing = false;
  bool _saving = false;
  Object? _error;

  // Keep the server's save response visible until receipt polling catches up.
  PaperJournalNote? get _note =>
      (_confirmed?.revision ?? Int64.ZERO) > (widget.note?.revision ?? Int64.ZERO) ? _confirmed : widget.note;

  @override
  void dispose() {
    _signal.cancel();
    _text.dispose();
    super.dispose();
  }

  void _edit() {
    final saved = _note;
    setState(() {
      _text.text = saved?.text ?? '';
      _expected = saved?.revision ?? Int64.ZERO;
      _error = null;
      _editing = true;
    });
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final result = await ref
          .read(paperClientProvider)
          .savePaperJournalNote(
            SavePaperJournalNoteRequest(receiptId: widget.receiptId, text: _text.text, expectedRevision: _expected),
            signal: TimeoutSignal(const Duration(seconds: 15), parent: _signal),
          );
      if (!mounted) return;
      setState(() {
        _confirmed = result.note;
        _editing = false;
      });
      ref.invalidate(paperReceiptProvider(widget.receiptId));
    } catch (error) {
      if (mounted) {
        setState(() => _error = error);
        ref.invalidate(paperReceiptProvider(widget.receiptId));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final note = _note;
    final savedText = note?.text ?? '';
    final draft = _text.text.trim();
    final changedElsewhere = (note?.revision ?? Int64.ZERO) != _expected;
    final recoveredSave = note?.revision == _expected + Int64.ONE && savedText == draft;
    return SectionCard(
      title: l.paperJournalNote,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_editing && !recoveredSave) ...[
            TextField(
              controller: _text,
              decoration: InputDecoration(labelText: l.paperJournalNote),
              minLines: 2,
              maxLines: 5,
              maxLength: 1000,
              enabled: !_saving,
              onChanged: (_) => setState(() {}),
            ),
            if (changedElsewhere)
              WarningBanner(l.paperJournalNoteConflict)
            else if (_error case final error?)
              WarningBanner(errorText(error)),
            Wrap(
              spacing: AppSpace.sm,
              children: [
                FilledButton(
                  onPressed: widget.connected && !_saving && !changedElsewhere && draft != savedText ? _save : null,
                  child: Text(_saving ? l.paperSaving : l.paperJournalNoteSave),
                ),
                TextButton(onPressed: _saving ? null : () => setState(() => _editing = false), child: Text(l.cancel)),
              ],
            ),
          ] else ...[
            if (savedText.isNotEmpty && note != null) ...[
              Text(savedText),
              Wrap(
                spacing: AppSpace.sm,
                children: [Text(l.paperJournalNoteSavedAt), Mono('${fmtDateTime(utcMs(note.recordedAtUnixMs))} UTC')],
              ),
            ],
            OutlinedButton(
              onPressed: widget.connected && !_saving ? _edit : null,
              child: Text(savedText.isEmpty ? l.paperJournalNoteAdd : l.paperJournalNoteEdit),
            ),
          ],
        ],
      ),
    );
  }
}
