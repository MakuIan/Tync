import 'package:flutter/material.dart';

class CreateSessionDialog extends StatefulWidget {
  const CreateSessionDialog({super.key});

  @override
  State<CreateSessionDialog> createState() => _CreateSessionDialogState();
}

class _CreateSessionDialogState extends State<CreateSessionDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Training'),
      content: TextField(
        controller: _nameController,
        autofocus: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Name (eg. Arms/Legs)',
          labelText: 'Training name',
        ),
        onSubmitted: (value) => Navigator.pop(context, value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, _nameController.text);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
