enum RequestConstants {
  VALIDATED_BODY_DATA._("validatedBodyData"),
  VALIDATED_URL_PARAMS_DATA._("validatedUrlParamsData"),
  VALIDATED_QUERY_PARAMS_DATA._("validatedQueryParamsData"),
  AUTHENTICATED_AUTH_ID._("authenticatedAuthId");

  const RequestConstants._(this.value);
  final String value;
}
