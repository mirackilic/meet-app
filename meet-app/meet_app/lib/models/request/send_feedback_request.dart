class SendFeedbackRequest {
  int rate;
  String? featureName;

  SendFeedbackRequest({required this.rate, this.featureName});

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "featureName": featureName,
      };
}
