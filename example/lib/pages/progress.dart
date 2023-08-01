import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/views/progress/bar.dart';
import 'package:starrail_ui/views/progress/slider.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  static const _sliderMax = 10;

  double _allValue = 1;
  double _bgmValue = 1;
  double _voiceValue = 0.7;
  double _soundValue = 0.5;
  double _progressValue = 0;

  @override
  void initState() {
    super.initState();
  }

  SizedBox _buildBgmBar({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: srCardBackgroundDark,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child:
                    Align(alignment: Alignment.centerLeft, child: Text(title)),
              ),
            ),
            Container(
              color: srCardBackground,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.volume_down_rounded,
                    size: 18,
                    color: srTextLight,
                  ),
                  SizedBox(
                    width: 120,
                    child: SRSlider(
                      value: value,
                      divisions: 10,
                      onChanged: onChanged,
                    ),
                  ),
                  SizedBox(
                    width: 18,
                    child: Center(
                      child: Text(
                        "${(value * _sliderMax).toInt()}",
                        style:
                            const TextStyle(fontSize: 14, color: srTextLight),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBgmBar(
              title: "Master",
              value: _allValue,
              onChanged: (value) {
                setState(() {
                  _allValue = value;
                });
              },
            ),
            const _Divider(),
            _buildBgmBar(
              title: "BGM",
              value: _bgmValue,
              onChanged: (value) {
                setState(() {
                  _bgmValue = value;
                });
              },
            ),
            const _Divider(),
            _buildBgmBar(
              title: "Voice",
              value: _voiceValue,
              onChanged: (value) {
                setState(() {
                  _voiceValue = value;
                });
              },
            ),
            const _Divider(),
            _buildBgmBar(
              title: "Sound",
              value: _soundValue,
              onChanged: (value) {
                setState(() {
                  _soundValue = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: SRSlider(
                      value: _progressValue,
                      onChanged: (value) {
                        setState(() {
                          _progressValue = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: SRProgressBar2(
                      progress: _progressValue,
                      labelBuilder: (progress) =>
                          sprintf("%.2f%% Completed", [progress * 100]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Color(0xFFABABAB),
    );
  }
}
