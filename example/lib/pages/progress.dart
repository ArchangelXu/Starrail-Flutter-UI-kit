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
                  const SizedBox(width: 16),
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
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Sliders",
                style: TextStyle(
                  fontSize: 18,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const _Divider(),
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
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Progress bar",
                style: TextStyle(
                  fontSize: 18,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const _Divider(),
            SizedBox(
              height: 40,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        color: srCardBackgroundDark,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SRSlider(
                          value: _progressValue,
                          onChanged: (value) {
                            setState(() {
                              _progressValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      color: srCardBackground,
                      child: SizedBox(
                        width: 188,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SRProgressBar(
                              progress: _progressValue,
                              labelBuilder: (progress) =>
                                  sprintf("%.1f%% Completed", [progress * 100]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const _Divider(),
            const SizedBox(height: 16),
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
      color: const Color(0xFFABABAB),
    );
  }
}
