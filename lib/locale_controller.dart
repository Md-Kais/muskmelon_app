import 'package:flutter/material.dart';

/// Global simple locale notifier (bn ↔ en)
final ValueNotifier<Locale> appLocale =
    ValueNotifier<Locale>(const Locale('bn', 'BD'));
