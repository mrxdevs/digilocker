class MeonAccessDetails {
  final String accessToken;
  final String state;

  const MeonAccessDetails({required this.accessToken, required this.state});

  //Get props
  List<Object?> get props => [accessToken, state];
}
