import 'package:admin_panel/common/widgets/appbar.dart';
import 'package:admin_panel/presentation/settings/cubit/config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/domain/entities/chat_config.dart';
import 'package:admin_panel/domain/usecase/chat/get_chat_config.dart';
import 'package:admin_panel/domain/usecase/chat/set_chat_config.dart';
import 'package:admin_panel/service_locator.dart';
import 'package:admin_panel/common/cubit/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// A screen allowing the admin to select and save the ChatGPT model.
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
          listener: (context, state) {
            if (state.error != null && !state.isLoading && !state.isSaving) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            }
            // On successful save (no error and just finished saving)
            if (!state.isSaving && state.error == null) {
              // Avoid showing on load
              // You can add additional flags if needed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuration saved')),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null && state.selectedModel == null) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return Padding(
              padding:
                  isDesktop
                      ? const EdgeInsets.symmetric(horizontal: 200)
                      : const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select ChatGPT Model',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: state.selectedModel,
                    items:
                        ConfigCubit.availableModels
                            .map(
                              (m) => DropdownMenuItem(value: m, child: Text(m)),
                            )
                            .toList(),
                    onChanged:
                        state.isSaving
                            ? null
                            : (m) => context.read<ConfigCubit>().selectModel(m),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                  // Theme switch remains unchanged
                  Text('Theme', style: Theme.of(context).textTheme.bodyMedium),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
