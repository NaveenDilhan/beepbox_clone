import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/scheduler.dart';

class MusicBoxPage extends StatefulWidget {
  const MusicBoxPage({super.key});

  @override
  _MusicBoxPageState createState() => _MusicBoxPageState();
}

class _MusicBoxPageState extends State<MusicBoxPage> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  int currentStep = 0;
  late Ticker _ticker;
  final AudioPlayer _audioPlayer = AudioPlayer();

  static const int numSteps = 16;
  static const int numNotes = 8;
  final List<bool> grid = List.generate(numSteps * numNotes, (index) => false);

  final Map<String, String> noteToSound = {
    'C4': 'piano/C4.wav',
    'D4': 'piano/D4.wav',
    'E4': 'piano/E4.wav',
    'F4': 'piano/F4.wav',
    'G4': 'piano/G4.wav',
    'A4': 'piano/A4.wav',
    'B4': 'piano/B4.wav',
    'C5': 'piano/C5.wav',
  };

  final List<String> notes = ['C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4', 'C5'];

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      int step = (elapsed.inMilliseconds ~/ 300) % numSteps;
      if (step != currentStep) {
        setState(() {
          currentStep = step;
        });

        for (int i = 0; i < numNotes; i++) {
          int index = currentStep + (i * numSteps);
          if (grid[index]) {
            _playNote(notes[i]);
          }
        }
      }
    });
  }

  void toggleNote(int index) {
    setState(() {
      grid[index] = !grid[index];
    });
  }

  Future<void> _playNote(String note) async {
    if (!noteToSound.containsKey(note)) return;
    try {
      await _audioPlayer.play(AssetSource(noteToSound[note]!));
    } catch (e) {
      debugPrint('Error playing $note: $e');
    }
  }

  void _startSequencer() {
    if (isPlaying) return;
    setState(() {
      isPlaying = true;
      currentStep = 0;
    });
    _ticker.start();
  }

  void _stopSequencer() {
    _ticker.stop();
    setState(() {
      isPlaying = false;
      currentStep = 0;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  for (int i = 0; i < numNotes; i++) 
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            notes[i],
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: numSteps,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                            ),
                            itemCount: numSteps,
                            itemBuilder: (context, step) {
                              int index = step + (i * numSteps);
                              bool isActive = grid[index];
                              bool isCurrentStep = step == currentStep && isPlaying;

                              return GestureDetector(
                                onTap: () => toggleNote(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: isCurrentStep
                                        ? Colors.orange
                                        : (isActive ? Colors.blue : Colors.grey[800]),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isActive ? Colors.white : Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 40,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: isPlaying ? _stopSequencer : _startSequencer,
                ),
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.stop),
                  onPressed: _stopSequencer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
