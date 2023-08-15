import 'package:flutter/material.dart';

class CollapsibleSection extends StatefulWidget {
  const CollapsibleSection({
    super.key,
    required this.title,
    required this.children,
    required this.initiallyExpanded,
    required this.onExpansionChanged,
  });

  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final Function(bool isExpanded)? onExpansionChanged;

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: ExpansionTile(
        title: Text(widget.title),
        initiallyExpanded: widget.initiallyExpanded,
        onExpansionChanged: widget.onExpansionChanged,
        children: widget.children,
      ),
    );
  }
}
