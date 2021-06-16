import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';

ByteData createByteData(int len) {
  var ints = Uint8List(len);
  for (var i = 0; i < len; i++) {
    ints[i] = i % len;
  }
  return ByteData.view(ints.buffer);
}

void main() {
  var client = Client('http://localhost:8080/');

  setUp(() {
  });

  group('Database cloud storage', () {
    test('Store file 1', () async {
      await client.cloudStorage.storePublicFile('testdir/myfile1.bin', createByteData(256));
    });

    test('Store file 2', () async {
      await client.cloudStorage.storePublicFile('testdir/myfile2.bin', createByteData(256));
    });

    test('Replace file 1', () async {
      await client.cloudStorage.storePublicFile('testdir/myfile1.bin', createByteData(128));
    });

    test('Retrieve file 1', () async {
      var byteData = await client.cloudStorage.retrievePublicFile('testdir/myfile1.bin');
      expect(byteData!.lengthInBytes, equals(128));
    });

    test('Retrieve file 2', () async {
      var byteData = await client.cloudStorage.retrievePublicFile('testdir/myfile2.bin');
      expect(byteData!.lengthInBytes, equals(256));
    });

    test('Retrieve non existing file', () async {
      var byteData = await client.cloudStorage.retrievePublicFile('testdir/myfile3.bin');
      expect(byteData, isNull);
    });
  });
}