import 'dart:math';

import 'package:get_it/get_it.dart';

/// Service that provides random content for various UI elements.
class RandomService {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  /// Returns a new instance of RandomService from the GetIt service locator.
  static RandomService get locateFactory =>
      GetIt.I.get(instanceName: 'randomService#factory');

  /// Registers a factory for RandomService with the GetIt service locator.
  static void registerFactory() => GetIt.I.registerFactory(
    RandomService.new,
    instanceName: 'randomService#factory',
  );

  /// Returns the singleton instance of RandomService from the GetIt service locator.
  static RandomService get locateSingleton =>
      GetIt.I.get(instanceName: 'randomService#singleton');

  /// Registers a lazy singleton for RandomService with the GetIt service locator.
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(
    RandomService.new,
    instanceName: 'randomService#singleton',
  );

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  final _random = Random();
  final _adjectives = [
    'Cozy',
    'Sunny',
    'Happy',
    'Peaceful',
    'Vibrant',
    'Warm',
    'Snug',
    'Modern',
    'Rustic',
    'Charming',
    'Secluded',
    'Relaxed',
    'Quiet',
    'Lively',
    'Busy',
    'Creative',
    'Friendly',
    'Inviting',
    'Comfy',
    'Cheerful',
    'Serene',
    'Quaint',
    'Tranquil',
    'Cute',
    'Shared',
  ];

  final _nouns = [
    'Haven',
    'Den',
    'Spot',
    'Corner',
    'Pad',
    'Nest',
    'Hub',
    'Crew',
    'Squad',
    'Place',
    'Lodge',
    'Retreat',
    'Sanctuary',
    'Oasis',
    'Hideaway',
    'Headquarters',
    'Base',
    'Cottage',
    'Dwelling',
    'Castle',
    'Cabin',
    'Abode',
    'Hangout',
    'Family',
    'Home',
  ];

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  /// Returns a randomly generated household name.
  ///
  /// Combines a random adjective with a random noun from predefined lists.
  String get randomHouseholdName {
    final adjective = _adjectives[_random.nextInt(_adjectives.length)];
    final noun = _nouns[_random.nextInt(_nouns.length)];

    return '$adjective $noun';
  }
}
