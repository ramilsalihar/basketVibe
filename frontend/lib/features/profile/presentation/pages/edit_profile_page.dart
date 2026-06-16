import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/features/profile/domain/entities/profile_entity.dart';
import 'package:basketvibe/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:basketvibe/core/l10n/app_localizations.dart';
import 'package:basketvibe/core/l10n/skill_level_l10n.dart';

/// Form for editing the current user's profile details.
///
/// Expects a [ProfileCubit] above it (pass via BlocProvider.value).
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.profile});

  final ProfileEntity profile;

  static const skillLevels = ['beginner', 'intermediate', 'advanced', 'pro'];

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late String _skillLevel;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.displayName);
    _cityController = TextEditingController(
      text: widget.profile.city == '—' ? '' : widget.profile.city,
    );
    _skillLevel =
        EditProfilePage.skillLevels.contains(widget.profile.skillLevel)
            ? widget.profile.skillLevel
            : EditProfilePage.skillLevels.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ProfileCubit>().updateProfile(
          userId: widget.profile.id,
          displayName: _nameController.text.trim(),
          city: _cityController.text.trim(),
          skillLevel: _skillLevel,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileEdit)),
      body: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.profileName,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? l10n.profileEnterName
                        : null,
              ),
              AppSpacing.gapMD,
              TextFormField(
                controller: _cityController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.profileCity,
                  prefixIcon: const Icon(Icons.location_city_rounded),
                ),
              ),
              AppSpacing.gapMD,
              DropdownButtonFormField<String>(
                initialValue: _skillLevel,
                decoration: InputDecoration(
                  labelText: l10n.profileSkillLevel,
                  prefixIcon: const Icon(Icons.sports_basketball_rounded),
                ),
                items: EditProfilePage.skillLevels
                    .map(
                      (level) => DropdownMenuItem(
                        value: level,
                        child: Text(l10n.skillLevelLabel(level)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _skillLevel = value);
                },
              ),
              AppSpacing.gapXL,
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_rounded, size: 20),
                label: Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
