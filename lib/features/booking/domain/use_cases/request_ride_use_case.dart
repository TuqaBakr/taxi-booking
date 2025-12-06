class RequestRideUseCase {
  Future<void> call() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}