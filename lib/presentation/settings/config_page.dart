import 'dart:io';

import 'package:admin_panel/domain/usecase/chat/get_chat_config.dart';
import 'package:admin_panel/domain/usecase/chat/set_chat_config.dart';
import 'package:admin_panel/service_locator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdf_text/flutter_pdf_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:admin_panel/common/widgets/appbar.dart';
import 'package:admin_panel/presentation/settings/cubit/config_cubit.dart';
import 'package:admin_panel/common/cubit/theme_cubit.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ConfigCubit(
            sl<GetChatConfigUseCase>(),
            sl<SetChatConfigUseCase>(),
          ),
      child: const _ConfigView(),
    );
  }
}

class _ConfigView extends StatelessWidget {
  const _ConfigView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    return Scaffold(
      appBar: const BasicAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<ConfigCubit, ConfigState>(
          listenWhen: (p, c) => p.isSaving && !c.isSaving,
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuration saved')),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 600 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Model
                    Text(
                      'Select ChatGPT Model',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: state.selectedModel,
                      items:
                          ConfigCubit.availableModels
                              .map(
                                (m) =>
                                    DropdownMenuItem(value: m, child: Text(m)),
                              )
                              .toList(),
                      onChanged:
                          state.isSaving
                              ? null
                              : (m) =>
                                  context.read<ConfigCubit>().selectModel(m),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Temperature
                    Text(
                      'Temperature: ${(state.temperature ?? 1.0).toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Slider(
                      value: state.temperature ?? 1.0,
                      min: 0.0,
                      max: 2.0,
                      divisions: 10,
                      label: (state.temperature ?? 1.0).toStringAsFixed(1),
                      onChanged:
                          state.isSaving
                              ? null
                              : (v) => context
                                  .read<ConfigCubit>()
                                  .selectTemperature(v),
                    ),

                    const SizedBox(height: 24),

                    // System Prompt
                    Text(
                      'System Prompt',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: state.systemPrompt,
                      maxLines: 3,
                      enabled: !state.isSaving,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter system‐role prompt',
                      ),
                      onChanged:
                          (v) =>
                              context.read<ConfigCubit>().selectSystemPrompt(v),
                    ),

                    const SizedBox(height: 24),

                    // PDF Loader
                    Text(
                      'Load PDF Document',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text('Load PDF'),
                          onPressed:
                              state.isSaving
                                  ? null
                                  : () async {
                                    final result = await FilePicker.platform
                                        .pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf'],
                                        );
                                    if (result != null &&
                                        result.files.single.path != null) {
                                      final path = result.files.single.path!;
                                      final pdfDoc = await PDFDoc.fromFile(
                                        File(path),
                                      );
                                      final text = await pdfDoc.text;
                                      context
                                          .read<ConfigCubit>()
                                          .selectPdfContent(text);
                                    }
                                  },
                        ),
                        const SizedBox(width: 12),
                        if (state.pdfContent != null)
                          const Text(
                            'PDF Loaded',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Save
                    ElevatedButton(
                      onPressed:
                          state.isSaving
                              ? null
                              : () => context.read<ConfigCubit>().saveConfig(),
                      child:
                          state.isSaving
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

                    const SizedBox(height: 24),

                    // Theme toggle
                    Text(
                      'Theme',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder:
                          (context, mode) => SwitchListTile(
                            title: Text(
                              mode == ThemeMode.dark
                                  ? 'Dark Mode'
                                  : 'Light Mode',
                            ),
                            value: mode == ThemeMode.dark,
                            onChanged:
                                (_) => context.read<ThemeCubit>().toggle(),
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
