import 'package:admin_panel/common/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/domain/entities/chat_config.dart';
import 'package:admin_panel/domain/usecase/chat/get_chat_config.dart';
import 'package:admin_panel/domain/usecase/chat/set_chat_config.dart';
import 'package:admin_panel/service_locator.dart';
import 'package:admin_panel/common/cubit/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A screen allowing the admin to select and save the ChatGPT model.
class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final List<String> _models = [
    'gpt-3.5-turbo',
    'gpt-4',
    'gpt-4o',
  ];
  String? _selectedModel;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final cfg = await sl<GetChatConfigUseCase>().call();
      setState(() {
        _selectedModel = cfg.model;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _saveConfig() async {
    if (_selectedModel == null) return;
    setState(() {
      _isSaving = true;
    });
    try {
      final cfg = ChatConfig(model: _selectedModel!);
      await sl<SetChatConfigUseCase>().call(cfg);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuration saved')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text('Error: $_error'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select ChatGPT Model',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedModel,
                        items: _models
                            .map(
                              (m) => DropdownMenuItem(
                                value: m,
                                child: Text(m),
                              ),
                            )
                            .toList(),
                        onChanged: (m) => setState(() => _selectedModel = m),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isSaving ? null : _saveConfig,
                        child: _isSaving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Save'),
                      ),
                      ],
                  ),
                // Theme selector
                const SizedBox(height: 24),
                Text(
                  'Theme',
                  style: Theme.of(context).textTheme.headline6,
                ),
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, mode) {
                    return SwitchListTile(
                      title: Text(
                        mode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
                      ),
                      value: mode == ThemeMode.dark,
                      onChanged: (_) => context.read<ThemeCubit>().toggle(),
                      activeColor: Theme.of(context).colorScheme.primary,
                    );
                  },
                ),
      ),
    );
  }
}