import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Future<String> fetchYoutubeStreamUrl(String id) async{
  final yt = YoutubeExplode();
  final manifest = await yt.videos.streams.getManifest(id,
      // You can also pass a list of preferred clients, otherwise the library will handle it:
      ytClients: [
        YoutubeApiClient.androidVr,
      ]);

  // Print all the available streams.
  print('fetched url');
  final audio = manifest.audioOnly.withHighestBitrate();
  yt.close();
  return audio.url.toString();
}

Future<Stream<List<int>>> fetchAcutalStream(String id) async{
  final yt = YoutubeExplode();
  final manifest = await yt.videos.streams.getManifest(id,
      // You can also pass a list of preferred clients, otherwise the library will handle it:
      ytClients: [
        YoutubeApiClient.androidVr,
      ]);

  // Print all the available streams.
  print('fetched url');
  final audio = manifest.audioOnly.withHighestBitrate();
  var stream = yt.videos.streams.get(audio);
  yt.close();
  return stream;
}

Future<List<ClosedCaption>> fetchYoutubeClosedCaptions(String id) async{
  var yt = YoutubeExplode();

  var trackManifest = await yt.videos.closedCaptions.getManifest(id);

  var trackInfo = trackManifest.getByLanguage('en'); // Get english caption.

  // Get the actual closed caption track.
  if(trackInfo.isNotEmpty) {
    var track = await yt.videos.closedCaptions.get(trackInfo.first);
    var captions = track.captions;
    return captions;
  }
  return [];

}
 String getCaptionAtTime(List<ClosedCaption> captions, Duration time) {
for (var caption in captions) {
if (
time.inMilliseconds <= caption.end.inMilliseconds) {
return caption.text;
}
}
return "";
}