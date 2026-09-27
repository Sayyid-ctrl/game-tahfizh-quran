import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  String? _currentUrl;

  bool get isPlaying => _isPlaying;
  String? get currentUrl => _currentUrl;

  AudioPlayerService() {
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
    });
  }

  Future<void> playAudioUrl(String url) async {
    try {
      if (_isPlaying && _currentUrl == url) {
        await _player.pause();
        return;
      }
      _currentUrl = url;
      await _player.stop();
      await _player.play(UrlSource(url));
    } catch (e) {
      if (kDebugMode) {
        print('Audio playback error: $e');
      }
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _currentUrl = null;
    } catch (e) {
      // Handle error
    }
  }

  void dispose() {
    _player.dispose();
  }
}
