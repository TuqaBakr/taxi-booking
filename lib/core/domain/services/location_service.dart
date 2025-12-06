
import 'package:location/location.dart';

// نسميها LocationService بدلاً من جعل الدوال ثابتة
class LocationService {
  final Location _location;

  // Constructor لاستقبال Location بدلاً من جعلها ثابتة (لأغراض DI والاختبار)
  LocationService(this._location);

  // 1. دالة الحصول على تدفق تحديثات الموقع (تبقى كما هي)
  Stream<LocationData> get locationStream {
    try {
      return _location.onLocationChanged;
    } catch (e) {
      // يفضل ترك Exception هنا أو استخدام Failure في طبقة أعلى
      throw Exception("Failed to get location stream: $e");
    }
  }

  // 2. دالة التحقق وطلب الصلاحيات (تبقى كما هي)
  Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) return false;
    }

    return true;
  }

  // 3. دالة الحصول على الموقع الحالي (تبقى كما هي)
  Future<LocationData?> getCurrentLocation() async {
    try {
      // يجب التحقق من الصلاحيات قبل الطلب لتقليل احتمالية الخطأ
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      return await _location.getLocation();
    } catch (e) {
      // يمكن استخدام logger هنا
      return null;
    }
  }
}