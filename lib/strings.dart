import 'package:flutter/material.dart';

class S {
  final String code;
  S._(this.code);

  static S of(BuildContext context) {
    final lc = Localizations.maybeLocaleOf(context)?.languageCode ?? 'bn';
    return S._(lc);
  }

  bool get _bn => code == 'bn';

  // Home (hero)
  String get homeHeadline => _bn
      ? 'বীজ থেকে ফসল পর্যন্ত বাঙ্গি চাষের সম্পূর্ণ গাইড'
      : 'Complete Muskmelon Guide: Seed to Harvest';
  String get homeSub => _bn
      ? 'সহজ ভাষায় চাষের ধাপ, রোগ প্রতিরোধ, রেসিপি ও সহায়তা'
      : 'Simple steps, pests, recipes & support—made easy';
  String get ctaStart => _bn ? 'শুরু করুন' : 'Get Started';

  // Quick cards
  String get qcStepsTitle => _bn ? 'চাষের ধাপ' : 'Step Guide';
  String get qcStepsSub   => _bn ? 'বীজ, মাটি, বপন, পরিচর্যা, সংগ্রহ' : 'Seed, soil, sowing, care, harvest';
  String get qcPestTitle  => _bn ? 'রোগ ও পোকার সমস্যা' : 'Pests & Remedies';
  String get qcPestSub    => _bn ? 'লক্ষণ, প্রতিকার ও করণীয়' : 'Symptoms & remedies';
  String get qcRecTitle   => _bn ? 'রেসিপি' : 'Recipes';
  String get qcRecSub     => _bn ? 'বাঙ্গি দিয়ে সুস্বাদু খাবার' : 'Delicious muskmelon dishes';
  String get qcSupTitle   => _bn ? 'সহায়তা' : 'Support';
  String get qcSupSub     => _bn ? 'যোগাযোগ ও পরামর্শ' : 'Contact & advice';

  // Weather
  String get weatherTitle => _bn ? 'আজকের আবহাওয়া' : 'Today’s Weather';
  String get temp         => _bn ? 'তাপমাত্রা' : 'Temp';
  String get humidity     => _bn ? 'আর্দ্রতা' : 'Humidity';
  String get rain         => _bn ? 'বৃষ্টির সম্ভাবনা' : 'Rain chance';

  // Tips
  String get todaysTip    => _bn ? 'আজকের টিপস' : 'Today’s Tip';

  // Bottom bar
  String get tabHome      => _bn ? 'গৃহপাতা' : 'Home';
  String get tabSteps     => _bn ? 'ধাপসমূহ' : 'Steps';
  String get tabPests     => _bn ? 'রোগ-পোকা' : 'Pests';
  String get tabRecipes   => _bn ? 'রেসিপি' : 'Recipes';
  String get tabSupport   => _bn ? 'সহায়তা' : 'Support';

  // Lang labels
  String get langBn       => 'বাংলা';
  String get langEn       => 'English';
}
