import 'package:flutter/material.dart';

class PlasticRecyclingPage extends StatefulWidget {
  const PlasticRecyclingPage({super.key});

  @override
  State<PlasticRecyclingPage> createState() => _PlasticRecyclingPageState();
}

class _PlasticRecyclingPageState extends State<PlasticRecyclingPage> {
  int _currentStep = 0;
  bool _showQuiz = false;
  int _quizScore = 0;
  int _selectedQuizAnswer = -1;
  bool _quizSubmitted = false;

  final List<Map<String, dynamic>> _plasticTypes = [
    {
      'code': '1',
      'name': 'PET/PETE',
      'description': 'Botol minuman, wadah makanan',
      'recyclable': true,
      'recyclableInfo':
          'Mudah didaur ulang menjadi serat polyester, karpet, dan wadah makanan baru',
    },
    {
      'code': '2',
      'name': 'HDPE',
      'description': 'Botol susu, botol sampo',
      'recyclable': true,
      'recyclableInfo':
          'Sering didaur ulang menjadi botol baru, kayu plastik, dan pipa',
    },
    {
      'code': '3',
      'name': 'PVC',
      'description': 'Pipa, bungkus makanan',
      'recyclable': false,
      'recyclableInfo':
          'Sulit didaur ulang karena mengandung klorin yang berbahaya saat diproses',
    },
  ];

  final List<Map<String, dynamic>> _quizQuestions = [
    {
      'question': 'Plastik jenis apa yang paling mudah didaur ulang?',
      'answers': ['PET', 'PVC', 'PS', 'LDPE'],
      'correct': 0,
    },
    {
      'question': 'Apa simbol daur ulang untuk plastik HDPE?',
      'answers': ['1', '2', '3', '4'],
      'correct': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daur Ulang Plastik'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _showQuiz ? _buildQuizSection() : _buildMainContent(),
      floatingActionButton: _showQuiz
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _showQuiz = true;
                  _quizScore = 0;
                  _selectedQuizAnswer = -1;
                  _quizSubmitted = false;
                });
              },
              icon: const Icon(Icons.quiz),
              label: const Text('Kuis Daur Ulang'),
              backgroundColor: Colors.blue,
            ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Panduan Daur Ulang Plastik',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 2) {
                  setState(() {
                    _currentStep += 1;
                  });
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                }
              },
              steps: [
                Step(
                  title: const Text('Pemilahan Plastik'),
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilah plastik berdasarkan kode resin (angka dalam segitiga panah):',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.looks_one, color: Colors.blue),
                        title: Text('PET/PETE - Kode 1'),
                      ),
                      ListTile(
                        leading: Icon(Icons.looks_two, color: Colors.blue),
                        title: Text('HDPE - Kode 2'),
                      ),
                      ListTile(
                        leading: Icon(Icons.looks_3, color: Colors.blue),
                        title: Text('PVC - Kode 3'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Gunakan tooltip dengan menekan lama pada item untuk info lebih lanjut',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                ),
                Step(
                  title: const Text('Pembersihan'),
                  content: const Text(
                    'Bersihkan plastik dari sisa makanan atau minuman. Tidak perlu bersih sempurna, tetapi pastikan tidak ada sisa yang banyak.',
                    style: TextStyle(fontSize: 16),
                  ),
                  isActive: _currentStep >= 1,
                ),
                Step(
                  title: const Text('Penyerahan ke Bank Sampah'),
                  content: const Text(
                    'Bawa plastik yang sudah dipilah ke bank sampah terdekat atau tempat pengumpulan daur ulang. Pastikan plastik kering sebelum diserahkan.',
                    style: TextStyle(fontSize: 16),
                  ),
                  isActive: _currentStep >= 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Jenis Plastik dan Kemampuan Daur Ulang',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          ..._plasticTypes
              .map((plastic) => _buildPlasticTypeCard(plastic))
              .toList(),
          const SizedBox(height: 20),
          _buildRecyclingFacts(),
        ],
      ),
    );
  }

  Widget _buildPlasticTypeCard(Map<String, dynamic> plastic) {
    return Tooltip(
      message: plastic['recyclableInfo'],
      waitDuration: const Duration(seconds: 1),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Center(
              child: Text(
                plastic['code'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          title: Text(
            plastic['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(plastic['description']),
          trailing: Icon(
            plastic['recyclable'] ? Icons.check_circle : Icons.cancel,
            color: plastic['recyclable'] ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildRecyclingFacts() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.lightbulb, color: Colors.blue),
              title: Text(
                'Fakta Menarik:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const Divider(),
            _buildFactItem('1 botol plastik bisa terurai dalam 450 tahun!'),
            _buildFactItem('Daur ulang 1 ton plastik menghemat 5,774 kWh energi.'),
            _buildFactItem('Hanya 9% plastik di dunia yang benar-benar didaur ulang.'),
            _buildFactItem('Plastik daur ulang bisa jadi kaos, karpet, atau furnitur.'),
          ],
        ),
      ),
    );
  }

  Widget _buildFactItem(String text) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.adjust, size: 16, color: Colors.blue),
      title: Text(text),
    );
  }

  Widget _buildQuizSection() {
    final currentQuestion =
        _quizQuestions[_quizScore < _quizQuestions.length ? _quizScore : 0];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kuis Daur Ulang Plastik',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: _quizQuestions.isEmpty
                ? 0
                : (_quizScore / _quizQuestions.length),
            backgroundColor: Colors.blue[100],
            color: Colors.blue,
            minHeight: 10,
          ),
          const SizedBox(height: 20),
          if (_quizScore < _quizQuestions.length) ...[
            Text(
              'Pertanyaan ${_quizScore + 1}/${_quizQuestions.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  currentQuestion['question'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(currentQuestion['answers'].length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  elevation: 2,
                  color: _quizSubmitted
                      ? (index == currentQuestion['correct']
                          ? Colors.green[50]
                          : (_selectedQuizAnswer == index
                              ? Colors.red[50]
                              : Colors.white))
                      : (_selectedQuizAnswer == index
                          ? Colors.blue[50]
                          : Colors.white),
                  child: ListTile(
                    title: Text(currentQuestion['answers'][index]),
                    onTap: _quizSubmitted
                        ? null
                        : () {
                            setState(() {
                              _selectedQuizAnswer = index;
                            });
                          },
                    trailing: _quizSubmitted
                        ? (index == currentQuestion['correct']
                            ? const Icon(Icons.check, color: Colors.green)
                            : (_selectedQuizAnswer == index
                                ? const Icon(Icons.close, color: Colors.red)
                                : null))
                        : (_selectedQuizAnswer == index
                            ? const Icon(Icons.radio_button_checked,
                                color: Colors.blue)
                            : const Icon(Icons.radio_button_unchecked,
                                color: Colors.grey)),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            if (!_quizSubmitted)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ), 
                onPressed: _selectedQuizAnswer == -1
                    ? null
                    : () {
                        setState(() {
                          _quizSubmitted = true;
                          if (_selectedQuizAnswer ==
                              currentQuestion['correct']) {
                            _quizScore++;
                          }
                        });
                      },
                child: const Text('Submit Jawaban'),
              )
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ), 
                onPressed: () {
                  setState(() {
                    _selectedQuizAnswer = -1;
                    _quizSubmitted = false;
                    if (_quizScore >= _quizQuestions.length) {
                      _showQuiz = false;
                      _quizScore = 0;
                    }
                  });
                },
                child: Text(
                  _quizScore < _quizQuestions.length
                      ? 'Pertanyaan Berikutnya'
                      : 'Selesai',
                ),
              ),
          ] else ...[
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.celebration,
                        size: 60, color: Colors.blue),
                    const SizedBox(height: 20),
                    const Text(
                      'Selamat!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Skor Anda: $_quizScore/${_quizQuestions.length}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ), // <= Tutup styleFrom
              onPressed: () {
                setState(() {
                  _showQuiz = false;
                  _quizScore = 0;
                  _selectedQuizAnswer = -1;
                  _quizSubmitted = false;
                });
              },
              child: const Text('Kembali ke Materi'),
            ),
          ],
        ],
      ),
    );
  }
}
