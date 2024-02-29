class OtpArguments {
  final String? otpType, phoneNo, phoneCode, countryCode, phoneVerificationId;
  final int? userId;

  OtpArguments({
    this.otpType,
    this.userId,
    this.phoneNo,
    this.phoneCode,
    this.countryCode,
    this.phoneVerificationId,
  });
}
