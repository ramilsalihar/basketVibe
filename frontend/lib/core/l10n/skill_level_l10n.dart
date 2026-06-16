import 'package:basketvibe/core/l10n/app_localizations.dart';

/// Maps a stored skill-level slug (beginner/intermediate/advanced/pro)
/// to its localized display label.
extension SkillLevelL10n on AppLocalizations {
  String skillLevelLabel(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return skillBeginner;
      case 'intermediate':
        return skillIntermediate;
      case 'advanced':
        return skillAdvanced;
      case 'pro':
        return skillPro;
      default:
        return level;
    }
  }
}
