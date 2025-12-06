import 'dart:io';

/// A utility function to read a JSON file from the test/fixtures directory.
///
/// Used for loading mock data (fixtures) into unit tests.
/// Example: `final json = fixture('initial_data.json');`
String fixture(String name) => File('test/fixtures/$name').readAsStringSync();