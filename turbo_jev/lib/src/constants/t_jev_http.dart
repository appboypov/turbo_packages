/// Paths, header names and wire formats of the TypeSafe HTTP API.
abstract final class TJevHttp {
  /// The System One endpoint that answers Questions about State.
  static const systemOnePath = '/v1/systemone';

  /// The endpoint that lists the models of the account.
  static const modelsPath = '/v1/models';

  /// The lowest HTTP status of a successful response.
  static const minSuccessStatus = 200;

  /// The highest HTTP status of a successful response.
  static const maxSuccessStatus = 299;

  /// The HTTP status of a Request TypeSafe rejected as invalid.
  static const badRequestStatus = 400;

  /// The HTTP status of a Request whose API key TypeSafe did not accept.
  static const unauthorizedStatus = 401;

  /// The HTTP status of a Request the API key may not make.
  static const forbiddenStatus = 403;

  /// The HTTP status of a Request for something TypeSafe did not find.
  static const notFoundStatus = 404;

  /// The HTTP status of a Request whose body does not match its schema.
  static const unprocessableEntityStatus = 422;

  /// The HTTP status of a Request refused by the rate limit.
  static const tooManyRequestsStatus = 429;

  /// The lowest HTTP status of a server error.
  static const minServerErrorStatus = 500;

  /// The media type of JSON bodies.
  static const jsonMediaType = 'application/json';

  /// The media type of multipart bodies, which carry Images.
  static const multipartMediaType = 'multipart/form-data';

  /// The media type parameter that names the boundary of a multipart body.
  static const boundaryParameter = 'boundary';

  /// The number of random bytes of a multipart boundary, written as twice
  /// as many lowercase hex digits.
  static const boundaryBytes = 16;

  /// The text that opens a multipart boundary line, and also closes the
  /// last one.
  static const boundaryDelimiter = '--';

  /// The line break of multipart framing.
  static const lineBreak = '\r\n';

  /// The disposition of each multipart part.
  static const formDataDisposition = 'form-data';

  /// The disposition parameter that holds the name of a multipart part.
  static const nameParameter = 'name';

  /// The disposition parameter that holds the file name of a multipart
  /// part.
  static const filenameParameter = 'filename';

  /// The name of the multipart part that holds the JSON of a Request.
  static const requestPartName = 'request';

  /// The prefix of the name of each multipart part that holds an Image,
  /// followed by its number from 0.
  static const imagePartPrefix = 'asset-';

  /// The text an Image Reference starts with, followed by its id.
  static const imageReferencePrefix = '<image:';

  /// The text an Image Reference ends with.
  static const imageReferenceSuffix = '>';

  /// The number of random bytes of an Image Reference id, written as twice
  /// as many lowercase hex digits.
  static const imageReferenceIdBytes = 16;

  /// Matches an Image Reference.
  static final imageReferencePattern = RegExp(
    '${RegExp.escape(imageReferencePrefix)}'
    '[0-9a-f]{${imageReferenceIdBytes * 2}}'
    '${RegExp.escape(imageReferenceSuffix)}',
  );

  /// The content encoding of compressed bodies.
  static const gzipEncoding = 'gzip';

  /// The smallest body, in bytes, that is compressed where compression is
  /// available.
  static const minCompressedBodyBytes = 1024;

  /// The response header that holds the request id.
  static const requestIdHeader = 'x-typesafe-request-id';

  /// The response header that holds a retry delay in milliseconds.
  static const retryAfterMsHeader = 'retry-after-ms';

  /// The response header that holds a retry delay in seconds or as an HTTP
  /// date.
  static const retryAfterHeader = 'retry-after';

  /// The request header that carries the API key as bearer auth.
  static const authorizationHeader = 'Authorization';

  /// The scheme that starts the value of [authorizationHeader], followed by
  /// the API key.
  static const bearerPrefix = 'Bearer ';

  /// The request header that asks for a JSON response.
  static const acceptHeader = 'Accept';

  /// The request header that names the media type of the body.
  static const contentTypeHeader = 'Content-Type';

  /// The multipart part header that names the disposition of the part.
  static const contentDispositionHeader = 'Content-Disposition';

  /// The request header that names the compression of the body.
  static const contentEncodingHeader = 'Content-Encoding';

  /// The request header that names the client software.
  static const userAgentHeader = 'User-Agent';

  /// The request header that names the SDK and its version.
  static const sdkHeader = 'X-TypeSafe-SDK';

  /// The request header that names the runtime and its platform.
  static const runtimeHeader = 'X-TypeSafe-Runtime';

  /// The request header that numbers a retry: 1 for the first retry.
  static const retryCountHeader = 'X-TypeSafe-Retry-Count';

  /// The Danger Zone header that raises the context limits to 262k tokens.
  static const longContextHeader = 'TypeSafe-Danger-Zone-Long-Context';

  /// The Danger Zone header that a Request with an Image or a Box sends.
  static const imagesHeader = 'TypeSafe-Danger-Zone-Images';

  /// The value of a Danger Zone header that opts in to it.
  static const dangerZoneOptIn = 'true';

  /// The lowercase names of the headers only the SDK sets.
  static final protectedHeaders = Set<String>.unmodifiable({
    for (final name in [
      authorizationHeader,
      acceptHeader,
      contentTypeHeader,
      contentEncodingHeader,
      userAgentHeader,
      sdkHeader,
      runtimeHeader,
      retryCountHeader,
    ])
      name.toLowerCase(),
  });

  /// The field of an error response that holds the error, as a string or
  /// as an object with a [messageKey].
  static const errorKey = 'error';

  /// The field of an error response or its error that holds the message.
  static const messageKey = 'message';

  /// The field of an error response that holds its detail, as a string, as
  /// an object with a [messageKey] or as a list of validation details.
  static const detailKey = 'detail';

  /// The field of a validation detail that holds its message.
  static const detailMessageKey = 'msg';

  /// The field of a validation detail that holds its location.
  static const detailLocationKey = 'loc';

  /// The first entry of a validation detail location in the Request body.
  static const bodyLocation = 'body';

  /// The field of a System One response that holds the Answers by Question
  /// id.
  static const answersKey = 'answers';

  /// The field of an Answer that names its Question type.
  static const typeKey = 'type';

  /// The field of a Choice or Score Answer that holds the probability of
  /// each Option or Level.
  static const probabilitiesKey = 'probabilities';

  /// The field of a Score Answer that holds the description of each Level.
  static const legendKey = 'legend';
}
