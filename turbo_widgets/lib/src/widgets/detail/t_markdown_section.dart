import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TMarkdownSection extends StatefulWidget {
  const TMarkdownSection({
    required this.title,
    required this.content,
    required this.onChanged,
    super.key,
    this.caption,
    this.onSave,
    this.saveLabel = 'Save',
    this.sectionSpacing = 12,
    this.editorMinHeight = 240,
  });

  final String title;
  final String? caption;
  final String content;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSave;
  final String saveLabel;
  final double sectionSpacing;
  final double editorMinHeight;

  @override
  State<TMarkdownSection> createState() => _TMarkdownSectionState();
}

class _TMarkdownSectionState extends State<TMarkdownSection> {
  late final QuillController _controller;
  bool _isPreview = false;
  String _lastContent = '';

  @override
  void initState() {
    super.initState();
    _lastContent = widget.content;
    _controller = QuillController(
      document: Document()..insert(0, widget.content),
      selection: const TextSelection.collapsed(offset: 0),
    )..addListener(_handleContentChange);
  }

  @override
  void didUpdateWidget(covariant TMarkdownSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.content != _lastContent) {
      _lastContent = widget.content;
      _controller.document = Document()..insert(0, widget.content);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleContentChange() {
    final text = _controller.document.toPlainText();
    _lastContent = text;
    widget.onChanged(text);
  }

  void _setPreview(bool value) {
    if (_isPreview == value) return;
    setState(() {
      _isPreview = value;
    });
    _controller.readOnly = value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TMarkdownSectionHeader(
            title: widget.title,
            caption: widget.caption,
            theme: theme,
            onSave: widget.onSave,
            saveLabel: widget.saveLabel,
          ),
          SizedBox(height: widget.sectionSpacing),
          _TMarkdownSectionToggle(
            isPreview: _isPreview,
            onEdit: () => _setPreview(false),
            onPreview: () => _setPreview(true),
          ),
          const SizedBox(height: 12),
          _TMarkdownEditorContainer(
            minHeight: widget.editorMinHeight,
            theme: theme,
            child: _isPreview
                ? SizedBox(
                    height: widget.editorMinHeight,
                    child: QuillEditor.basic(
                      controller: _controller,
                      config: const QuillEditorConfig(),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QuillSimpleToolbar(
                        controller: _controller,
                        config: const QuillSimpleToolbarConfig(),
                      ),
                      SizedBox(
                        height: widget.editorMinHeight,
                        child: QuillEditor.basic(
                          controller: _controller,
                          config: const QuillEditorConfig(),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _TMarkdownSectionHeader extends StatelessWidget {
  const _TMarkdownSectionHeader({
    required this.title,
    required this.theme,
    this.caption,
    this.onSave,
    this.saveLabel = 'Save',
  });

  final String title;
  final String? caption;
  final ShadThemeData theme;
  final VoidCallback? onSave;
  final String saveLabel;

  @override
  Widget build(BuildContext context) {
    final showSave = onSave != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.large.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (caption != null) ...[
                const SizedBox(height: 4),
                Text(
                  caption!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.muted,
                ),
              ],
            ],
          ),
        ),
        if (showSave) ...[
          const SizedBox(width: 12),
          ShadButton(
            onPressed: onSave,
            child: Text(saveLabel),
          ),
        ],
      ],
    );
  }
}

class _TMarkdownSectionToggle extends StatelessWidget {
  const _TMarkdownSectionToggle({
    required this.isPreview,
    required this.onEdit,
    required this.onPreview,
  });

  final bool isPreview;
  final VoidCallback onEdit;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShadButton.outline(
          size: ShadButtonSize.sm,
          onPressed: onEdit,
          child: Text(isPreview ? 'Edit' : 'Editing'),
        ),
        const SizedBox(width: 8),
        ShadButton.outline(
          size: ShadButtonSize.sm,
          onPressed: onPreview,
          child: Text(isPreview ? 'Previewing' : 'Preview'),
        ),
      ],
    );
  }
}

class _TMarkdownEditorContainer extends StatelessWidget {
  const _TMarkdownEditorContainer({
    required this.child,
    required this.theme,
    required this.minHeight,
  });

  final Widget child;
  final ShadThemeData theme;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.border,
        ),
      ),
      child: child,
    );
  }
}
