import 'dart:typed_data';

import 'package:bydgoszcz/core/network/openai_service.dart';
import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Prosty widget audio playera z opcją:
/// - audioAssetPath - ścieżka do pliku MP3 w assets
/// - text - tekst do zamiany na mowę przez OpenAI TTS
///
/// Wygląd: przycisk PLAY/STOP z loaderem podczas ładowania
class SimpleAudioPlayer extends StatefulWidget {
  /// Ścieżka do pliku MP3 w assets (opcjonalna)
  final String? audioAssetPath;

  /// Tekst do odczytania przez TTS (opcjonalny)
  final String? text;

  /// Label wyświetlany obok przycisku
  final String label;

  /// Kolor przycisku
  final Color? color;

  const SimpleAudioPlayer({
    super.key,
    this.audioAssetPath,
    this.text,
    this.label = 'Posłuchaj',
    this.color,
  }) : assert(
         audioAssetPath != null || text != null,
         'Either audioAssetPath or text must be provided',
       );

  @override
  State<SimpleAudioPlayer> createState() => _SimpleAudioPlayerState();
}

class _SimpleAudioPlayerState extends State<SimpleAudioPlayer> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isGeneratingTTS = false;
  bool _hasError = false;
  Uint8List? _ttsAudioBytes;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen(_onPlayerStateChanged);
  }

  @override
  void deactivate() {
    // Stop audio when widget is removed from the tree (before navigation)
    if (_isPlaying) {
      _audioPlayer.stop();
    }
    super.deactivate();
  }

  void _onPlayerStateChanged(PlayerState state) {
    if (!mounted) return;

    setState(() {
      _isPlaying = state.playing;

      // Update loading state based on processing state
      if (state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering) {
        _isLoading = true;
      } else if (state.processingState == ProcessingState.ready ||
          state.processingState == ProcessingState.completed ||
          state.processingState == ProcessingState.idle) {
        _isLoading = false;
      }
    });

    // Auto-reset when finished
    if (state.processingState == ProcessingState.completed) {
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.pause();
    }
  }

  /// Public method to stop audio from parent widgets
  void stopAudio() {
    if (_isPlaying) {
      _audioPlayer.stop();
      _audioPlayer.seek(Duration.zero);
    }
  }

  @override
  void dispose() {
    // Ensure audio is stopped before disposing
    if (_isPlaying) {
      _audioPlayer.stop();
    }
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayStop() async {
    if (_isLoading) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
        await _audioPlayer.seek(Duration.zero);
      } else {
        setState(() {
          _isLoading = true;
          _hasError = false;
        });

        if (widget.audioAssetPath != null) {
          await _audioPlayer.setAsset(widget.audioAssetPath!);
          await _audioPlayer.play();
        } else if (widget.text != null) {
          if (_ttsAudioBytes == null) {
            setState(() => _isGeneratingTTS = true);

            final openAiService = getIt.get<OpenAiService>();
            _ttsAudioBytes = await openAiService.generateSpeech(
              text: widget.text!,
              voice: 'nova',
              speed: 0.9,
            );

            if (mounted) {
              setState(() => _isGeneratingTTS = false);
            }
          }

          // Set audio source and play immediately
          final audioSource = _AudioBytesSource(_ttsAudioBytes!);
          await _audioPlayer.setAudioSource(audioSource);
          await _audioPlayer.play();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isGeneratingTTS = false;
          _hasError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd odtwarzania: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? AppColors.primary;

    return GestureDetector(
      onTap: _togglePlayStop,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _isPlaying
              ? buttonColor.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isPlaying
                ? buttonColor
                : AppColors.textDisabled.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Play/Stop button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _hasError ? AppColors.error : buttonColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: _isLoading || _isGeneratingTTS
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Icon(
                        _isPlaying
                            ? Icons.stop_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Label
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _isGeneratingTTS
                        ? 'Generuję bajkę...'
                        : _isLoading
                        ? 'Ładowanie...'
                        : _isPlaying
                        ? 'Kliknij, aby zatrzymać'
                        : _hasError
                        ? 'Spróbuj ponownie'
                        : 'Kliknij, aby posłuchać',
                    style: AppTypography.bodySmall.copyWith(
                      color: _hasError
                          ? AppColors.error
                          : _isGeneratingTTS
                          ? AppColors.accent
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Sound wave animation when playing
            if (_isPlaying) ...[
              const SizedBox(width: 12),
              _SoundWaveAnimation(color: buttonColor),
            ],
          ],
        ),
      ),
    );
  }
}

/// Custom audio source for playing from bytes
class _AudioBytesSource extends StreamAudioSource {
  final Uint8List _bytes;

  _AudioBytesSource(this._bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _bytes.length;
    return StreamAudioResponse(
      sourceLength: _bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}

/// Simple sound wave animation
class _SoundWaveAnimation extends StatefulWidget {
  final Color color;

  const _SoundWaveAnimation({required this.color});

  @override
  State<_SoundWaveAnimation> createState() => _SoundWaveAnimationState();
}

class _SoundWaveAnimationState extends State<_SoundWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = ((_controller.value + delay) % 1.0);
            final height = 8 + (value * 16);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 4,
              height: height,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}
